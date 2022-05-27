//
//  ThreadsViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/17/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import KafkaRefresh
import RxCocoa
import RxSwift
//import Segmentio
import SkeletonView
import UIKit

class ThreadsViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var tableView: UITableView!
    @IBOutlet var chatsEmptyView: ChatsEmptyView!
    @IBOutlet var navigationBarBackgroundView: UIView!
    private var moreThreadsLoader = PublishRelay<Int>()

    var viewModel: ThreadsViewModel!
    private let bag = DisposeBag()

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
        setUpEmptyViews()
        setUpNavBar()
        setupBindings()

        viewModel.setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadIfNeeded()
    }

    // MARK: - TableView

    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: ThreadCell.nibName, bundle: nil), forCellReuseIdentifier: ThreadCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)

        tableView.bindHeadRefreshHandler({
            self.reloadThreads()
        }, themeColor: UIColor.orange, refreshStyle: .native)
        tableView.bindFootRefreshHandler({
            self.moreThreadsLoader.accept(self.viewModel.pager.nextPage)
        }, themeColor: UIColor.orange, refreshStyle: .native)
    }

    private func setUpNavBar() {
        navigationBarBackgroundView.layer.shadowColor = UIColor.black.cgColor
        navigationBarBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        navigationBarBackgroundView.layer.shadowRadius = 8.0
        navigationBarBackgroundView.layer.shadowOpacity = 0.05
    }

    private func setUpEmptyViews() {
        chatsEmptyView.isHidden = true
        chatsEmptyView.delegate = self
    }

    private func setupBindings() {
        viewModel.outputs.threadList
            .drive(onNext: { [weak self] action in
                guard let self = self else { return }
                self.tableView.applyAction(action, pager: self.viewModel.pager, addSkeleton: true)
            }).disposed(by: bag)

        viewModel.outputs.showEmptyView.asObservable()
            .bind(to: chatsEmptyView.rx.isVisible)
            .disposed(by: bag)

        moreThreadsLoader
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: 1)
            .filter { $0 > 1 }
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                if !self.viewModel.loadMoreThreads() {
                    self.tableView.hideRefreshControls(self.viewModel.pager)
                } else {
                    self.tableView.showFooterRefreshControl()
                }
            })
            .disposed(by: bag)
    }

    func reloadThreads() {
        moreThreadsLoader.accept(1)
        viewModel.reload()
    }
}

// MARK: - UITableViewDataSource

extension ThreadsViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        let count = viewModel.numberOfRows()
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ThreadCell.identifier) as! ThreadCell
        let vm = viewModel.getThreadCell(row: indexPath.row)
        cell.hideSkeleton()
        cell.configure(with: vm)
        return cell
    }
}

extension ThreadsViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        10
    }

    func collectionSkeletonView(_: UITableView, cellIdentifierForRowAt _: IndexPath) -> ReusableCellIdentifier {
        ThreadCell.identifier
    }
}

// MARK: - UITableViewDelegate

extension ThreadsViewController: UITableViewDelegate {
    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfRows() - 5 {
            DispatchQueue.main.async {
                self.moreThreadsLoader.accept(self.viewModel.pager.nextPage)
            }
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        80.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as? ThreadCell
        cell?.viewModel?.onClicked()
    }
}

extension ThreadsViewController: ChatsEmptyViewDelegate {
    func sendQuestion(withText text: String, completion: @escaping (() -> Void)) {
        viewModel.sendChatMessage(text: text, completion: completion)
    }
}
