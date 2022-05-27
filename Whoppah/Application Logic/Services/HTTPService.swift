//
//  HTTPService.swift
//  Whoppah
//
//  Created by Boris Sagan on 9/19/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import WhoppahCoreNext
import WhoppahModel
import Resolver

final class HTTPService: NSObject {
    // MARK: - Errors

    enum HTTPServiceError: Error {
        case preparingURLRequestError
    }
    
    @LazyInjected var appConfiguration: AppConfigurationProvider
    @LazyInjected var inAppNotifier: InAppNotifier
    @Injected var featureService: FeatureService
    @LazyInjected var userProvider: UserProviding

    // MARK: - Properties

    private var certData: NSData?
    private var config: URLSessionConfiguration
    private var connections = [URLRequest: HTTPActiveConnection]()
    private var connectionLock = NSLock()
    private lazy var session: URLSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)

    // MARK: - Initialization

    override required init() {
        config = URLSessionConfiguration.default
        // Shared cookies for csrf screws up Django and we get back 403 responses
        config.httpShouldSetCookies = false
        
        super.init()
        
        if featureService.sslPinningEnabled, let sslCertPath = appConfiguration.sslCertFile {
            certData = NSData(contentsOfFile: sslCertPath)
        }
    }
}

final class HTTPCancellable: NSObject, ProgressCancellable {
    var task: URLSessionTask?
    var progress: Observable<HTTPProgress> {
        _progress.compactMap { $0 }.asObservable()
    }

    private let _progress = BehaviorRelay<HTTPProgress?>(value: nil)
    private let id = UUID()

    init(task: URLSessionTask) {
        self.task = task
    }

    func cancel() {
        task?.cancel()
        task = nil
    }

    func didSendBytes(forUrl url: URL, bytesWritten _: Int64, totalBytesWritten: Int64,
                      totalBytesExpectedToWrite: Int64) {
        let fraction = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        let progress = HTTPProgress(id: id,
                                    request: url,
                                    fraction: Double(fraction),
                                    totalDownloaded: totalBytesWritten,
                                    totalSizeBytes: totalBytesExpectedToWrite)
        _progress.accept(progress)
    }
}

// MARK: - HTTPServiceInterface

extension HTTPService: HTTPServiceInterface {
    typealias HttpCompletion<T> = (Result<T, Error>) -> Void where T: Decodable, T: Encodable

    @discardableResult
    func execute<T>(request: HTTPRequestable, completion: @escaping HttpCompletion<T>) -> ProgressCancellable where T: Decodable, T: Encodable {
        return execute(request: request, retryNumber: 0, completion: completion)
    }

    @discardableResult
    func execute<T>(request: HTTPRequestable, retryNumber: Int, completion: @escaping HttpCompletion<T>) -> ProgressCancellable where T: Decodable, T: Encodable {
        let rq = try! prepareURLRequest(for: request, addBody: true) // swiftlint:disable:this force_try

        let dataTask = session.dataTask(with: rq, completionHandler: { [weak self] data, urlResponse, error in
            guard let self = self else { return completion(.failure(HTTPError.other)) }
            guard error == nil else {
                let nsError = error! as NSError
                return self.handleConnectionError(error: nsError, request: request, retryNumber: retryNumber, completion: completion)
            }

            guard let data = data else {
                return self.handleMissingData(request: request, retryNumber: retryNumber, completion: completion)
            }

            let response = urlResponse as! HTTPURLResponse
            let statusCode = (urlResponse as! HTTPURLResponse).statusCode

            // If the status code is invalid then we bail out here
            switch statusCode {
            case 204:
                // Empty 204 responses are special
                // They indicate success but don't contain any data
                // Our Result type expects type to be returned
                // We have a special model called EmptyResponse which works in this scenario
                if data.isEmpty {
                    if T.self as? EmptyResponse.Type != nil {
                        let emptyDecoder = JSONDecoder()
                        let text = "{}"
                        let emptyObject = try! emptyDecoder.decode(EmptyResponse.self, from: text.data(using: .utf8)!) // swiftlint:disable:this force_try
                        return completion(.success(emptyObject as! T))
                    }
                } else {
                    fallthrough
                }
            case 1 ... 299:
                break
            case 401:
                self.inAppNotifier.notify(.userLoggedOut)
                return completion(.failure(HTTPError.loggedOut))
            case 400...:
                let statusError = HTTPError.statusCode(url: rq.url!, code: statusCode, data: data)
                return completion(.failure(statusError))
            default:
                break
            }

            let parser = request.parser ?? HTTPJSONResponseParser()
            let result: Result<T, Error> = parser.parse(data: data, headers: response.allHeaderFields)
            switch result {
            case let .success(data):
                return completion(.success(data))
            case let .failure(error):
                return completion(.failure(HTTPError.jsonDecodeError(error: error)))
            }
        })

        dataTask.resume()
        return HTTPCancellable(task: dataTask)
    }

