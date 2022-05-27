//
//  EditAdViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 01/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Lightbox
import RxSwift
import UIKit
import WhoppahCore
import WhoppahCoreNext
import Resolver
import WhoppahDataStore

class MyAdStatisticsViewController: UIViewController {
    var viewModel: MyAdStatisticsViewModel?

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var mediaScrollView: UIScrollView!
    @IBOutlet var mediaCountView: UIView!
    @IBOutlet var mediaCountLabel: UILabel!
    @IBOutlet var visitsCountLabel: UILabel!
    @IBOutlet var likesCountLabel: UILabel!

    @IBOutlet var headerView: UIView!
    @IBOutlet var headerUnderlineView: UIView!
    @IBOutlet var backButton: UIButton!

    @IBOutlet var adBodyLabel: UILabel!
    @IBOutlet var adTitleLabel: UILabel!
    @IBOutlet var adStatusLabel: UILabel!
    @IBOutlet var repostAdButton: PrimaryLargeButton!
    @IBOutlet var declinedButton: PrimaryLargeButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var viewButton: UIButton!
    @IBOutlet var deleteButton: UIButton!

    // MARK: Privates

    @Injected private var mediaCache: MediaCacheService
    @Injected private var adCreator: ADCreator

    private var headerGradient: CAGradientLayer!

    private var mediaCount: Int = 0
    private var fullScreenItems: [LightboxImage] = []
    private var mediaScrollPage = 1

