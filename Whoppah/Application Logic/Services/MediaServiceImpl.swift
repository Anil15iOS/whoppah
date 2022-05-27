//
//  MediaService.swift
//  Whoppah
//
//  Created by Eddie Long on 11/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import Resolver
import WhoppahDataStore

final class MediaServiceImpl: NSObject, MediaService {
    
    @Injected private var http: HTTPServiceInterface
    @Injected private var apollo: ApolloService

    func uploadImage(data: Data, contentType: GraphQL.ContentType, objectId: UUID? = nil, type: String? = nil, position: Int?) -> Observable<ImageMediaUploadState> {
        let request = MediaRequest(.uploadImage(image: data,
                                               contentType: contentType,
                                               objectId: objectId,
                                               type: type,
                                               position: position))
        return Observable.create { [unowned self] observer in
            let cancellable = self.http.upload(request: request, retryNumber: 0, completion: { (result: Result<MediaUploadResponse, Error>) in
                switch result {
                case let .success(response):
                    observer.onNext(ImageMediaUploadState.complete(result: response.id))
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            })

            observer.onNext(ImageMediaUploadState.progress(state: cancellable.progress))

            return Disposables.create {
                cancellable.cancel()
            }
        }
    }

    func uploadVideo(data: Data, contentType: GraphQL.ContentType, objectId: UUID? = nil, position: Int?) -> Observable<ImageMediaUploadState> {
        let request = MediaRequest(.uploadVideo(video: data,
                                               contentType: contentType,
                                               objectId: objectId,
                                               position: position))
        return Observable.create { [unowned self] observer in
            let cancellable = self.http.upload(request: request, retryNumber: 0, completion: { (result: Result<MediaUploadResponse, Error>) in
                switch result {
                case let .success(response):
                    observer.onNext(ImageMediaUploadState.complete(result: response.id))
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            })

            observer.onNext(ImageMediaUploadState.progress(state: cancellable.progress))

            return Disposables.create {
                cancellable.cancel()
            }
        }
    }

    func deleteProductMedia(id: UUID, objectId: UUID) -> Observable<Void> {
        let query = GraphQL.ProductQuery(id: objectId, playlist: .hls)
        let mutation = GraphQL.RemoveMediaMutation(id: id)
        return apollo.apply(mutation: mutation, query: query, storeTransaction: { (_, cachedQuery: inout GraphQL.ProductQuery.Data) in
            cachedQuery.product?.fullImages.removeAll(where: { $0.id == id })
            cachedQuery.product?.thumbnails.removeAll(where: { $0.id == id })
            cachedQuery.product?.videos.removeAll(where: { $0.id == id })
        }).map { _ in
            ()
        }
    }

    func deleteMerchantMedia(id: UUID, type: MerchantImageType, objectId _: UUID) -> Observable<Void> {
        // REALLY don't like that this media service knows about this query...not sure how to implement it though
        // Need to have some sort of event broadcast when an item is removed
        let query = GraphQL.GetMeQuery()
        let mutation = GraphQL.RemoveMediaMutation(id: id)
        return apollo.apply(mutation: mutation, query: query, storeTransaction: { (_, cachedQuery: inout GraphQL.GetMeQuery.Data) in
            guard cachedQuery.me?.merchants.isEmpty == false else { return }
            if type == .avatar {
                cachedQuery.me?.merchants[0].avatar = nil
            } else if type == .cover {
                cachedQuery.me?.merchants[0].cover = nil
            }
        }).map { _ in
            ()
        }
    }

    func linkMediaToProduct(mediaId: UUID, objectId: UUID, position: Int) -> Observable<Void> {
        let input = GraphQL.MediaUpdateInput(position: position, contentType: .product, objectId: objectId)
        let mutation = GraphQL.UpdateMediaMutation(id: mediaId, input: input)
        return apollo.apply(mutation: mutation).map { result in
            if let errors = result.errors, let first = errors.first {
                throw first
            } else {
                return ()
            }
        }
    }
}
