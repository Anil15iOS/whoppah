//
//  CreateAdOnboardingViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 15/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class CreateAdOnboardingViewController: UIViewController {
    var viewModel: CreateAdOnboardingViewModel!

    private var pageVC: UIPageViewController?
    private var pageVCs = [UIViewController]()
    private var pageController: UIPageControl!
    private let bag = DisposeBag()
    private var nextButton: UIView!
    private var prevButton: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPageVC()
    }

    private func setupPageVC() {
        let page = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        page.delegate = self
        page.dataSource = self

        let bullets1 = [
            R.string.localizable.createAdTips1Bullet1(),
            R.string.localizable.createAdTips1Bullet2(),
            R.string.localizable.createAdTips1Bullet3()
        ]
        let page1 = OnboardingPageViewController.PageData(image: R.image.onboardingPage1Image(),
                                                          title: R.string.localizable.createAdTips1Title(),
                                                          bullets: bullets1)
        let page1VC = OnboardingPageViewController()
        page1VC.data = page1

        let bullets2 = [
            R.string.localizable.createAdTips2Bullet1(),
            R.string.localizable.createAdTips2Bullet2()
        ]
        let page2 = OnboardingPageViewController.PageData(image: R.image.onboardingPage2Image(),
                                                          title: R.string.localizable.createAdTips2Title(),
                                                          bullets: bullets2)
        let page2VC = OnboardingPageViewController()
        page2VC.data = page2

        pageVCs = [page1VC, page2VC]
        page.setViewControllers([page1VC], direction: .forward, animated: false, completion: nil)

        pageVC = page
        addChild(page)
        view.addSubview(page.view)

        page.view.backgroundColor = .clear
        page.view.translatesAutoresizingMaskIntoConstraints = false
        page.view.pinToEdges(of: view, orientation: .horizontal)
        page.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        page.view.setAspect(1.35)

        page.didMove(toParent: self)

        let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [Self.self])
        appearance.currentPageIndicatorTintColor = .shinyBlue
        appearance.pageIndicatorTintColor = .silver

        let pageControl = UIPageControl()
        pageControl.numberOfPages = pageVCs.count
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        pageControl.center(withView: view, orientation: .horizontal)
        pageControl.alignBelow(view: page.view, withPadding: 16)
        pageController = pageControl

        let back = ViewFactory.createButton(image: R.image.backFabButton())
        view.addSubview(back)

        let next = ViewFactory.createButton(image: R.image.nextFabButton())
        view.addSubview(next)
        next.horizontalPin(to: view, orientation: .trailing, padding: -UIConstants.margin)
        next.center(withView: pageControl, orientation: .vertical)
        next.rx.tap.bind { [weak self] in
            let nextIndex = pageControl.currentPage + 1
            guard let self = self else { return }
            guard nextIndex < self.pageVCs.count else { return }
            page.setViewControllers([self.pageVCs[nextIndex]], direction: .forward, animated: true, completion: nil)
            self.pageController.currentPage = nextIndex
            next.isVisible = nextIndex + 1 < self.pageVCs.count
            back.isVisible = true
            self.viewModel.showTip(index: nextIndex)
        }.disposed(by: bag)
        nextButton = next

        back.horizontalPin(to: view, orientation: .leading, padding: UIConstants.margin)
        back.center(withView: pageControl, orientation: .vertical)
        back.isVisible = false
        back.rx.tap.bind { [weak self] in
            let prev = pageControl.currentPage - 1
            guard let self = self else { return }
            guard prev >= 0 else { return }
            page.setViewControllers([self.pageVCs[prev]], direction: .reverse, animated: true, completion: nil)
            self.pageController.currentPage = prev
            next.isVisible = true
            back.isVisible = prev != 0
            self.viewModel.showTip(index: prev)
        }.disposed(by: bag)
        prevButton = back

        let nextButton = ViewFactory.createPrimaryButton(text: R.string.localizable.createAdCommonCreateAdButton())
        view.addSubview(nextButton)
        nextButton.verticalPin(to: view, orientation: .bottom, padding: UIConstants.buttonBottomMarginFloating)
        nextButton.pinToEdges(of: view, orientation: .horizontal, padding: UIConstants.margin)
        nextButton.setHeightAnchor(UIConstants.buttonHeight)
        nextButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.viewModel.createAd()
        }.disposed(by: bag)

        viewModel.showTip(index: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBar(transparent: true)
    }
}

// MARK: UIPageViewControllerDataSource

extension CreateAdOnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pageVCs.firstIndex(of: viewController) else {
            return nil
        }

        let previousIndex = index - 1
        guard previousIndex >= 0, pageVCs.count > previousIndex else {
            return nil
        }

        return pageVCs[previousIndex]
    }

    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageVCs.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = index + 1
        guard nextIndex < pageVCs.count else {
            return nil
        }

        return pageVCs[nextIndex]
    }
}

// MARK: UIPageViewControllerDelegate

extension CreateAdOnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating _: Bool, previousViewControllers _: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        guard let vc = pageViewController.viewControllers?.first else { return }
        if let index = pageVCs.firstIndex(of: vc) {
            pageController.currentPage = index
            nextButton.isVisible = index < pageVCs.count - 1
            prevButton.isVisible = index != 0
            viewModel.showTip(index: index)
        }
    }
}
