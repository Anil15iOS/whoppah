//
//  BottomSheetAdsViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/25/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore
import WhoppahCoreNext
import Resolver

class BottomSheetAdsViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var pullView: UIView!

    var isFrameSetted: Bool = false

    let fullView: CGFloat = 200
    var partialView: CGFloat {
        UIScreen.main.bounds.height - 150
    }

    var ads: [AdViewModel] = [] {
        didSet {
            if isViewLoaded {
                tableView.reloadData()
            }
        }
    }
    
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpGesture()
        setUpTableView()
        setUpPullView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !isFrameSetted {
            isFrameSetted = !isFrameSetted

            UIView.animate(withDuration: 0.6, animations: { [weak self] in
                guard let self = self else { return }
                let frame = self.view.frame
                let yComponent = self.partialView
                self.view.frame = CGRect(x: 0, y: yComponent, width: frame.width, height: frame.height - self.fullView)
            })
            // The table view is clicking when panning around the map view
            // Don't know why, it's offscreen...so instead we disable interaction until it's expanded
            tableView.isUserInteractionEnabled = false
        }
    }

    // MARK: - Private

    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: BottomSheetAdCell.nibName, bundle: nil), forCellReuseIdentifier: BottomSheetAdCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.reloadData()
    }

    private func setUpGesture() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(BottomSheetAdsViewController.panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }

    private func setUpPullView() {
        pullView.layer.cornerRadius = pullView.bounds.height / 2
    }

    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)

        let y = view.frame.minY
        if y + translation.y >= fullView, y + translation.y <= partialView {
            view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: view)
        }

        if recognizer.state == .ended {
            var duration = velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y)
            duration = duration > 1.3 ? 1 : duration

            animateView(in: velocity.y < 0, duration: duration)
        }
    }

    private func animateView(in animateIn: Bool, duration: Double) {
        if !animateIn {
            // Stop tableview scrolling when dragging down
            tableView.isScrollEnabled = false
        }
        UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
            if !animateIn {
                self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
            } else {
                self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
            }
        }, completion: { [weak self] _ in
            if animateIn {
                self?.tableView.isScrollEnabled = true
            }
            self?.tableView.isUserInteractionEnabled = animateIn
        })
    }
}

// MARK: - UIGestureRecognizerDelegate

extension BottomSheetAdsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        if gestureRecognizer as? UITapGestureRecognizer != nil {
            return true
        }

        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y

        let y = view.frame.minY
        if (y == fullView && tableView.contentOffset.y == 0 && direction > 0) || (y == partialView) {
            tableView.isScrollEnabled = false
        } else {
            tableView.isScrollEnabled = true
        }

        return false
    }
}

// MARK: - UITableViewDataSource

extension BottomSheetAdsViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        ads.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BottomSheetAdCell.identifier) as! BottomSheetAdCell
        cell.configure(with: ads[indexPath.row], bag: bag)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension BottomSheetAdsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coordinator = AdDetailsCoordinator(navigationController: parent!.navigationController!)
        coordinator.start(adID: ads[indexPath.row].id)
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        104.0
    }
}
