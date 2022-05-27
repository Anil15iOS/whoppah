//
//  AdDetailsViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 1/10/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import AVKit
import IQKeyboardManagerSwift
import Lightbox
import MapKit
import ActiveLabel
import RxCocoa
import RxSwift
import UIKit
import WhoppahCore
import WhoppahCoreNext
import MessageUI
import Apollo
import Resolver
import WhoppahDataStore

class AdDetailsViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var badgeView: UIView!
    @IBOutlet var badgeLabel: UILabel!
    @IBOutlet var badgeIcon: UIImageView!
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var headerGradient: GradientHeaderView!
    @IBOutlet var headerImage: UIImageView!
    @IBOutlet var headerTitle: UILabel!
    @IBOutlet var headerStackView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var arButton: UIButton!
    @IBOutlet var heartIcon: UIView!
    @IBOutlet var eyeIcon: UIView!
    @IBOutlet var moreButton: UIButton!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var mediaScrollView: UIScrollView!
    @IBOutlet var mediaCountView: UIView!
    @IBOutlet var mediaCountLabel: UILabel!
    @IBOutlet var visitsCountLabel: UILabel!
    @IBOutlet var likesCountLabel: UILabel!
    
    @IBOutlet var maxBidLabel: UILabel!
    @IBOutlet var bidLabelsContainerView: UIView!
    
    @IBOutlet var createdAtDateLabel: UILabel!
    @IBOutlet var bidTapView: UIView!
    
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var questionAvatarView: UIImageView!
    @IBOutlet var questionAvatarVerifiedIcon: UIImageView!
    @IBOutlet var questionContainerView: UIView!
    @IBOutlet var questionAvatarName: UILabel!
    @IBOutlet var userJoinDateLabel: UILabel!
    @IBOutlet var questionTextView: UITextView!
    @IBOutlet var questionSendButton: UIButton!
    @IBOutlet var questionTextViewHeight: NSLayoutConstraint!
    @IBOutlet var questionPlaceholderLabel: UILabel!
    @IBOutlet var questionStackView: UIStackView!
    @IBOutlet var questionBackgroundView: UIView!
    @IBOutlet var questionUserExpertBadge: UIButton!
    
    @IBOutlet var brandContainerView: UIView!
    @IBOutlet var brandLabel: UILabel!
    @IBOutlet var brandDivider: UIView!
    
    @IBOutlet var brandDescriptionContainerView: UIView!
    @IBOutlet var brandDescriptionLabel: UILabel!
    
    @IBOutlet var artistContainerView: UIView!
    @IBOutlet var artistLabel: UILabel!
    
    @IBOutlet var designerContainerView: UIView!
    @IBOutlet var designerLabel: UILabel!
    
    @IBOutlet var materialsLabel: UILabel!
    @IBOutlet var materialsContainerView: UIView!
    
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var categoryContainerView: UIView!
    
    @IBOutlet var widthSection: UIView!
    @IBOutlet var widthLabel: UILabel!
    @IBOutlet var heightSection: UIView!
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var depthSection: UIView!
    @IBOutlet var depthLabel: UILabel!
    @IBOutlet var attributesContainerView: UIView!
    
    @IBOutlet var colorsCollectionView: UICollectionView!
    @IBOutlet var colorsContainerView: UIView!
    
    @IBOutlet var translateDescriptionButton: UIButton!
    @IBOutlet var placeBidUpperButton: SecondaryLargeButton!
    
    @IBOutlet var bidButton: SecondaryLargeButton!
    @IBOutlet var goToChatButton: SecondaryLargeButton!
    @IBOutlet var buyNowButton: PrimaryLargeButton!
    @IBOutlet var payNowButton: PrimaryLargeButton!
    @IBOutlet var placeBidButton: PrimaryLargeButton!
    @IBOutlet var bidAmountTextfield: UITextField!
    @IBOutlet var bottomContainerView: UIView!
    @IBOutlet var bottomButtonContainerView: UIView!
    @IBOutlet var bottomDummyHeight: NSLayoutConstraint!
    
    @IBOutlet var bidConfirmBottomView: UIView!
    @IBOutlet var bidConfirmTitle: UILabel!
    @IBOutlet var bidConfirmClose: UIButton!
    @IBOutlet var bidConfirmTopView: UIView!
    
    @IBOutlet var similarAdsLabel: UILabel!
    @IBOutlet var similarAdsCollectionView: UICollectionView!
    @IBOutlet var similarAdsHeight: NSLayoutConstraint!
    @IBOutlet var similarItemsContainerView: UIStackView!
    
    @IBOutlet var soldMediaBanner: UIView!
    @IBOutlet var soldMediaBannerText: UILabel!
    
    @IBOutlet var loadingView: UIView!
    
    @IBOutlet var supportDescriptionLabel: ActiveLabel!
    @IBOutlet var buyNowUpperButton: PrimaryLargeButton!
    
    @IBOutlet var styleLabel: UILabel!
    @IBOutlet var conditionDescription: UILabel!
    @IBOutlet var conditionLabel: UILabel!
    @IBOutlet var styleContainerView: UIView!
    @IBOutlet var deliveryImageView: UIImageView!
    @IBOutlet var deliveryMethodTitleLabel: UILabel!
    @IBOutlet var deliveryPriceLabel: UILabel!
    @IBOutlet var deliveryDescriptionLabel: UILabel!
    
    @IBOutlet var pickUpDescriptionLabel: UILabel!
    @IBOutlet var pickUpImageView: UIImageView!
    @IBOutlet var pickUpPriceLabel: UILabel!
    
    @IBOutlet var pickupContainerView: UIView!
    @IBOutlet var deliveryContainerView: UIView!
    @IBOutlet var sellerProductsButton: UIButton!
    @IBOutlet var deliveryInfoContainerView: UIStackView!
    
    var viewModel: AdDetailsViewModel!
    
    @Injected private var crashReporter: CrashReporter
    @LazyInjected private var userProvider: UserProviding
    
    private enum PDPBuyNowSource {
        case topSection
        case ar
        case buyButton
    }
    
    var adID: UUID!
    private var previousPage = -1
    private var mediaScrollPage = 1
    private var ad: AdDetailUIData?
    private var mediaCount: Int = 0
    struct MediaItem {
        let image: LightboxImage
        let mediaID: UUID?
    }
    
    private var fullScreenItems: [MediaItem] = []
    
    private let bag = DisposeBag()
    
    // MARK: - ViewController's Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLabels()
        scrollView.delegate = self
        setUpButtons()
        setUpMediaViews()
        setUpCollectionViews()
        setUpTextField()
        setUpGestures()
        setUpBottomView()
        setUpExpertBadge()
        
        loadAd()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if loadingView.isVisible {
            mediaScrollView.hideSkeleton()
            mediaScrollView.showAnimatedGradientSkeleton()
        }
        adjustTextViewHeight()
    }
    
    deinit {
        crashReporter.log(event: "leave_pdp",
                          withInfo: ["ad": adID!])
    }
    
    // MARK: - Actions
    
    @IBAction func backAction(_: UIButton) {
        dismiss()
    }
    
    @IBAction func translateAction(_ sender: UIButton) {

        let actionSheet = UIAlertController(title: nil, message: R.string.localizable.translationLanguageOptions(), preferredStyle: .actionSheet)
        
        for item in SupportedLanguages.all {
            actionSheet.addAction(UIAlertAction(title: item.displayName, style: .default, handler: { [weak self] _ in
                
                guard let self = self, let lang = GraphQL.Lang(rawValue: item.rawValue) else { return }
                
                self.viewModel.translate(strings: [self.descriptionLabel.text ?? "",
                                                   self.productNameLabel.text ?? ""],
                                         lang: lang) { [weak self] translation in
                    guard let self = self, let translation = translation else { return }
                    
                    self.descriptionLabel.text = translation.translatedTexts[0]
                    self.productNameLabel.text = translation.translatedTexts[1]
                }
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: R.string.localizable.translationLanguageOptionsCancel(), style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func likeAction(_ sender: UIButton) {
        getTabsVC()?.openContextualSignupIfNeeded(title: R.string.localizable.contextualSignupFavoritesTitle(),
                                                  description: R.string.localizable.contextualSignupFavoritesDescription()) {
            sender.isSelected = !sender.isSelected
            let observer = self.viewModel.toggleLikeAd()
            observer?.bind(to: sender.rx.isSelected).disposed(by: self.bag)
            observer?.connect().disposed(by: self.bag)
        }
    }
    
    @IBAction func sendMessageButtonAction(_ sender: UIButton) {
        sendMessageAction(sender)
    }
    
    @objc func sendMessageAction(_: Any) {
        guard let text = questionTextView.text, !text.isEmpty else { return }
        
        getTabsVC()?.openContextualSignupIfNeeded(title: R.string.localizable.contextualSignupChatTitle(),
                                                  description: R.string.localizable.contextualSignupChatDescription()) {
            self.sendQuestion(text: text)
        }
    }
    
    // MARK: - UI
    
    private func updateBadge(badge: ProductBadge?) {
        badgeView.layer.cornerRadius = badgeView.layer.frame.height/2
        
        if let badge = badge {
            badgeView.isHidden = true
            let text = observedLocalizedString(badge.textKey)
            text.bind(to: badgeLabel.rx.text).disposed(by: bag)
            text.compactMap { $0?.isEmpty }.bind(to: badgeView.rx.isHidden).disposed(by: bag)
            let hex = badge.backgroundHex ?? localizedString(badge.colorKey) ?? "#000"
            badgeView.backgroundColor = UIColor(hexString: hex)
            
            if  let icon = UIImage(named: badge.slug) {
                badgeIcon.isHidden = false
                badgeIcon.image = icon
            } else {
                badgeIcon.isHidden = true
            }
            
        } else {
            badgeView.isHidden = true
            badgeView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
    }
    
    private func setUpExpertBadge() {
        questionUserExpertBadge.setTitle(R.string.localizable.labelExpertSeller(), for: .normal)
        questionUserExpertBadge.titleLabel?.adjustsFontSizeToFitWidth = true
        questionUserExpertBadge.layer.cornerRadius = questionUserExpertBadge.layer.frame.height/2
        questionUserExpertBadge.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        questionUserExpertBadge.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 12)
        questionUserExpertBadge.titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -12)
        questionUserExpertBadge.contentEdgeInsets = UIEdgeInsets(top: 0, left: 6.0, bottom: 0, right: 2.0)
    }
    
    private func setUpLabels() {
        viewModel.outputs.likeText.bind(to: likesCountLabel.rx.text).disposed(by: bag)
        viewModel.outputs.isLiked.bind(to: likeButton.rx.isSelected).disposed(by: bag)
    }
    
    private func setUpBottomView() {
        bottomContainerView.layer.cornerRadius = 8
        bottomContainerView.layer.borderColor = UIColor.smoke.cgColor
        bottomContainerView.layer.borderWidth = 1.0
        
        bottomContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        bidAmountTextfield.layer.cornerRadius = 4
        bidAmountTextfield.layer.borderColor = UIColor.smoke.cgColor
        bidAmountTextfield.layer.borderWidth = 1.0
        bidAmountTextfield.rx.text.bind(to: viewModel.inputs.bidAmount).disposed(by: bag)
        
        bottomContainerView.layer.shadowColor = UIColor.black.cgColor
        bottomContainerView.layer.shadowOpacity = 0.2
        bottomContainerView.layer.shadowRadius = 4
        bottomContainerView.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    private func setUpGestures() {
        let tap = UITapGestureRecognizer()
        tap.cancelsTouchesInView = false
        tap.rx.event.bind(onNext: { [weak self] _ in
            self?.view.endEditing(true)
        }).disposed(by: bag)
        view.addGestureRecognizer(tap)
    }
    
    private func sendQuestion(text: String) {
        viewModel.sendChatMessage(text: text) { [weak self] _ in
            guard let self = self else { return }
            self.questionTextView.text = nil
            self.adjustTextViewHeight()
        }
    }
    
    private func dismiss() {
        if navigationController == nil || navigationController?.viewControllers.count == 1 {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func setUpButtons() {
        translateDescriptionButton.translatesAutoresizingMaskIntoConstraints = false
        translateDescriptionButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2 - 24).isActive = true
        translateDescriptionButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    
        buyNowUpperButton.style = .shinyBlue
        
        placeBidUpperButton.buttonColor = .shinyBlue
        placeBidUpperButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 12)
        questionUserExpertBadge.titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -12)
        
        bidButton.buttonColor = .shinyBlue
        bidButton.rx.tap.bind { [weak self] in
            self?.doBid(source: .bidButton)
        }.disposed(by: bag)
        
        placeBidUpperButton.rx.tap.bind { [weak self] in
            self?.doBid(source: .bidButton)
        }.disposed(by: bag)
        
        viewModel.outputs.bidButtonEnabled
            .bind(to: placeBidButton.rx.isEnabled)
            .disposed(by: bag)
        
        placeBidButton.rx.tap.bind { [weak self] in
            self?.placeBidButton.startAnimating()
            self?.viewModel.placeBid { result in
                self?.placeBidButton.stopAnimating()
                switch result {
                case .success:
                    self?.toggleBidConfirmView(false)
                case let .failure(error):
                    self?.showError(error)
                }
            }
        }.disposed(by: bag)
        
        buyNowButton.style = .shinyBlue
        buyNowButton.rx.tap.bind { [weak self] in
            guard let self = self, let tabs = self.getTabsVC() else { return }
            tabs.openContextualSignupIfNeeded(title: R.string.localizable.contextualSignupBuyingTitle(),
                                              description: R.string.localizable.contextualSignupBuyingDescription()) {
                self.buyNowButton.startAnimating()
                self.doBuyNow(source: .buyButton)
            }
        }.disposed(by: bag)
        
        buyNowUpperButton.rx.tap.bind { [weak self] in
            guard let self = self, let tabs = self.getTabsVC() else { return }
            tabs.openContextualSignupIfNeeded(title: R.string.localizable.contextualSignupBuyingTitle(),
                                              description: R.string.localizable.contextualSignupBuyingDescription()) {
                self.buyNowUpperButton.startAnimating()
                self.doBuyNow(source: .buyButton)
            }
        }.disposed(by: bag)
        
        goToChatButton.rx.tap.bind { [weak self] in
            self?.viewModel.goToChat()
        }.disposed(by: bag)
        payNowButton.rx.tap.bind { [weak self] in
            self?.viewModel.payNow()
        }.disposed(by: bag)
        shareButton.rx.tap.bind { [weak self] in
            self?.viewModel.share()
        }.disposed(by: bag)
        moreButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.viewModel.coordinator.showMoreMenu(delegate: self)
        }.disposed(by: bag)
        bidConfirmClose.rx.tap.bind { [weak self] in
            self?.toggleBidConfirmView(false)
        }.disposed(by: bag)
        
        sellerProductsButton.setTitle(R.string.localizable.ad_details_seller_products(), for: .normal)
        sellerProductsButton.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        sellerProductsButton.rx.tap.bind(onNext: { [weak self] _ in
            self?.viewModel.onAvatarTapped()
        }).disposed(by: bag)
    }
    
    private func setUpMediaViews() {
        mediaScrollView.delegate = self
        mediaCountView.layer.cornerRadius = 4.0
    }
    
    private func setUpCollectionViews() {
        // Colors
        colorsCollectionView.transform = CGAffineTransform(scaleX: -1, y: 1)
        colorsCollectionView.delegate = self
        colorsCollectionView.register(UINib(nibName: ColorCell.nibName, bundle: nil), forCellWithReuseIdentifier: ColorCell.identifier)
        
        viewModel.outputs.colorHex.map { $0.isEmpty }.bind(to: colorsContainerView.rx.isHidden).disposed(by: bag)
        viewModel.outputs.colorHex.bind(to: colorsCollectionView.rx.items(cellIdentifier: ColorCell.identifier, cellType: ColorCell.self)) { _, hex, cell in
            cell.setUp(with: hex)
        }.disposed(by: bag)
        
        // Similar ads
        similarAdsCollectionView.register(UINib(nibName: ListADCell.nibName, bundle: nil), forCellWithReuseIdentifier: ListADCell.identifier)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 10, height: 240)
        flowLayout.scrollDirection = .horizontal
        
        flowLayout.minimumInteritemSpacing = 5.0
        
        similarAdsCollectionView.collectionViewLayout = flowLayout
        similarAdsCollectionView.showsHorizontalScrollIndicator = false
        
        similarAdsLabel.isVisible = false
        similarAdsCollectionView.isVisible = false
        similarItemsContainerView.isVisible = false
        similarAdsCollectionView.contentInset =  UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        viewModel.more.moreAds.asObservable()
            .bind(to: similarAdsCollectionView.rx.items(cellIdentifier: ListADCell.identifier, cellType: ListADCell.self)) { _, item, cell in
                cell.delegate = self
                cell.configure(withVM: item)
            }.disposed(by: bag)
        
        viewModel.more.moreAds
            .map { !$0.isEmpty }
            .bind(to: similarItemsContainerView.rx.isVisible, similarAdsLabel.rx.isVisible, similarAdsCollectionView.rx.isVisible)
            .disposed(by: bag)
                
        similarAdsCollectionView.rx.modelSelected(AdViewModel.self)
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] model in
                guard let theModel = model.element else { return }
                self?.viewModel.more.onAdTapped(model: theModel)
            }.disposed(by: bag)
        
    }
    
    private func setUpTextField() {
        questionContainerView.layer.cornerRadius = questionContainerView.bounds.height / 2
        questionContainerView.layer.borderColor = UIColor.smoke.cgColor
        questionContainerView.layer.borderWidth = 1.0
        
        questionTextView.delegate = self
        questionTextView.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(sendMessageAction(_:)))
        questionTextView.rx.didBeginEditing.map { true }.bind(to: questionPlaceholderLabel.rx.isHidden).disposed(by: bag)
        questionTextView.rx.text.orEmpty.map { [weak self] in !$0.isEmpty || self?.questionTextView.isFirstResponder == true }.bind(to: questionPlaceholderLabel.rx.isHidden).disposed(by: bag)
        questionTextView.rx.text.orEmpty.map { !$0.isEmpty }.bind(to: questionSendButton.rx.isEnabled).disposed(by: bag)
        // Scroll views conflict with each other, scrolling
        questionTextView.rx.willBeginDragging.map { false }.bind(to: scrollView.rx.isScrollEnabled).disposed(by: bag)
        questionTextView.rx.willEndDragging.map { _ in true }.bind(to: scrollView.rx.isScrollEnabled).disposed(by: bag)
        
        adjustTextViewHeight()
    }
    
    // MARK: - Data
    
    private func loadAd() {
        showLoading()
        crashReporter.log(event: "enter_pdp", withInfo: ["ad": adID!])

        viewModel.adData
            .compactMap { $0 }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] adUIData in
                self?.onAdDetailsUpdated(ad: adUIData)
                self?.updateBadge(badge: adUIData.badge)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.crashReporter.log(error: error,
                                       withInfo: ["screen": "pdp", "type": "load_ad", "id": "\(self.adID!)"])
                self.showError(error)
            }).disposed(by: bag)
    }
    
    private func showLoading() {
        mediaScrollView.showAnimatedGradientSkeleton()
        loadingView.isVisible = true
        loadingView.showAnimatedGradientSkeleton()
        scrollView.isUserInteractionEnabled = false
    }
    
    private func hideLoading() {
        mediaScrollView.hideSkeleton()
        loadingView.hideSkeleton()
        loadingView.isVisible = false
        scrollView.isUserInteractionEnabled = true
    }
    
    private func onAdDetailsUpdated(ad: AdDetailUIData) {
        if self.ad == nil {
            viewModel.trackAdViewed()
            setupMedia(ad)
        }
        self.ad = ad
        
        hideLoading()
        
        moreButton.isVisible = ad.showMoreMenu
        
        visitsCountLabel.text = ad.viewsText
        visitsCountLabel.isVisible = true
        likesCountLabel.isVisible = true
        let isActive = ad.status == .active
        likeButton.isEnabled = isActive
        likeButton.isVisible = true
        eyeIcon.isVisible = true
        heartIcon.isVisible = true
        shareButton.isEnabled = isActive
        shareButton.isVisible = isActive
        likeButton.isVisible = isActive
        
        buyNowUpperButton.isVisible = ad.canBuy && !ad.canBid
        buyNowUpperButton.isEnabled = ad.canBuy && !ad.canBid
        buyNowUpperButton.setTitle(ad.buyNowButtonText, for: .normal)
        
        if ad.canBid || !ad.canBuy {
            if ad.bidInfo.text.containsHtml() {
                maxBidLabel.setHtml(ad.bidInfo.text)
            } else {
                maxBidLabel.text = ad.bidInfo.text
            }
        }
        
        bidConfirmTitle.text = ad.bidFromText
        placeBidUpperButton.isVisible = ad.canBid
        questionBackgroundView.isVisible = !ad.isMyAd

        let isSold = ad.status == .sold || ad.status == .reserved
        soldMediaBanner.isVisible = isSold
        if isSold {
            soldMediaBannerText.text = R.string.localizable.auctionStateCompleted().localizedCapitalized
            soldMediaBanner.alpha = 0
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.soldMediaBanner.alpha = 1
            }
        }
        
        createdAtDateLabel.text = ad.createdAtText
        questionAvatarName.text = ad.username
        questionAvatarVerifiedIcon.isVisible = ad.isVerified
        userJoinDateLabel.text = ad.joinedText
        
        questionUserExpertBadge.isHidden = !(ad.rawAd.user.isExpertSeller ?? false)
        for view in questionStackView.arrangedSubviews {
            view.isVisible = ad.showAskQuestion
        }
        
        let url = URL(string: ad.rawAd.user.thumbnail?.url ?? "")
        if let character = ad.rawAd.user.name.first {
            questionAvatarView.setIcon(forUrl: url, character: character)
        }
        
        questionAvatarView.removeGestures()
        let tap = UITapGestureRecognizer()
        tap.rx.event.bind { [weak self] _ in
            self?.viewModel!.onAvatarTapped()
        }.disposed(by: bag)
        questionAvatarView.addGestureRecognizer(tap)
        questionAvatarView.superview?.isHidden = ad.isBusiness
        
        productNameLabel.text = ad.title
        headerTitle.text = ad.title
        
        conditionLabel.text = ad.rawAd.quality.title()
        conditionDescription.text = ad.rawAd.quality.explanationText()
        descriptionLabel.text = ad.description
        
        brandLabel.text = ad.brandText
        brandContainerView.isHidden = ad.brandText.isEmpty
        brandDivider.isHidden = !ad.brandDescription.isEmpty
        brandDescriptionLabel.text = ad.brandDescription
        brandDescriptionContainerView.isHidden = ad.brandDescription.isEmpty
        artistLabel.text = ad.artistText
        artistContainerView.isHidden = ad.artistText.isEmpty
        designerLabel.text = ad.designerText
        designerContainerView.isHidden = ad.designerText.isEmpty
        
        materialsLabel.text = ad.materialText
        materialsContainerView.isHidden = ad.materialText.isEmpty
        
        categoryLabel.text = ad.categoryAdText
        categoryContainerView.isHidden = ad.categoryAdText.isEmpty
        
        bidAmountTextfield.placeholder = R.string.localizable.adDetailsPlaceBidPlaceholder(ad.currency)
        setupAttributes(ad)
        
        deliveryContainerView.isHidden = ad.delivery.description.isEmpty
        pickupContainerView.isHidden = ad.pickUp.description.isEmpty
        deliveryDescriptionLabel.isHidden = (ad.delivery.type == "courier")
        
        if ad.delivery.description != "" {
            deliveryImageView.image = UIImage(named: "delivery-method-icon")
            deliveryMethodTitleLabel.text = ad.delivery.method
            deliveryDescriptionLabel.text = ad.delivery.description
            deliveryPriceLabel.text = ad.delivery.price
        }
        
        if ad.pickUp.description != "" {
            pickUpImageView.image = UIImage(named: "delivery-pickup-icon")
            pickUpDescriptionLabel.text = ad.pickUp.description
            pickUpPriceLabel.text = ad.pickUp.price
        }
                
        if ad.delivery.type == "courier" && !ad.pickUp.description.isEmpty {
            
            deliveryImageView.image = UIImage(named: "delivery-pickup-icon")
            deliveryMethodTitleLabel.text = ad.pickUp.description
            deliveryPriceLabel.text = ad.pickUp.price
            
            pickUpImageView.image = UIImage(named: "delivery-method-icon")
            pickUpDescriptionLabel.text = ad.delivery.method
            pickUpPriceLabel.text = ad.delivery.price
        }
        
        bottomContainerView.isVisible = ad.showBottomPurchaseSection
        bottomDummyHeight.constant = ad.showBottomPurchaseSection ? 100 : 0
        bidButton.isVisible = ad.canBid
        bidButton.isEnabled = ad.canBid
        goToChatButton.isVisible = ad.showGoToChat
        payNowButton.isVisible = ad.showPayNow
        
        styleContainerView.isHidden = ad.styleText.isEmpty
        
        styleLabel.text = ad.styleText
        bidButton.buttonColor = ad.canBid ? UIColor.shinyBlue : UIColor.silver
        
        let emailType = ActiveType.custom(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        let phoneType = ActiveType.custom(pattern: "\\s\("\\+31 \\(0\\) 20 244 46 93")\\b")
        supportDescriptionLabel.enabledTypes = [emailType, phoneType]
        supportDescriptionLabel.text = ""//R.string.localizable.ad_details_contact_text()
        supportDescriptionLabel.customColor[emailType] = .orange
        supportDescriptionLabel.customColor[phoneType] = .shinyBlue
        
        supportDescriptionLabel.handleCustomTap(for: emailType) { element in
            let urlString = "mailto:\(element)"
            UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
        }
        
        supportDescriptionLabel.handleCustomTap(for: phoneType) { element in
            let number = element.replacingOccurrences(of: " ", with: "")
            if let urlString = URL(string: "telprompt://\(number)") {
                UIApplication.shared.open(urlString, options: [:], completionHandler: nil)
            }
        }
        
        buyNowButton.isVisible = ad.canBuy
        buyNowButton.isEnabled = ad.canBuy
        buyNowButton.setTitle(ad.buyNowButtonText, for: .normal)
        
        if ad.bidInfo.isUnavailable {
            maxBidLabel.textColor = .redInvalid
        } else {
            maxBidLabel.textColor = .black
        }
        bidTapView.removeGestures()
        if isActive {
            if ad.canBid {
                let tap = UITapGestureRecognizer(target: nil, action: nil)
                tap.rx.event.bind { [weak self] _ in
                    self?.doBid(source: .bidTopSection)
                }.disposed(by: bag)
                bidTapView.addGestureRecognizer(tap)
            } else if ad.canBuy {
                let tap = UITapGestureRecognizer(target: nil, action: nil)
                tap.rx.event.bind { [weak self] _ in
                    self?.doBuyNow(source: .topSection)
                }.disposed(by: bag)
                bidTapView.addGestureRecognizer(tap)
            }
        }
    }
    
    private func setupAttributes(_ ad: AdDetailUIData) {
        switch ad.dimension {
        case let .present(width, height, depth):
            heightSection.isVisible = height != nil
            heightLabel.text = height
            widthSection.isVisible = width != nil
            widthLabel.text = width
            depthSection.isVisible = depth != nil
            depthLabel.text = depth
            attributesContainerView.isVisible = true
        case .notPresent:
            attributesContainerView.isVisible = false
        }
    }
    
    private func setupMedia(_ ad: AdDetailUIData) {
        fullScreenItems.removeAll()
        mediaScrollView.subviews.forEach { $0.removeFromSuperview() }
        let views = generateMedia(images: ad.images, videos: ad.videos)
        setUpMediaScrollView(views: views)
        mediaCountLabel.text = "\(mediaScrollPage) / \(views.count)"
        mediaCountView.isVisible = true
        mediaCount = views.count
    }
    
    private func generateMedia(images: [AdImageData], videos: [AdVideoData]) -> [MediaView] {
        var mediaViews: [MediaView] = []
        for (index, image) in images.enumerated() {
            let mediaView = MediaView(frame: mediaScrollView.bounds)
            mediaView.thumbnailView.layer.masksToBounds = true
            mediaView.thumbnailView.image = R.image.image_placeholder_med()
            mediaViews.append(mediaView)
            
            switch image {
            case let .server(id, preview, full):
                let imageId = id
                mediaView.thumbnailView.setImage(forUrl: preview.asURL()) { [weak self] result in
                    switch result {
                    case .success:
                        // Track the first item loading
                        if index == 0 {
                            self?.viewModel.trackPhotoViewed(id: imageId, isFullScreen: false)
                        }
                    default:
                        break
                    }
                }
                
                if index == 0 {
                    headerImage.setImage(forUrl: preview.asURL())
                }
                if let image = full.asURL() {
                    fullScreenItems.append(MediaItem(image: LightboxImage(imageURL: image), mediaID: imageId))
                } else if let image = R.image.image_placeholder() {
                    fullScreenItems.append(MediaItem(image: LightboxImage(image: image), mediaID: imageId))
                }
            case let .draft(_, cacheKey):
                viewModel.mediaCache.fetchImage(identifier: cacheKey, url: nil, expirySeconds: nil) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case let .success(image):
                        mediaView.thumbnailView.image = image
                        if index < self.fullScreenItems.count {
                            self.fullScreenItems[index] = MediaItem(image: LightboxImage(image: image), mediaID: nil)
                        }
                        if index == 0 {
                            self.headerImage.image = image
                        }
                    case .failure:
                        break
                    }
                }
                
                fullScreenItems.append(MediaItem(image: LightboxImage(image: R.image.image_placeholder_med()!), mediaID: nil))
            }
        }
        
        if let video = videos.first {
            let mediaView = MediaView(frame: mediaScrollView.bounds)
            mediaView.thumbnailView.layer.masksToBounds = true
            let idx = mediaViews.isEmpty ? 0 : 1
            mediaViews.insert(mediaView, at: idx)
            mediaView.thumbnailView.image = R.image.image_placeholder_med()
            
            switch video {
            case let .server(videoData):
                fullScreenItems.insert(MediaItem(image: LightboxImage(image: R.image.image_placeholder()!), mediaID: videoData.id), at: idx)
                viewModel.mediaCache.loadVideo(video: videoData, expiry: userGeneratedContentDurationSeconds) { url in
                    guard let url = url else { return }
                    mediaView.isMuted = true
                    mediaView.configure(videoUrl: url)
                    if let thumbnail = URL(string: videoData.thumbnail) {
                        mediaView.thumbnailView.setImage(forUrl: thumbnail)
                        self.fullScreenItems[idx] = MediaItem(image: LightboxImage(imageURL: thumbnail, text: "", videoURL: url), mediaID: videoData.id)
                    } else {
                        mediaView.thumbnailView.image = R.image.image_placeholder_med()
                        self.fullScreenItems[idx] = MediaItem(image: LightboxImage(image: R.image.image_placeholder()!, text: "", videoURL: url), mediaID: videoData.id)
                    }
                }
            case let .draft(_, cacheKey):
                fullScreenItems.insert(MediaItem(image: LightboxImage(image: R.image.image_placeholder()!), mediaID: nil), at: idx)
                viewModel.mediaCache.fetchData(identifier: cacheKey, url: nil, expirySeconds: nil) { result in
                    switch result {
                    case let .success(data):
                        mediaView.configure(data: data)
                        if idx < self.fullScreenItems.count {
                            self.fullScreenItems[idx] = MediaItem(image: LightboxImage(image: R.image.image_placeholder()!, text: "", videoURL: mediaView.videoUrl), mediaID: nil)
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
    
    private func setUpMediaScrollView(views: [MediaView]) {
        mediaScrollView.contentSize = CGSize(width: mediaScrollView.frame.width * CGFloat(views.count), height: mediaScrollView.frame.height)
        mediaScrollView.isPagingEnabled = true
        
        for i in 0 ..< views.count {
            views[i].frame = CGRect(x: mediaScrollView.frame.width * CGFloat(i), y: 0, width: mediaScrollView.frame.width, height: mediaScrollView.frame.height)
            mediaScrollView.addSubview(views[i])
        }
    }
    
    private func doBuyNow(source: PDPBuyNowSource) {
        viewModel.buyNowAction { [weak self] result in
            guard let self = self else { return }
            self.buyNowButton.stopAnimating()
            var buySource = BuyNowSource.pdp
            switch source {
            case .ar:
                buySource = BuyNowSource.ar
            case .buyButton, .topSection:
                buySource = BuyNowSource.pdp
            }
            switch result {
            case .success:
                self.viewModel.trackBuyNowClicked(source: buySource)
            case let .failure(error):
                self.showError(error)
            }
        }
    }
    
    private func doBid(source: AdBidSource) {
        guard let ad = ad, ad.status == .active, viewModel.canBid() else {
            showErrorDialog()
            return
        }
        
        getTabsVC()?.openContextualSignupIfNeeded(title: R.string.localizable.contextualSignupBiddingTitle(),
                                                  description: R.string.localizable.contextualSignupBiddingDescription()) {
            self.viewModel.logBidEvent(source: source)
            self.toggleBidConfirmView(true)
        }
    }
    
    private func toggleBidConfirmView(_ visible: Bool) {
        // Close the button dialog section
        bidConfirmTopView.isVisible = visible
        bidConfirmBottomView.isVisible = visible
        bottomButtonContainerView.isVisible = !visible
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func likeAd(_ ad: AdViewModel) {
        guard userProvider.isLoggedIn else {
            getTabsVC()?.openContextualSignupIfNeeded(title: R.string.localizable.contextualSignupFavoritesTitle(),
                                                      description: R.string.localizable.contextualSignupFavoritesDescription())
            return
        }
        
        let observer = ad.toggleLikeStatus()
        observer
            .observeOn(MainScheduler.instance)
            .subscribe(onError: { [weak self] error in
                self?.showError(error)
            }).disposed(by: bag)
        observer.connect().disposed(by: bag)
    }
}

// MARK: - UIScrollViewDelegate

extension AdDetailsViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard scrollView == mediaScrollView else { return }
        self.scrollView.isScrollEnabled = false
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard scrollView == mediaScrollView else { return }
        self.scrollView.isScrollEnabled = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate _: Bool) {
        guard scrollView == mediaScrollView else { return }
        self.scrollView.isScrollEnabled = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == mediaScrollView {
            guard abs(mediaScrollView.frame.width) > CGFloat.ulpOfOne else { return }
            let pageIndex = round(mediaScrollView.contentOffset.x / mediaScrollView.frame.width)
            let nextPage = Int(pageIndex) + 1
            guard nextPage != mediaScrollPage else { return }
            let mediaIndex = nextPage - 1
            guard mediaIndex >= 0 && mediaIndex < fullScreenItems.count else { return }
            
            mediaScrollPage = nextPage
            mediaCountLabel.text = "\(nextPage) / \(mediaCount)"
            
            // Segment.io
            let item = fullScreenItems[mediaIndex]
            // Only log for images
            if item.image.videoURL == nil {
                guard let mediaId = item.mediaID else { return }
                viewModel.trackPhotoViewed(id: mediaId, isFullScreen: false)
            } else {
                guard mediaIndex < mediaScrollView.subviews.count, let video = mediaScrollView.subviews[mediaIndex] as? MediaView else { return }
                video.play()
            }
        } else if scrollView == self.scrollView {
            let mediaIsVisible = scrollView.contentOffset.y <= mediaScrollView.bounds.height
            headerView.backgroundColor = mediaIsVisible ? UIColor.clear : UIColor.white
            headerGradient.isHidden = !mediaIsVisible
            
            headerView.layer.shadowColor = mediaIsVisible ? UIColor.clear.cgColor : UIColor.black.cgColor
            headerView.layer.shadowOpacity = mediaIsVisible ? 0.0 : 0.2
            headerView.layer.shadowRadius = 8
            headerView.layer.shadowOffset = CGSize(width: 0, height: 4)
            
            headerStackView.isHidden = mediaIsVisible
            backButton.tintColor = mediaIsVisible ? .white : .black
            shareButton.tintColor = mediaIsVisible ? .white : .black
            moreButton.tintColor = mediaIsVisible ? .white : .black
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AdDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case colorsCollectionView:
            return CGSize(width: 20.0, height: 20.0)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16.0, bottom: 0, right: 16.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        8.0
    }
}

// MARK: - UITextFieldDelegate

extension AdDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard let text = textField.text else { return true }
        sendQuestion(text: text)
        return true
    }
}

// MARK: - UITextViewDelegate

extension AdDetailsViewController: UITextViewDelegate {
    func adjustTextViewHeight() {
        let fixedWidth: CGFloat = view.bounds.size.width - 41
        let newSize = questionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        questionTextViewHeight.constant = max(newSize.height, 44)
        questionTextView.bounds = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        view.layoutIfNeeded()
    }
    
    func textView(_: UITextView, shouldChangeTextIn _: NSRange, replacementText _: String) -> Bool {
        adjustTextViewHeight()
        return true
    }
}

// MARK: - ReportDialogDelegate

extension AdDetailsViewController: ReportDialogDelegate {
    func reportDialogDidSelectUserReport(_ dialog: ReportDialog) {
        getTabsVC()?.openContextualSignupIfNeeded(title: R.string.localizable.contextualSignupMywhoppahTitle(),
                                                  description: R.string.localizable.contextualSignupMywhoppahDescription()) {
            dialog.dismiss(animated: false, completion: nil)
            self.viewModel.showUserReport()
        }
    }
    
    func reportDialogDidSelectProductReport(_ dialog: ReportDialog) {
        getTabsVC()?.openContextualSignupIfNeeded(title: R.string.localizable.contextualSignupMywhoppahTitle(),
                                                  description: R.string.localizable.contextualSignupMywhoppahDescription()) {
            dialog.dismiss(animated: false, completion: nil)
            self.viewModel.showProductReport()
        }
    }
    
    func reportDialogDidSelectBlockUser(_ dialog: ReportDialog) {
        dialog.dismiss(animated: false, completion: nil)
    }
}

// MARK: - LightboxControllerPageDelegate

extension AdDetailsViewController: LightboxControllerPageDelegate {
    func lightboxController(_: LightboxController, didMoveToPage page: Int) {
        // This event can arrive for the same page
        guard page != previousPage else { return }
        previousPage = page
        // Segment.io
        // Don't log for videos and if the image hasn't loaded
        let item = fullScreenItems[page]
        if item.image.videoURL == nil {
            if item.image.image != nil, let mediaId = item.mediaID {
                viewModel.trackPhotoViewed(id: mediaId, isFullScreen: true)
            }
        }
    }
}

// MARK: - MediaViewDelegate

extension AdDetailsViewController: MediaViewDelegate {
    func mediaViewDidSelect(_: MediaView, at index: Int?) {
        let controller = WPLightboxController(images: fullScreenItems.map { $0.image }, startIndex: index ?? 0)
        controller.pageDelegate = self
        controller.vm = viewModel
        controller.dynamicBackground = true
        controller.modalPresentationStyle = UIDevice.current.userInterfaceIdiom != .pad ? .fullScreen : .currentContext
        
        let photoItem = fullScreenItems[index ?? 0]
        if let mediaId = photoItem.mediaID {
            viewModel.trackPhotoViewed(id: mediaId, isFullScreen: true)
        }
        
        previousPage = -1
        present(controller, animated: true, completion: nil)
    }
    
    func videoDidEnd() {}
    func videoDidStart(_: MediaView) {
        viewModel.trackVideoViewed(isFullScreen: false)
    }
}

// MARK: - ListADCellDelegate

extension AdDetailsViewController: ListADCellDelegate {
    func listAdCell(_ cell: ListADCell, didClickLike _: UIButton) {
        likeAd(cell.ad)
    }
    
    func listAdCellDidClickAR(_ cell: ListADCell) {
        return
    }
    
    func listAdCellDidViewVideo(_ cell: ListADCell) {
        return
    }
}