    private var adStatistics: AdStatisticsUIData?
    private let bag = DisposeBag()

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpHeaderView()
        setUpScrollView()
        setUpMediaScrollView()
        setUpViewModel()
        setUpButtons()
    }

    // MARK: - Private

    // MARK: - UI

    private func setUpScrollView() {
        scrollView.delegate = self
    }

    private func setUpMediaScrollView() {
        mediaScrollView.delegate = self
    }

    private func setUpButtons() {
        editButton.isUserInteractionEnabled = false
        deleteButton.isUserInteractionEnabled = false
        viewButton.isUserInteractionEnabled = false
        viewButton.rx.tap.bind { [weak self] in
            if let id = self?.adStatistics?.ID {
                Navigator().navigate(route: Navigator.Route.ad(id: id))
            }
        }.disposed(by: bag)
    }

    // MARK: - Data

    private func setUpViewModel() {
        view.showAnimatedGradientSkeleton()
        viewModel?.loadAd()

        viewModel?.outputs.uiData
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                guard let data = data, let self = self else { return }
                self.adStatistics = data
                self.setupAd()
            }, onError: { [weak self] error in
                self?.showError(error)
            }).disposed(by: bag)

        viewModel?.outputs.error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showError(error)
            }).disposed(by: bag)
    }

    private func setupAd() {
        guard let ad = adStatistics else {
            showErrorDialog(message: R.string.localizable.my_ads_ad_load_failure())
            dismiss()
            return
        }

        view.hideSkeleton()
        let views = generateMedia(images: ad.images, videos: ad.videos)
        setUpMediaScrollView(views: views)
        mediaCount = views.count
        mediaCountLabel.text = mediaCount > 0 ? "\(mediaScrollPage) / \(mediaCount)" : ""

        editButton.isEnabled = ad.editButtonEnabled
        deleteButton.isEnabled = ad.deleteButtonEnabled
        viewButton.isEnabled = ad.viewButtonEnabled
        editButton.isUserInteractionEnabled = ad.editButtonEnabled
        deleteButton.isUserInteractionEnabled = ad.deleteButtonEnabled
        viewButton.isUserInteractionEnabled = ad.viewButtonEnabled
        repostAdButton.style = .shinyBlue
        declinedButton.style = .shinyBlue
        refreshContent()
    }

    private func refreshContent() {
        guard let ad = adStatistics else {
            showErrorDialog(message: R.string.localizable.my_ads_ad_load_failure())
            dismiss()
            return
        }
        visitsCountLabel.text = "\(ad.viewsCount)"
        likesCountLabel.text = "\(ad.likesCount)"
        adBodyLabel.attributedText = ad.body
        adTitleLabel.text = ad.title
        adStatusLabel.text = ad.status
        adStatusLabel.textColor = ad.statusColor

        switch ad.imageButtonType {
        case .declined:
            repostAdButton.isVisible = false
            declinedButton.isVisible = true
        case .expired:
            repostAdButton.isVisible = true
            declinedButton.isVisible = false
        case .none:
            repostAdButton.isVisible = false
            declinedButton.isVisible = false
        }
    }

    private func setUpHeaderView() {
        headerGradient = CAGradientLayer()

        headerGradient.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).cgColor
        ]

        headerGradient.locations = [0, 1]
        headerGradient.frame = CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: headerView.bounds.height)
        headerView.layer.insertSublayer(headerGradient, at: 0)
    }

    // MARK: - Actions

    @IBAction func backAction(_: UIButton) {
        dismiss()
    }

    @IBAction func editAction(_: UIButton) {
        let vc = getEditAdVC(viewModel!.getAdTemplate(), adCreator: adCreator)
        present(vc, animated: true, completion: nil)
    }

    @IBAction func deleteAction(_: UIButton) {
        if viewModel!.showDeleteDialog() {
            let deleteDialog = DeleteAnADDialog()
            deleteDialog.callback = { [weak self] deleteSelected, reason in
                guard let self = self else { return }
                if deleteSelected {
                    self.viewModel!.deleteAd(reason ?? GraphQL.ProductWithdrawReason.soldElsewhere)
                        .observeOn(MainScheduler.instance)
                        .subscribe(onNext: { [weak self] _ in
                            self?.onAdDeleted()
                        }, onError: { [weak self] error in
                            self?.showError(error)
                        }).disposed(by: self.bag)
                }
            }
            present(deleteDialog, animated: true, completion: nil)
        } else {
            viewModel!.deleteAd()
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.onAdDeleted()
                }, onError: { [weak self] error in
                    self?.showError(error)
                }).disposed(by: bag)
        }
    }

    @IBAction func repostAction(_: UIButton) {
        let message = R.string.localizable.repost_ad_dialog_body()
        let title = R.string.localizable.repost_ad_dialog_title().localizedUppercase
        let dialog = YesNoDialog.create(withMessage: message, andTitle: title) { [weak self] pickResult in
            guard let self = self else { return }
            if pickResult == .yes {
                self.viewModel?.repostAd()
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { [weak self] _ in
                        self?.refreshContent()
                    }, onError: { [weak self] error in
                        self?.showError(error)
                    }).disposed(by: self.bag)
            }
        }
        present(dialog, animated: true, completion: nil)
    }

    // MARK: Private

    private func setUpMediaScrollView(views: [MediaView]) {
        mediaScrollView.contentSize = CGSize(width: mediaScrollView.frame.width * CGFloat(views.count), height: mediaScrollView.frame.height)
        mediaScrollView.isPagingEnabled = true
        mediaScrollView.subviews.forEach { $0.removeFromSuperview() }
        for i in 0 ..< views.count {
            views[i].frame = CGRect(x: mediaScrollView.frame.width * CGFloat(i), y: 0, width: mediaScrollView.frame.width, height: mediaScrollView.frame.height)
            mediaScrollView.addSubview(views[i])
        }
        mediaScrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
    }

    private func onAdDeleted() {
        navigationController?.popViewController(animated: true)
        guard let tabsVC = getTabsVC() else { return }
        let adDeletedDialog = AdDeletedDialog()
        tabsVC.present(adDeletedDialog, animated: true, completion: nil)
    }

    private func dismiss() {
        if let navVC = navigationController {
            navVC.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension MyAdStatisticsViewController {
    private func generateMedia(images: [AdImageData], videos: [AdVideoData]) -> [MediaView] {
        fullScreenItems.removeAll()
        var mediaViews: [MediaView] = []
        for image in images {
            let mediaView = MediaView(frame: mediaScrollView.bounds)
            mediaView.thumbnailView.layer.masksToBounds = true
            mediaViews.append(mediaView)

            switch image {
            case let .server(id, preview, full):
                let cacheKey = mediaCache.getCacheKey(identifier: "\(id.uuidString)", type: .image)
                mediaCache.fetchImage(identifier: cacheKey, url: preview.asURL(), expirySeconds: userGeneratedContentDurationSeconds) { [weak mediaView] result in
                    guard let mediaView = mediaView else { return }
                    switch result {
                    case let .success(image):
                        mediaView.thumbnailView.image = image
                    case .failure:
                        if let previewImage = R.image.image_placeholder_med() {
                            mediaView.thumbnailView.image = previewImage
                        }
                    }
                }

                if let url = full.asURL() {
                    fullScreenItems.append(LightboxImage(imageURL: url))
                } else if let placeholder = R.image.image_placeholder() {
                    fullScreenItems.append(LightboxImage(image: placeholder))
                }
            case let .draft(_, cacheKey):
                let idx = fullScreenItems.count
                mediaCache.fetchImage(identifier: cacheKey, url: nil, expirySeconds: nil) { [weak self, weak mediaView] result in
                    guard let self = self, let mediaView = mediaView else { return }
                    switch result {
                    case let .success(image):
                        mediaView.thumbnailView.image = image
                        self.fullScreenItems[idx] = LightboxImage(image: image)
                    case .failure:
                        if let previewImage = R.image.image_placeholder_med() {
                            mediaView.thumbnailView.image = previewImage
                        }
                    }
                }
                fullScreenItems.append(LightboxImage(image: R.image.image_placeholder()!))
            }
        }

        if let video = videos.first {
            let mediaView = MediaView(frame: mediaScrollView.bounds)
            mediaView.thumbnailView.layer.masksToBounds = true
            mediaView.thumbnailView.image = R.image.image_placeholder_med()
            let idx = mediaViews.isEmpty ? 0 : 1
            mediaViews.insert(mediaView, at: idx)
            fullScreenItems.insert(LightboxImage(image: R.image.image_placeholder()!), at: idx)

            switch video {
            case let .server(videoData):
                mediaCache.loadVideo(video: videoData, expiry: userGeneratedContentDurationSeconds) { [weak self] url in
                    guard let self = self, let url = url else { return }
                    mediaView.isMuted = true
                    mediaView.configure(videoUrl: url)
                    if let thumbnail = URL(string: videoData.thumbnail) {
                        mediaView.thumbnailView.setImage(forUrl: thumbnail)
                        self.fullScreenItems[idx] = LightboxImage(imageURL: thumbnail, text: "", videoURL: url)
                    } else {
                        mediaView.thumbnailView.image = R.image.image_placeholder_med()
                        self.fullScreenItems[idx] = LightboxImage(image: R.image.image_placeholder()!, text: "", videoURL: url)
                    }
                }
            case let .draft(_, cacheKey):
                mediaCache.fetchData(identifier: cacheKey, url: nil, expirySeconds: nil) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case let .success(data):
                        mediaView.configure(data: data)
                        if idx < self.fullScreenItems.count {
                            self.fullScreenItems[idx] = LightboxImage(image: R.image.image_placeholder()!, text: "", videoURL: mediaView.videoUrl)
                        }
                    case .failure:
                        break
                    }
                }
            }
        }

        for (index, element) in mediaViews.enumerated() {
            element.index = index
            element.delegate = self
        }

        return mediaViews
    }
}

