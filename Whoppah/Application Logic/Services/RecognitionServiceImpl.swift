//
//  RecognitionService.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/9/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore
import Resolver

class RecognitionServiceImpl: RecognitionService {
    @Injected private var http: HTTPServiceInterface

    func uploadImage(data: Data) -> Observable<RecognitionImageUploadState> {
        let request = RecognitionRequest(.uploadImage(image: data))
        return Observable.create { [unowned self] observer in
            let cancellable = self.http.upload(request: request, retryNumber: 0, completion: { (result: Result<Recognition, Error>) in
                switch result {
                case let .success(response):
                    observer.onNext(RecognitionImageUploadState.complete(result: response))
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            })

            observer.onNext(RecognitionImageUploadState.progress(state: cancellable.progress))

            return Disposables.create {
                cancellable.cancel()
            }
        }
    }
}
