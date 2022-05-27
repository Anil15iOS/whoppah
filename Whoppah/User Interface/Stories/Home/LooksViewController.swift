//
//  LooksViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 25/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import SkeletonView
import UIKit
import WhoppahCoreNext
import Resolver

class LooksViewController: UIViewController {
    var viewModel: LooksViewModel!
    var coordinator: LooksCoordinator!

    private let bag = DisposeBag()

    // MARK: Outlets

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchField: SearchField!
    @IBOutlet var backButton: UIButton!
    
    @Injected private var searchService: SearchService

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpSearchField()
        setUpCollectionView()
    }

    // MARK: Actions

    // MARK: Privates

    private func setUpSearchField() {
        searchField.delegate = self
        searchField.textField.text = searchService.searchText
        backButton.rx.tap.bind { [weak self] in
            self?.viewModel.coordinator.dismiss()
        }.disposed(by: bag)
    }

    private func setUpCollectionView() {
        collectionView.register(UINib(nibName: LookCell.nibName, bundle: nil), forCellWithReuseIdentifier: LookCell.identifier)
        collectionView.collectionViewLayout = LooksLayout()
        viewModel.lookList
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                self.collectionView.applyAction(action)
            }, onError: { [weak self] error in
                self?.showError(error)
            }).disposed(by: bag)
    }
}

extension LooksViewController: SkeletonCollectionViewDataSource {
    func numSections(in _: UICollectionView) -> Int {
        1
    }

    func collectionSkeletonView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        20
    }

    func collectionSkeletonView(_: UICollectionView, cellIdentifierForItemAt _: IndexPath) -> ReusableCellIdentifier {
        LookCell.identifier
    }
}

extension LooksViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        viewModel.numberOfSections()
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfRows(inSection: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LookCell.identifier, for: indexPath) as! LookCell
        cell.hideSkeleton()
        let cellViewModel = viewModel.getCell(section: indexPath.section, row: indexPath.row)
        let isFeatured = viewModel.numberOfRows(inSection: indexPath.section) == 1
        cell.configure(with: cellViewModel, isFeatured: isFeatured)
        if cell.gradient?.frame != cell.bounds {
            cell.gradient?.frame = cell.bounds
        }
        return cell
    }
}

// MARK: - SearchFieldDelegate

extension LooksViewController: SearchFieldDelegate {
    func searchFieldDidClickCamera(_: SearchField) {
        viewModel.coordinator.openSearchByPhoto()
    }

    func searchFieldDidReturn(_ searchField: SearchField) {
        searchField.textField.resignFirstResponder()
        viewModel.inputs.searchText.onNext(searchField.text)
    }

    func searchFieldDidBeginEditing(_: SearchField) {}

    func searchField(_: SearchField, didChangeText _: String) {}
}
