//
//  CreateAdCategorySelectionViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 15/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class CreateAdCategorySelectionViewController: UIViewController {
    var viewModel: CreateAdCategorySelectionViewModel!

    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        analyticsKey = "AdCreation_CategorySection"
        setNavBar(title: R.string.localizable.createAdCategorySelectionScreenTitle(), transparent: false)

        let scrollView = ViewFactory.createScrollView()
        view.addSubview(scrollView.scroll)
        scrollView.scroll.pinToAllEdges(of: view)

        let root = scrollView.root

        let title = ViewFactory.createTitle(R.string.localizable.createAdCategorySelectionTitle())
        root.addSubview(title)
        title.textColor = .black
        title.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        title.verticalPin(to: root, orientation: .top, padding: UIConstants.titleTopMargin)

        let categoryView = ViewFactory.createVerticalStack(spacing: 16)
        root.addSubview(categoryView)
        categoryView.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        categoryView.alignBelow(view: title, withPadding: UIConstants.titleBottomMargin)
        categoryView.verticalPin(to: root, orientation: .bottom)

        let loading = LoadingView(frame: .zero)
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        loading.setWidthAnchor(52)
        loading.setHeightAnchor(62)
        loading.center(withView: view, orientation: .horizontal)
        loading.center(withView: view, orientation: .vertical)
        viewModel.outputs.topCategories.map { $0.isEmpty }.bind(to: loading.rx.isVisible).disposed(by: bag)

        viewModel.outputs.topCategories.filter { !$0.isEmpty }.subscribe(onNext: { [weak self] categories in
            guard let self = self else { return }
            categoryView.subviews.forEach { $0.removeFromSuperview() }
            for category in categories {
                let view = ViewFactory.createView()
                view.layer.cornerRadius = 8
                view.clipsToBounds = true
                categoryView.addArrangedSubview(view)
                view.pinToEdges(of: categoryView, orientation: .horizontal)
                view.setHeightAnchor(84)

                let image = ViewFactory.createImage(image: nil)
                image.kf.setImage(with: category.image)
                view.addSubview(image)
                image.pinToAllEdges(of: view)

                let text = ViewFactory.createLabel(text: "")
                text.textColor = .white
                text.font = UIFont.boldSystemFont(ofSize: 24)
                category.title.bind(to: text.rx.text).disposed(by: self.bag)
                view.addSubview(text)
                text.center(withView: view, orientation: .vertical)
                text.horizontalPin(to: view, orientation: .leading, padding: 16)

                let nextImage = ViewFactory.createImage(image: R.image.createAdCategoryNextButton(), aspect: 1.0)
                view.addSubview(nextImage)
                nextImage.horizontalPin(to: view, orientation: .trailing, padding: -16)
                nextImage.center(withView: view, orientation: .vertical)
                text.alignBefore(view: nextImage, withPadding: -8)

                let tap = UITapGestureRecognizer()
                tap.rx.event.map { _ -> Void in () }.bind(to: category.itemClick).disposed(by: self.bag)
                view.addGestureRecognizer(tap)
            }
        }).disposed(by: bag)
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        guard parent == nil else { return }
        viewModel.onDismiss()
    }
}
