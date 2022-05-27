//
//  UIImageView.swift
//  Whoppah
//
//  Created by Eddie Long on 12/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Kingfisher
import MessengerKit
import RxCocoa
import RxSwift
import UIKit
import WhoppahCore
import SwiftUI

let tag = 4242

// MARK: Animated loading icon

extension UIImageView {
    @discardableResult
    func setupLoadingSpinner() -> UIImageView {
        let imageView = UIImageView()
        imageView.tag = tag
        let images: [UIImage] = [#imageLiteral(resourceName: "loading_spinner_6"), #imageLiteral(resourceName: "loading_spinner_7"), #imageLiteral(resourceName: "loading_spinner_8"), #imageLiteral(resourceName: "loading_spinner_1"), #imageLiteral(resourceName: "loading_spinner_2"), #imageLiteral(resourceName: "loading_spinner_3"), #imageLiteral(resourceName: "loading_spinner_4"), #imageLiteral(resourceName: "loading_spinner_5")]
        imageView.animationImages = images
        imageView.animationDuration = 0.7
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 8.0
        let imageDefaultSize: CGFloat = 48.0
        let width = bounds.size.width > imageDefaultSize + padding * 2 ? imageDefaultSize : bounds.size.width - padding * 2
        imageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: width).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor,
                                           constant: 0).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor,
                                           constant: 0).isActive = true

        return imageView
    }

    func showLoading() {
        let imageView = getViewWithTag(tag) ?? setupLoadingSpinner()
        imageView.isVisible = true
        if !imageView.isAnimating {
            imageView.startAnimating()
        }
    }

    private func getViewWithTag(_ tag: Int) -> UIImageView? {
        for view in subviews {
            if let imageView = view as? UIImageView {
                if imageView.tag == tag {
                    return imageView
                }
            }
        }
        return nil
    }

    func hideLoading() {
        guard let imageView = getViewWithTag(tag) else { return }
        imageView.isVisible = false
        imageView.stopAnimating()
    }
}

extension UIImageView: Placeholder {}

// MARK: ImageOld loading from URL

extension UIImageView {
    static let defaultPlaceholder = R.image.image_placeholder()!
    static let defaultPlaceholderMedium = R.image.image_placeholder_med()!
    static let defaultPlaceholderSmall = R.image.image_placeholder_small()!
    static let defaultPlaceholderBackgroundColor = UIColor.smoke

    func getPlaceholderImage() -> UIImage {
        let largePlaceholder = UIImageView.defaultPlaceholder
        let mediumPlaceholder = UIImageView.defaultPlaceholderMedium
        let smallPlaceholder = UIImageView.defaultPlaceholderSmall
        var placeholder = largePlaceholder
        let isCircle = (layer.cornerRadius - bounds.size.width / 2) < CGFloat.ulpOfOne
        let margin: CGFloat = isCircle ? 0.45 : 0.2

        if frame.size.width >= placeholder.size.width + frame.size.width * margin {
            placeholder = largePlaceholder

        } else {
            if frame.size.width >= mediumPlaceholder.size.width + frame.size.width * margin {
                placeholder = mediumPlaceholder
            } else {
                if frame.size.width >= smallPlaceholder.size.width + frame.size.width * margin || frame.size.width == 0 {
                    placeholder = smallPlaceholder
                } else {
                    // Finally revert to a programatic image
                    placeholder = placeholder.scaledToMaxWidth(frame.size.width * (1.0 - margin))
                }
            }
        }
        return placeholder
    }

    func setImage(forUrl url: URL?, downsizeImage: Bool = false, completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) {
        guard let cacheKey = url?.absoluteString else { return }
        
        let cache = ImageCache.default
        
        let placeholder = getPlaceholderImage()
        contentMode = .scaleAspectFit
        var options: KingfisherOptionsInfo = []
        
        func onImageError(_ error: KingfisherError) {
            if error.isNotCurrentTask || error.isTaskCancelled { return }
            contentMode = .center
            image = placeholder
        }
        
        var isCached = false
        
        if downsizeImage {
            let processor = DownsamplingImageProcessor(size: bounds.size)
            let extras: KingfisherOptionsInfo = [.processor(processor),
                                                 .scaleFactor(UIScreen.main.scale),
                                                 .cacheOriginalImage]
            options.append(contentsOf: extras)
            
            isCached = cache.isCached(forKey: cacheKey,
                              processorIdentifier: processor.identifier)
        } else {
            isCached = cache.isCached(forKey: cacheKey)
        }
        
        if isCached {
            self.alpha = 0
            self.backgroundColor = .white
            
            cache.retrieveImage(forKey: cacheKey, completionHandler: { [weak self] result in
                switch result {
                case .success(let value):
                    self?.image = value.image
                    UIView.animate(withDuration: 0.2) { [weak self] in
                        self?.alpha = 1
                    }
                case .failure(let error):
                    onImageError(error)
                }
            })
        } else {
            options.append(.transition(.fade(0.2)))
            kf.setImage(with: url,
                        placeholder: placeholder,
                        options: options,
                        progressBlock: nil,
                        completionHandler: { [weak self] result in
                switch result {
                case .success:
                    self?.backgroundColor = .clear
                    UIView.animate(withDuration: 0.2) { [weak self] in
                        self?.backgroundColor = .white
                    }
                case let .failure(error):
                    onImageError(error)
                }

                completionHandler?(result)
            })
        }
    }

