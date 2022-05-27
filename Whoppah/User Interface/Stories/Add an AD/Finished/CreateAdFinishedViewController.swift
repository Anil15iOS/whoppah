//
//  CreateAdProcessingViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/15/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import Resolver

class CreateAdFinishedViewController: UIViewController {
    // MARK: Properties

    var productImage: UIImage!
    var adID: UUID!
    var mode: AdCreationResult!
    private let bag = DisposeBag()

    // MARK: - IBOutlets

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var goToAdsButton: PrimaryLargeButton!

    @Injected private var eventTracking: EventTrackingService

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        setUpButtons()
        setUpProductImage()
        configure()
    }

    // MARK: - Private

    private func setUpNavigationBar() {
        setNavBar(title: R.string.localizable.createAdCommonYourAdTitle(),
                  enabled: true, transparent: false)
        addCloseButton(image: R.image.ic_close()).rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: bag)
    }

    private func setUpProductImage() {
        productImageView.image = productImage
    }

    private func setUpButtons() {
        goToAdsButton.style = .primary
    }

    private func configure() {
        var title = R.string.localizable.create_ad_done_processing_title()
        var subTitle = R.string.localizable.create_ad_done_processing_subtitle()
        switch mode {
        case .created:
            title = R.string.localizable.create_ad_done_processing_title()
            subTitle = R.string.localizable.create_ad_done_processing_subtitle()
        case .curation:
            title = R.string.localizable.create_ad_done_processing_title()
            subTitle = R.string.localizable.create_ad_done_processing_subtitle()
        case .edited:
            title = R.string.localizable.create_ad_done_success_title()
            subTitle = R.string.localizable.create_ad_done_success_subtitle()
        case .none:
            fatalError("Should not show this screen with 'none'")
        }

        titleLabel.text = title
        subtitleLabel.text = subTitle
        setNavBar(title: R.string.localizable.createAdCommonYourAdTitle(), enabled: true, transparent: false)
    }

    // MARK: - Actions

    @objc func closeAction(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func homeAction(_: SecondaryLargeButton) {
        dismiss(animated: true, completion: nil)
        let route = Navigator.Route.home
        Navigator().navigate(route: route)
    }

    @IBAction func goToMyAdsButton(_: UIButton) {
        dismiss(animated: true) {
            let route = Navigator.Route.myWhoppah(data: Navigator.MyWhoppahRoutingData(withSection: .myAds))
            Navigator().navigate(route: route)
        }
    }

    @IBAction func createAction(_: UIButton) {
        dismiss(animated: false, completion: nil)

        let route = Navigator.Route.createAd
        Navigator().navigate(route: route)
        eventTracking.createAd.trackCreateAnotherAdInConfirmation()
    }
}
