//
//  MySearchesViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 2/17/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore
import WhoppahCoreNext
import Resolver
import WhoppahDataStore

class MySearchesViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var navigationBar: NavigationBar!
    @IBOutlet var searchesTableView: UITableView!
    @IBOutlet var searchesHeight: NSLayoutConstraint!
    @IBOutlet var addButton: UIButton!

    private var searches: [GraphQL.SavedSearchesQuery.Data.SavedSearch.Item] = []
    private let bag = DisposeBag()
    
    @Injected private var user: WhoppahCore.LegacyUserService
    @Injected private var search: SearchService

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        setUpTableView()
        setUpAddButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()
    }

    // MARK: - Private

    private func setUpNavigationBar() {
        navigationBar.titleLabel.text = R.string.localizable.main_my_profile_my_searches()
        navigationBar.backButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
    }

    private func setUpTableView() {
        searchesTableView.dataSource = self
        searchesTableView.delegate = self
        searchesTableView.register(UINib(nibName: MySearchCell.nibName, bundle: nil), forCellReuseIdentifier: MySearchCell.identifier)
    }
    
    private func setUpAddButton() {
        addButton.layer.cornerRadius = 5
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.white.cgColor
    }

    private func loadData() {
        user.getMySearches()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] searches in
                guard let self = self else { return }
                self.searches = searches
                self.searchesTableView.reloadData()
            }, onError: { [weak self] error in
                self?.showError(error)
            }).disposed(by: bag)
    }

    // MARK: - Actions

    @objc func backAction(_: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func addAction(_: UIButton) {
        search.removeAllFilters()
        let coordinator = SearchResultsCoordinator(navigationController: navigationController!)
        coordinator.start()
    }
}

// MARK: - UITableViewDataSource

extension MySearchesViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        searchesHeight.constant = CGFloat(searches.count) * 48.0
        return searches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MySearchCell.identifier) as! MySearchCell
        cell.configure(with: searches[indexPath.row], deleted: { [weak self] in
            self?.deleteItemAtRow(tableView, indexPath)
        })
        return cell
    }

    func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            deleteItemAtRow(tableView, indexPath)
        }
    }
    
    private func deleteItemAtRow(_ tableView: UITableView, _ indexPath: IndexPath) {
        // handle delete (by removing the data from your array and updating the tableview)
        let search = searches[indexPath.row]

        searches.remove(at: indexPath.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()

        user.deleteSearch(id: search.id)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                // Reload in case of failure
                self.searchesTableView.reloadData()
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.showError(error)
                // Reload in case of failure
                self.searchesTableView.reloadData()
            }).disposed(by: bag)
    }
}

// MARK: - UITableViewDelegate

extension MySearchesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let search = searches[indexPath.row]
        let service = self.search
        service.removeAllFilters()
        service.setFrom(search: search)
        if let url = URL(string: search.link) {
            if DeeplinkManager.shared.handleDeeplink(url: url) {
                DeeplinkManager.shared.executeDeeplink()
            }
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        48.0
    }
}
