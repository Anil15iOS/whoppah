//
//  URLSessionDelegate+Extensions.swift
//  
//
//  Created by Dennis Ippel on 29/11/2021.
//

import Foundation

public extension URLSessionDelegate {
    func handleSSLCert(_: URLSession,
                       certData: NSData?,
                       didReceive challenge: URLAuthenticationChallenge,
                       completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        guard let certData = certData else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                var error: CFError?
                let evaluationSucceeded = SecTrustEvaluateWithError(serverTrust, &error)

                if evaluationSucceeded {
                    let certificateChainLen = SecTrustGetCertificateCount(serverTrust)
                    for i in 0 ..< certificateChainLen {
                        if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, i) {
                            let serverCertificateData = SecCertificateCopyData(serverCertificate)
                            let data = CFDataGetBytePtr(serverCertificateData)
                            let size = CFDataGetLength(serverCertificateData)
                            let serverCert = NSData(bytes: data, length: size)
                            if certData.isEqual(to: serverCert as Data) {
                                completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: serverTrust))
                                return
                            }
                        }
                    }
                }
            }
        }

        // Pinning failed
        completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
    }
}
