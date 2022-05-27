//
//  Data.swift
//  Whoppah
//
//  Created by Eddie Long on 09/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

extension NSData {
    enum WriteError: Error {
        case failed
    }

    func writeToURL(named: String, overwrite: Bool = true, completion: @escaping (Result<URL, Error>) -> Void) {
        let tmpURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(named)

        DispatchQueue.global(qos: .userInteractive).async {
            if overwrite {
                if FileManager.default.fileExists(atPath: tmpURL.path) {
                    do {
                        try FileManager.default.removeItem(at: tmpURL)
                    } catch {
                        completion(.failure(error))
                        return
                    }
                }
            }

            do {
                try self.write(to: tmpURL, options: .atomic)
            } catch {
                return completion(.failure(WriteError.failed))
            }

            var isDir: ObjCBool = false
            guard FileManager.default.fileExists(atPath: tmpURL.path, isDirectory: &isDir) else {
                return completion(.failure(WriteError.failed))
            }

            return completion(.success(tmpURL))
        }
    }

    func writeToURLSynchronous(named: String, overwrite: Bool = true) -> Result<URL, Error> {
        let tmpURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(named)
        if overwrite {
            if FileManager.default.fileExists(atPath: tmpURL.path) {
                do {
                    try FileManager.default.removeItem(at: tmpURL)
                } catch {
                    return .failure(error)
                }
            }
        }

        do {
            try write(to: tmpURL, options: .atomic)
        } catch {
            return .failure(WriteError.failed)
        }

        var isDir: ObjCBool = false
        guard FileManager.default.fileExists(atPath: tmpURL.path, isDirectory: &isDir) else {
            return .failure(WriteError.failed)
        }

        return .success(tmpURL)
    }
}