extension MyAdStatisticsViewController: MediaViewDelegate {
    func mediaViewDidSelect(_: MediaView, at index: Int?) {
        let controller = LightboxController(images: fullScreenItems, startIndex: index ?? 0)
        controller.dynamicBackground = true
        controller.modalPresentationStyle = UIDevice.current.userInterfaceIdiom != .pad ? .fullScreen : .currentContext
        present(controller, animated: true, completion: nil)
    }

    func videoDidEnd() {}
    func videoDidStart(_: MediaView) {
        viewModel?.trackVideoViewed()
    }
}

// MARK: - UIScrollViewDelegate

extension MyAdStatisticsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == mediaScrollView {
            let pageIndex = round(mediaScrollView.contentOffset.x / mediaScrollView.frame.width)
            let nextPage = Int(pageIndex) + 1
            if nextPage != mediaScrollPage {
                mediaScrollPage = nextPage
                mediaCountLabel.text = "\(nextPage) / \(mediaCount)"
                let mediaIndex = Int(pageIndex)
                // Autoplay video when it appears
                let item = fullScreenItems[mediaIndex]
                if item.videoURL != nil {
                    if mediaIndex < mediaScrollView.subviews.count, let video = mediaScrollView.subviews[mediaIndex] as? MediaView {
                        video.play()
                    }
                }
            }
        } else if scrollView == self.scrollView {
            if scrollView.contentOffset.y > mediaScrollView.bounds.height {
                headerView.backgroundColor = .white
                headerGradient.isHidden = true
                headerUnderlineView.isHidden = false

                backButton.tintColor = .black
            } else {
                headerView.backgroundColor = .clear
                headerGradient.isHidden = false
                headerUnderlineView.isHidden = true

                backButton.tintColor = .white
            }
        }
    }
}
