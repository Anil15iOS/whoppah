//
//  ProgressCancellable.swift
//  WhoppahCore
//
//  Created by Eddie Long on 06/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCoreNext

public protocol ProgressCancellable {
    func cancel()
    var progress: Observable<HTTPProgress> { get }
    func didSendBytes(forUrl url: URL, bytesWritten _: Int64, totalBytesWritten: Int64,
                      totalBytesExpectedToWrite: Int64)
}