    private struct AssociateKey {
        static var imageLoadId = 145_634
    }

    private var imageLoadId: UUID? {
        get {
            ao_get(pkey: &AssociateKey.imageLoadId)
        }
        set { ao_set(newValue, pkey: &AssociateKey.imageLoadId) }
    }

    @discardableResult
    func loadImage(_ image: WhoppahCore.Image?, mediaCache: MediaCacheService) -> Bool {
        guard let image = image else {
            setImage(forUrl: nil)
            return false
        }
        if let url = image.asURL() {
            setImage(forUrl: url)
            return true
        }
        // While ads are being processed on the server we get back an empty url
        // For a brief period we can use the cached image which it is being processed
        // Handle table or collection view cell re-use
        // Cache the image id, check on image fetch
        imageLoadId = image.id
        let cacheKey = mediaCache.getCacheKey(identifier: "\(image.id.uuidString)", type: .image)
        guard mediaCache.hasCachedItem(identifier: cacheKey) else {
            contentMode = .center
            self.image = getPlaceholderImage()
            return false
        }
        mediaCache.fetchImage(identifier: cacheKey, url: image.asURL(), expirySeconds: userGeneratedContentDurationSeconds) { [weak self] (result) -> Void in
            guard let self = self else { return }
            guard self.imageLoadId == image.id else { return }
            self.imageLoadId = nil
            switch result {
            case let .success(fetchedImage):
                self.image = fetchedImage
            case .failure:
                self.contentMode = .center
                self.image = self.getPlaceholderImage()
            }
        }

        return true
    }
}

// MARK: Avatar icons with placeholders

extension UIImageView {
    func setIcon(forUrl url: URL?, cacheKey: String? = nil, character: Character) {
        let placeholder = EmptyAvatarImage.create(letter: character, size: frame.size)
        // Some images return a valid url but aren't processed yet on Transloadit
        // To overcome this undesired breaking of images we use the Kingfisher cache temporarily
        // We load the image if a cache key is provided and the image is cached from the cache
        if let key = cacheKey, ImageCache.default.isCached(forKey: key) {
            ImageCache.default.retrieveImage(forKey: key) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case let .success(cacheFetch):
                        if let image = cacheFetch.image {
                            self?.image = image
                            self?.hideLoading()
                        } else {
                            // Failure - don't use the cache key again and attempt url loading
                            ImageCache.default.removeImage(forKey: key)
                            self?.setIcon(forUrl: url, cacheKey: nil, character: character)
                        }
                    case .failure:
                        // Failure - don't use the cache key again and attempt url loading
                        ImageCache.default.removeImage(forKey: key)
                        self?.setIcon(forUrl: url, cacheKey: nil, character: character)
                    }
                }
            }
            return
        }

        if let url = url {
            if !url.absoluteString.isEmpty {
                kf.setImage(with: url, placeholder: placeholder, options: [.transition(.fade(0.2))], completionHandler: { [weak self] _ in

                    self?.hideLoading()
                })
                return
            }
        }

        hideLoading()
        image = placeholder
    }
}

extension UIImageView {
    func loadChatAvatar(_ message: MSGMessage?) {
        guard let user = message?.user as? ChatUser, !user.isSender else { return }

        if let image = user.avatar {
            self.image = image
        } else if let url = user.avatarUrl, !url.absoluteString.isEmpty {
            kf.setImage(with: url, placeholder: EmptyAvatarImage.create(letter: user.getCharacterForAvatarIcon() ?? "A", size: frame.size))
        } else {
            image = EmptyAvatarImage.create(letter: user.getCharacterForAvatarIcon() ?? "A", size: frame.size)
        }
    }
}

extension Reactive where Base: UIImageView {
    /// Bindable sink for `hidden` property.
    public var imageUrl: Binder<URL?> {
        Binder(base) { view, url in
            view.setImage(forUrl: url)
        }
    }
}

// MARK: Shadow + Corner

extension UIImageView {
    func applyShadowWithCorner(containerView: UIView, cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true

        containerView.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowRadius = 2
        containerView.layer.masksToBounds = false
    }
}
