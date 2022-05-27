//
//  ThreadsViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 12/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import WhoppahCoreNext
import WhoppahDataStore
import Resolver

class ThreadsViewModel {
    // MARK: - Properties

    struct Inputs {}

    let inputs = Inputs()

    struct Outputs {
        var threadList: Driver<ListAction> {
            _threadList.asDriver(onErrorJustReturn: .loadingInitial)
        }

        fileprivate let _threadList = BehaviorSubject<ListAction>(value: .initial)

        var showEmptyView: Driver<Bool> {
            _showEmptyView.asDriver(onErrorJustReturn: false)
        }

        fileprivate let _showEmptyView = BehaviorRelay<Bool>(value: false)
    }

    let outputs = Outputs()

    let coordinator: ThreadsCoordinator!
    private let repo: ThreadsRepository
    private var bag = DisposeBag()
    private var threadBag = DisposeBag()
    private var reloadThreads = false
    
    @Injected private var inAppNotifier: InAppNotifier
    @Injected private var chatService: ChatService
    @Injected private var userService: WhoppahCore.LegacyUserService

    init(coordinator: ThreadsCoordinator,
         repo: ThreadsRepository) {
        self.repo = repo
        self.coordinator = coordinator

        registerThreadWatcher()
    }

    func setup() {
        userService.active.map { $0?.id }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] member in
                guard let self = self else { return }
                if member == nil {
                    self.threadBag = DisposeBag()
                    self.clearThreads()
                    self.registerThreadWatcher()
                }
            }, onError: { _ in
            }).disposed(by: bag)
    }

    func reload() {
        outputs._showEmptyView.accept(false)
        loadThreads()
        updateUnreadCountBadge()
    }

    func loadIfNeeded() {
        if reloadThreads {
            reloadThreads = false
            reload()
        }
    }

    var pager: PagedView { repo.pager }

    // MARK: Data source

    func numberOfRows() -> Int {
        getNumberOfThreads()
    }

    // MARK: Actions

    // MARK: Private

    private func registerThreadWatcher() {
        repo.threads.drive(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(threads):
                let initialCount = self.repo.numitems()

                var indexPaths = [IndexPath]()
                for index in threads.indices {
                    indexPaths.append(IndexPath(row: initialCount + index, section: 0))
                }

                if initialCount == 0, threads.isEmpty {
                    self.outputs._showEmptyView.accept(self.repo.numitems() == 0)
                    self.outputs._threadList.onNext(.reloadAll)
                } else {
                    self.outputs._threadList.onNext(.newRows(rows: indexPaths,
                                                             updater: ThreadNotificationRepoUpdater(items: threads, repo: self.repo)))
                }

                for index in threads.indices {
                    guard let viewModel = self.repo.getViewModel(atIndex: initialCount + index) else { assertionFailure(); continue }
                    viewModel.outputs.productClick.subscribe(onNext: { [weak self] thread in
                        // Reload threads every time a user comes back from a thread :(
                        self?.reloadThreads = true
                        self?.coordinator.openThread(id: thread.id)
                    }).disposed(by: self.bag)
                }
            case let .failure(error):
                self.coordinator.showError(error)
            }
        }).disposed(by: threadBag)
    }

    func sendChatMessage(text: String, completion: (() -> Void)? = nil) {
        userService.sendQuestionForSupport(text: text)
            .take(1)
            .subscribe(onNext: { _ in
                completion?()
            }).disposed(by: bag)
    }

    // MARK: Private

    private func updateUnreadCountBadge() {
        inAppNotifier.notify(.updateChatBadgeCount)
    }
}

// MARK: Threads

extension ThreadsViewModel {
    private func loadThreads() {
        let reload = repo.numitems() > 0
        // Double loadingInitial bounce here is strange - why is it needed?
        outputs._threadList.onNext(.loadingInitial)
        repo.load()
        // If we don't reload the list here we get a crash
        // Because we append new items to the list, if there's some already in the list we crash
        if reload {
            outputs._threadList.onNext(.reloadAll)
        }
        outputs._threadList.onNext(.loadingInitial)
    }

    private func clearThreads() {
        repo.clear()
        outputs._threadList.onNext(.reloadAll)
    }

    func loadMoreThreads() -> Bool {
        let hasMore = repo.loadMore()
        if !hasMore {
            outputs._threadList.onNext(.endRefresh)
        }
        return hasMore
    }

    func getNumberOfThreads() -> Int { repo.numitems() }

    func getThreadCell(row: Int) -> ThreadOverviewCellViewModel { repo.getViewModel(atIndex: row)! }
}