    @discardableResult
    func upload<T>(request: HTTPRequestable, retryNumber _: Int, completion: @escaping (Result<T, Error>) -> Void) -> ProgressCancellable where T: Decodable, T: Encodable {
        var rq = try! prepareURLRequest(for: request, addBody: true) // swiftlint:disable:this force_try
        rq.allowsConstrainedNetworkAccess = false
        rq.allowsCellularAccess = true
        rq.allowsExpensiveNetworkAccess = true

        let connection = HTTPActiveConnectionImpl(urlRequest: rq,
                                                  request: request,
                                                  certData: certData,
                                                  completion: completion) { [weak self] in
            guard let self = self else { return }
            self.connectionLock.sync {
                self.connections.removeValue(forKey: rq)
            }
        }
        let session = URLSession(configuration: config, delegate: connection, delegateQueue: nil)
        connection.session = session
        let task = connection.setup()
        let cancellable = HTTPCancellable(task: task)
        connection.cancellable = cancellable

        connectionLock.sync {
            connections[rq] = connection
        }
        task.resume()
        return cancellable
    }

    // MARK: - Private

    private func prepareURLRequest(for request: HTTPRequestable, addBody: Bool) throws -> URLRequest {
        let base = request.baseURL ?? appConfiguration.environment.baseUrl(appConfiguration.environment.host)
        let fullUrl = "\(base)\(request.path)"
        var urlRequest = URLRequest(url: URL(string: fullUrl)!)
        
        urlRequest.setValue(Locale.current.languageCode, forHTTPHeaderField: "Accept-Language")

        if let query = request.query {
            var queryItems = [URLQueryItem]()

            for queryItem in query {
                if let queryStr = queryItem.value as? String {
                    queryItems.append(URLQueryItem(name: queryItem.key, value: queryStr))
                } else if let queryStrArray = queryItem.value as? [String], !queryStrArray.isEmpty {
                    for queryStrItem in queryStrArray {
                        queryItems.append(URLQueryItem(name: queryItem.key, value: queryStrItem))
                    }
                } else {
                    throw HTTPServiceError.preparingURLRequestError
                }
            }

            guard var components = URLComponents(string: fullUrl) else {
                throw HTTPServiceError.preparingURLRequestError
            }

            components.queryItems = queryItems
            urlRequest.url = components.url
        }

        if addBody {
            if let body = request.body {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            }

            if let uploadRequest = request as? HTTPUploadRequestable {
                let boundary = generateBoundary()
                urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                let filename = uploadRequest.filename
                let mimeType = uploadRequest.mimeType
                let dataBody = generateBody(withParameters: uploadRequest.formData,
                                            media: uploadRequest.file,
                                            filename: filename,
                                            mimeType: mimeType,
                                            boundary: boundary)
                urlRequest.httpBody = dataBody
            }
        }

        appConfiguration.environment.headers.forEach { urlRequest.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
        request.headers?.forEach { urlRequest.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
        if let token = userProvider.accessToken {
            urlRequest.addValue(token, forHTTPHeaderField: "Authorization")
        }
        urlRequest.httpMethod = request.method.rawValue

        return urlRequest
    }

    private func generateBody(withParameters params: [String: Any]?, media: [String: Data]?, filename: String?, mimeType: String?, boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()

        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(String(describing: value) + lineBreak)")
            }
        }

        if let media = media {
            for (key, value) in media {
                guard let requestFilename = filename, let requestMimetype = mimeType else { continue }
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(requestFilename)\"\(lineBreak)")
                body.append("Content-Type: \(requestMimetype + lineBreak + lineBreak)")
                body.append(value)
                body.append(lineBreak)
            }
        }

        body.append("--\(boundary)--\(lineBreak)")
        return body
    }

    private func handleConnectionError<T>(error: NSError, request: HTTPRequestable, retryNumber: Int = 0, completion: @escaping HttpCompletion<T>) where T: Decodable, T: Encodable {
        switch error.code {
        case NSURLErrorTimedOut, NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost, NSURLErrorCannotConnectToHost:
            let nextRetry = retryNumber + 1
            if let maxRetries = request.maxRetries, nextRetry <= maxRetries {
                execute(request: request, retryNumber: nextRetry, completion: completion)
                return
            } else {
                fallthrough
            }
        default:
            let error = HTTPError.connectionError(error: error)
            return completion(.failure(error))
        }
    }

    private func handleMissingData<T>(request: HTTPRequestable, retryNumber: Int = 0, completion: @escaping HttpCompletion<T>) where T: Decodable, T: Encodable {
        let nextRetry = retryNumber + 1
        if let maxRetries = request.maxRetries, nextRetry < maxRetries {
            execute(request: request, retryNumber: nextRetry, completion: completion)
            return
        } else {
            let error = HTTPError.emptydata
            return completion(.failure(error))
        }
    }

    private func generateBoundary() -> String {
        "Boundary-\(NSUUID().uuidString)"
    }
}

extension HTTPService: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        handleSSLCert(session, certData: certData, didReceive: challenge, completionHandler: completionHandler)
    }
}

