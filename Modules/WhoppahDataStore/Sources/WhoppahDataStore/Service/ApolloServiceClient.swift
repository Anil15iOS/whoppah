//
//  ApolloServiceClient.swift
//  
//
//  Created by Dennis Ippel on 29/11/2021.
//

import Apollo
import Combine
import Foundation
import Resolver
import WhoppahCoreNext
import WhoppahModel

// TODO: public so it can interface with the old architecture
public class ApolloServiceClient {
    public private(set) var client: ApolloClient!
    private var certificateData: NSData?
    private var userTokenCancellable: AnyCancellable?
    
    @LazyInjected var userProvider: UserProviding
    @LazyInjected var configurationProvider: AppConfigurationProvider
    
    public init() {
        var certificateHandler: SSLCertificateHandler?

        if let sslCerficatePath = configurationProvider.sslCertFile {
            let certificateData = NSData(contentsOfFile: sslCerficatePath)
            certificateHandler = SSLCertificateHandler(certificateData: certificateData)
            self.certificateData = certificateData
        }
        
        self.client = ApolloServiceClient.buildClient(environment: configurationProvider.environment,
                                                      token: userProvider.accessToken,
                                                      delegate: certificateHandler)
        
        userTokenCancellable = userProvider.$accessToken.sink { [weak self] token in
            guard let self = self else { return }

            self.client = ApolloServiceClient.buildClient(environment: self.configurationProvider.environment,
                                                           token: token,
                                                           delegate: certificateHandler)
        }
    }
    
    private static func buildClient(environment: AppEnvironment,
                                    token: String?,
                                    delegate: URLSessionDelegate?) -> ApolloClient
    {
        let configuration = URLSessionConfiguration.default
        
        configuration.httpAdditionalHeaders = ["Accept-Language": Foundation.Locale.current.languageCode ?? "en"]
        
        if let token = token {
            configuration.httpAdditionalHeaders?["Authorization"] = "\(token)"
        }

        // Add additional headers as needed
        let url = URL(string: environment.graphHost)!
        
        let cache =  InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let client = URLSessionClient(sessionConfiguration: configuration, callbackQueue: nil)
        let provider = NetworkInterceptorProvider(store: store, client: client)
        let requestChainTransport = RequestChainNetworkTransport(interceptorProvider: provider,
                                                                 endpointURL: url)
        let apolloClient = ApolloClient(networkTransport: requestChainTransport,
                                        store: store)

        apolloClient.cacheKeyForObject = { object in
            if let id = object["id"] as? String,
                let type = object["__typename"] as? String {
                return [id, type]
            }
            // No id or typename, don't do caching
            return nil
        }
        return apolloClient
    }
}

private class SSLCertificateHandler: NSObject, URLSessionDelegate {
    private var certificateData: NSData?
    
    init(certificateData: NSData?) {
        self.certificateData = certificateData
    }

    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        handleSSLCert(session, certData: certificateData,
                      didReceive: challenge,
                      completionHandler: completionHandler)
    }
}

private struct NetworkInterceptorProvider: InterceptorProvider {
    private let store: ApolloStore
    private let client: URLSessionClient
    
    init(store: ApolloStore,
         client: URLSessionClient) {
        self.store = store
        self.client = client
    }
    
    func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        return [
            MaxRetryInterceptor(),
            CacheReadInterceptor(store: self.store),
            NetworkFetchInterceptor(client: self.client),
            ResponseCodeInterceptor(),
            JSONResponseParsingInterceptor(cacheKeyForObject: self.store.cacheKeyForObject),
            AutomaticPersistedQueryInterceptor(),
            CacheWriteInterceptor(store: self.store)
        ]
    }
}
