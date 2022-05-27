//
//  OnboardingViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 06/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class OnboardingPageViewController: UIViewController {
    struct PageData {
        let image: UIImage?
        let title: String
        let bullets: [String]
    }

    var data: PageData!

    private var imageView: UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        let curvedCard = ViewFactory.createCurvedCard()
        view.addSubview(curvedCard)
        curvedCard.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        curvedCard.backgroundColor = R.color.pinkLight()
        curvedCard.pinToEdges(of: view, orientation: .horizontal)
        curvedCard.setAspect(0.78)
        let imageView = ViewFactory.createImage(image: data.image)
        curvedCard.addSubview(imageView)
        imageView.center(withView: curvedCard, orientation: .horizontal)
        imageView.verticalPin(to: curvedCard, orientation: .bottom)
        self.imageView = imageView

        let title = ViewFactory.createTitle(data.title)
        view.addSubview(title)
        title.pinToEdges(of: view, orientation: .horizontal, padding: UIConstants.margin)
        title.alignBelow(view: imageView, withPadding: 16)

        let bulletList = ViewFactory.createVerticalStack(spacing: 2)
        for bullet in data.bullets {
            let pairView = ViewFactory.createView()
            let image = ViewFactory.createImage(image: R.image.greenTick(), width: 24, aspect: 1.0)
            pairView.addSubview(image)
            image.horizontalPin(to: pairView, orientation: .leading)
            image.verticalPin(to: pairView, orientation: .top)
            let text = ViewFactory.createLabel(text: bullet, lines: 0)
            pairView.addSubview(text)
            text.alignAfter(view: image, withPadding: 8)
            text.horizontalPin(to: pairView, orientation: .trailing)
            text.verticalPin(to: pairView, orientation: .top)
            text.verticalPin(to: pairView, orientation: .bottom)

            bulletList.addArrangedSubview(pairView)
            pairView.pinToEdges(of: bulletList, orientation: .horizontal)
        }
        view.addSubview(bulletList)
        bulletList.alignBelow(view: title, withPadding: 16)
        bulletList.pinToEdges(of: view, orientation: .horizontal, padding: 16)
    }
}

class OnboardingViewController: UIViewController {
    private var pageVC: UIPageViewController?
    private var pageVCs = [UIViewController]()
    private var pageController: UIPageControl!
    private let bag = DisposeBag()

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
            R.string.localizable.onboardingPage1Bullet1(),
            R.string.localizable.onboardingPage1Bullet2(),
            R.string.localizable.onboardingPage1Bullet3()
        ]
        let page1 = OnboardingPageViewController.PageData(image: R.image.usp1(),
                                                          title: R.string.localizable.onboardingPage1Title(),
                                                          bullets: bullets1)
        let page1VC = OnboardingPageViewController()
        page1VC.data = page1

        let bullets2 = [
            R.string.localizable.onboardingPage2Bullet1(),
            R.string.localizable.onboardingPage2Bullet2(),
            R.string.localizable.onboardingPage2Bullet3()
        ]
        let page2 = OnboardingPageViewController.PageData(image: R.image.usp2(),
                                                          title: R.string.localizable.onboardingPage2Title(),
                                                          bullets: bullets2)
        let page2VC = OnboardingPageViewController()
        page2VC.data = page2

        let bullets3 = [
            R.string.localizable.onboardingPage3Bullet1(),
            R.string.localizable.onboardingPage3Bullet2(),
            R.string.localizable.onboardingPage3Bullet3()
        ]
        let page3 = OnboardingPageViewController.PageData(image: R.image.usp3(),
                                                          title: R.string.localizable.onboardingPage3Title(),
                                                          bullets: bullets3)
        let page3VC = OnboardingPageViewController()
        page3VC.data = page3

        pageVCs = [page1VC, page2VC, page3VC]
        page.setViewControllers([page1VC], direction: .forward, animated: false, completion: nil)

        pageVC = page
        addChild(page)
        view.addSubview(page.view)

        page.view.backgroundColor = .clear
        page.view.translatesAutoresizingMaskIntoConstraints = false
        page.view.pinToEdges(of: view, orientation: .horizontal)
        page.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        page.view.setAspect(1.20)

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
        pageControl.alignBelow(view: page.view, withPadding: 56)
        pageController = pageControl

        let next = ViewFactory.createButton(image: R.image.nextFabButton())
        view.addSubview(next)
        next.horizontalPin(to: view, orientation: .trailing, padding: -UIConstants.margin)
        next.center(withView: pageControl, orientation: .vertical)
        next.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let next = pageControl.currentPage + 1
            if next < self.pageVCs.count {
                page.setViewControllers([self.pageVCs[next]], direction: .forward, animated: true, completion: nil)
                self.pageController.currentPage = next
            } else {
                self.exitOnboarding()
            }
        }.disposed(by: bag)
        let skip = ViewFactory.createButton(text: R.string.localizable.commonSkip())
        skip.setTitleColor(.black, for: .normal)

        view.addSubview(skip)
        skip.horizontalPin(to: view, orientation: .leading, padding: UIConstants.margin)
        skip.center(withView: pageControl, orientation: .vertical)
        skip.rx.tap.bind { [weak self] in
            self?.exitOnboarding()
        }.disposed(by: bag)

        let closeButton = ViewFactory.createLargeButton(image: R.image.ic_close()!)
        view.addSubview(closeButton)
        closeButton.verticalPin(to: view, orientation: .top, padding: 0)
        closeButton.horizontalPin(to: view, orientation: .leading, padding: 0)
        closeButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.exitOnboarding()
        }.disposed(by: bag)
    }

    private func exitOnboarding() {
        UserDefaultsConfig.hasSeenOnboarding = true
        let storyboard = UIStoryboard(name: "Tabs", bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() else { return }
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = vc
 
        let splash = SignupSplashViewHostingController(presentingViewController: vc)
        let nav = WhoppahNavigationController(rootViewController: splash)
        nav.isNavigationBarHidden = true
        nav.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { nav.modalPresentationStyle = .fullScreen }
        vc.present(nav, animated: false, completion: nil)
    }
}

// MARK: UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {
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

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating _: Bool, previousViewControllers _: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        guard let vc = pageViewController.viewControllers?.first else { return }
        if let index = pageVCs.firstIndex(of: vc) {
            pageController.currentPage = index
        }
    }
}