protocol HTTPActiveConnection {
    var request: HTTPRequestable { get }
}

final class HTTPActiveConnectionImpl<Element>: NSObject, HTTPActiveConnection, URLSessionDownloadDelegate, URLSessionDataDelegate where Element: Decodable, Element: Encodable {
    typealias ConnectionCompleted = () -> Void
    private let completion: HTTPService.HttpCompletion<Element>
    private let onConnectionFinished: ConnectionCompleted
    private var retryNumber = 0
    private let certData: NSData?
    private var data = Data()

    let urlRequest: URLRequest
    var cancellable: ProgressCancellable?
    let request: HTTPRequestable
    weak var session: URLSession!
    
    @Injected private var inAppNotifier: InAppNotifier

    init(urlRequest: URLRequest,
         request: HTTPRequestable,
         certData: NSData?,
         completion: @escaping HTTPService.HttpCompletion<Element>,
         onConnectionFinished: @escaping ConnectionCompleted) {
        self.urlRequest = urlRequest
        self.request = request
        self.completion = completion
        self.certData = certData
        self.onConnectionFinished = onConnectionFinished
        super.init()
    }

    func setup() -> URLSessionUploadTask {
        // Clear any previous data
        data = Data()

        // For some reason iOS is stripping out the headers
        let task = session.uploadTask(with: urlRequest, from: urlRequest.httpBody!)

        // Send an initial progress event
        cancellable?.didSendBytes(forUrl: urlRequest.url!, bytesWritten: 0, totalBytesWritten: 0, totalBytesExpectedToWrite: Int64(urlRequest.httpBody!.count))

        return task
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        handleSessionCompletion(session, task: task, didCompleteWithError: error)
        session.invalidateAndCancel()
        onConnectionFinished()
    }

    private func handleSessionCompletion(_: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard error == nil else {
            let nsError = error! as NSError
            return handleConnectionError(error: nsError, completion: completion)
        }

        guard !data.isEmpty else {
            return handleMissingData(completion: completion)
        }

        guard let urlResponse = task.response else { return }
        let response = urlResponse as! HTTPURLResponse
        let statusCode = (urlResponse as! HTTPURLResponse).statusCode

        // If the status code is invalid then we bail out here
        switch statusCode {
        case 1 ... 299:
            break
        case 401:
            inAppNotifier.notify(.userLoggedOut)
            let loggedOutError = HTTPError.loggedOut
            return completion(.failure(loggedOutError))
        case 400...:
            let statusError = HTTPError.statusCode(url: task.originalRequest!.url!, code: statusCode, data: data)
            return completion(.failure(statusError))
        default:
            break
        }

        let parser = request.parser ?? HTTPJSONResponseParser()
        let result: Result<Element, Error> = parser.parse(data: data, headers: response.allHeaderFields)
        switch result {
        case let .success(data):
            return completion(.success(data))
        case let .failure(error):
            return completion(.failure(HTTPError.jsonDecodeError(error: error)))
        }
    }

    func urlSession(_: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        guard let url = task.originalRequest?.url else { return }
        cancellable?.didSendBytes(forUrl: url, bytesWritten: bytesSent, totalBytesWritten: totalBytesSent, totalBytesExpectedToWrite: totalBytesExpectedToSend)
    }

    func urlSession(_: URLSession, dataTask _: URLSessionDataTask, didReceive data: Data) {
        self.data.append(data)
    }

    func urlSession(_: URLSession, downloadTask _: URLSessionDownloadTask, didFinishDownloadingTo _: URL) {}

    func urlSession(_: URLSession,
                    task _: URLSessionTask,
                    willPerformHTTPRedirection _: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {
        var new = request
        let lowerHeaders = new.allHTTPHeaderFields?.keys.map { $0.lowercased() } ?? []
        // Merge in the original headers - only adding if they don't exist in the new request
        urlRequest.allHTTPHeaderFields?.forEach { keyValue in
            if !lowerHeaders.contains(keyValue.key.lowercased()) {
                new.addValue(keyValue.value, forHTTPHeaderField: keyValue.key)
            }
        }
        completionHandler(new)
    }

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        handleSSLCert(session, certData: certData, didReceive: challenge, completionHandler: completionHandler)
    }

    // MARK: Private

    private func handleConnectionError<T>(error: NSError, completion: @escaping HTTPService.HttpCompletion<T>) where T: Decodable, T: Encodable {
        guard !retryConnection() else { return }
        let error = HTTPError.connectionError(error: error)
        return completion(.failure(error))
    }

    private func handleMissingData<T>(completion: @escaping HTTPService.HttpCompletion<T>) where T: Decodable, T: Encodable {
        guard !retryConnection() else { return }
        let error = HTTPError.emptydata
        return completion(.failure(error))
    }

    private func retryConnection() -> Bool {
        let nextRetry = retryNumber + 1
        guard let maxRetries = request.maxRetries, nextRetry <= maxRetries else { return false }
        retryNumber = nextRetry
        let task = setup()
        task.resume()
        return true
    }
}
