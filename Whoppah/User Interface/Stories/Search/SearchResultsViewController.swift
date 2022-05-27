//
//  SearchResultsViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/17/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import KafkaRefresh
import RxCocoa
import RxSwift
import SkeletonView
import UIKit
import WhoppahCore
import WhoppahCoreNext
import EasyTipView
import MaterialComponents.MaterialButtons
import Resolver

class SearchResultsViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var backButton: UIButton!
    @IBOutlet var searchField: SearchField!
    @IBOutlet var filtersCollectionView: UICollectionView!
    @IBOutlet var subCategoryfiltersCollectionView: UICollectionView!
    @IBOutlet var filtersButton: UIButton!
    @IBOutlet var mapButton: UIButton!
    @IBOutlet var saveSearchBarButton: PrimaryLargeButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var changeAdsPresentationButton: UIButton!
    @IBOutlet var sortButton: UIButton!
    @IBOutlet var saveToastView: ToastMessage!
    
    @IBOutlet var loadingViewContainer: UIView!
    @IBOutlet var loadingView: LoadingView!

    @IBOutlet var emptyView: UIView!
    @IBOutlet var searchListContainer: UIView!
    var searchListVC: AdListViewController?
    private var fabButton: MDCFloatingButton!
    private var offsetY: CGFloat = 0.0
    // MARK: - Properties

    private let bag = DisposeBag()
    private var moreItemLoadPage = PublishRelay<Int>()
    var viewModel: SearchResultsViewModel!
    
    @Injected private var search: SearchService

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpCollectionViews()
        setUpButtons()
        setUpSearchField()
        setUpSearchListVC()
        setUpBindings()
        setUpSaveButton()
        reloadAds()
    }

    private func showLoading() {
        searchListVC!.resultsCollectionView.showFooterRefreshControl()
    }
    
    private func setUpSaveButton() {
        let fab = MDCFloatingButton(shape: .default)
        fab.mode = .normal
        fab.backgroundColor = .shinyBlue
        fab.setImage(R.image.ic_notifications_active(), for: .normal)
        fab.tintColor = .white
        fab.translatesAutoresizingMaskIntoConstraints = false
        fab.minimumSize = CGSize(width: 64, height: 48)
        view.insertSubview(fab, belowSubview: saveToastView)
        fab.horizontalPin(to: view, orientation: .trailing, padding: -16)
        fab.verticalPin(to: view, orientation: .bottom, padding: -16)
        fab.rx.tap.subscribe { [weak self]  _ in
            guard let self = self else { return }
            let askConfirm = YesNoDialog.create(withMessage: R.string.localizable.saveSearchConfirmBody(),
                                                andTitle: R.string.localizable.saveSearchConfirmTitle())
            askConfirm.onButtonPressed = { button in
                if button == .yes {
                    self.saveSearch()
                }
            }
            self.present(askConfirm, animated: true, completion: nil)
            
        }.disposed(by: bag)
        
        showSearchTip(forButton: fab)
        fabButton = fab
    }

    // MARK: -
    private func saveSearch() {
        guard let tabs = getTabsVC() else { return }
        tabs.openContextualSignupIfNeeded(title: R.string.localizable.contextualSignupSearchResultsTitle(),
                                          description: R.string.localizable.contextualSignupSearchResultsDescription()) { [weak self] in
            self?.viewModel.save { [weak self] in
                guard let self = self else { return }
                self.saveToastView.show(in: self.view)
            }
        }
    }
    
    private func showSearchTip(forButton button: UIView) {
        guard UserDefaultsConfig.showSearchAlertTip else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UserDefaultsConfig.searchAlertTipShown = true
            var preferences = EasyTipView.Preferences()
            preferences.drawing.backgroundColor = .white
            preferences.drawing.foregroundColor = .black
            preferences.drawing.cornerRadius = 10
            preferences.drawing.textAlignment = .center
            preferences.drawing.arrowPosition = .bottom
            preferences.animating.dismissOnTap = true
            preferences.drawing.shadowColor = .gray
            preferences.drawing.borderColor = .darkGray
            preferences.drawing.borderWidth = 1
            preferences.drawing.shadowRadius = 5
            let ev = EasyTipView(text: R.string.localizable.searchAlertSaveTip(), preferences: preferences, delegate: nil)
            ev.show(animated: true, forView: button, withinSuperview: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                ev.dismiss()
            }
        }
    }
    
    private func setUpCollectionViews() {
        filtersCollectionView.delegate = self
        filtersCollectionView.register(UINib(nibName: FilterCell.nibName, bundle: nil), forCellWithReuseIdentifier: FilterCell.identifier)

        viewModel.outputs.filters.bind(to: filtersCollectionView.rx.items(cellIdentifier: FilterCell.identifier, cellType: FilterCell.self)) { [weak self] _, item, cell in
            cell.configure(with: item)
            cell.delegate = self
        }.disposed(by: bag)

        viewModel.outputs.filters
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] list in
                self?.filtersCollectionView.isHidden = list.isEmpty
                self?.deleteButton.isHidden = list.isEmpty
            }, onError: { [weak self] error in
                self?.showError(error)
            }).disposed(by: bag)

        subCategoryfiltersCollectionView.delegate = self
        subCategoryfiltersCollectionView.register(UINib(nibName: FilterCell.nibName, bundle: nil), forCellWithReuseIdentifier: FilterCell.identifier)

        viewModel.outputs.subCategories.bind(to: subCategoryfiltersCollectionView.rx.items(cellIdentifier: FilterCell.identifier, cellType: FilterCell.self)) { [weak self] _, item, cell in
            cell.configure(with: item)
            cell.delegate = self
        }.disposed(by: bag)

        viewModel.outputs.subCategories
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] list in
                self?.subCategoryfiltersCollectionView.isHidden = list.isEmpty
            }, onError: { [weak self] error in
                self?.showError(error)
            }).disposed(by: bag)
    }

    private func setUpBindings() {
        moreItemLoadPage
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: 1)
            .filter { $0 > 1 }
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                if !self.viewModel.loadMore() {
                    self.searchListVC?.resultsCollectionView.hideRefreshControls(self.viewModel.pager)
                } else {
                    self.searchListVC?.resultsCollectionView.showFooterRefreshControl()
                }
            })
            .disposed(by: bag)
    }

    private func setUpSearchField() {
        searchField.textField.placeholder = R.string.localizable.search_input_hint()
        viewModel.outputs.search.bind(to: searchField.textField.rx.text).disposed(by: bag)
        searchField.delegate = self
    }

    private func setUpSearchListVC() {
        let vc: AdListViewController = UIStoryboard(storyboard: .search).instantiateViewController()
        vc.emptyView = emptyView
        vc.delegate = self
        vc.didMove(toParent: self)
        addChild(vc)
        searchListContainer.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.leadingAnchor.constraint(equalTo: searchListContainer.leadingAnchor, constant: 0).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: searchListContainer.trailingAnchor, constant: 0).isActive = true
        vc.view.topAnchor.constraint(equalTo: searchListContainer.topAnchor, constant: 0).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: searchListContainer.bottomAnchor, constant: 0).isActive = true
        searchListVC = vc
        searchListVC!.presentationStyle = changeAdsPresentationButton.isSelected ? .list : .grid

        viewModel.outputs.itemList
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .loadingInitial:
                    self.moreItemLoadPage.accept(1)
                    self.searchListVC?.resultsCollectionView.setContentOffset(CGPoint.zero, animated: false)
                case let .changePresentation(style):
                    self.searchListVC?.presentationStyle = style
                default:
                    break
                }
                self.searchListVC?.resultsCollectionView.applyAction(action, pager: self.viewModel.pager)
            }, onError: { [weak self] error in
                self?.showError(error)
            }).disposed(by: bag)
    }

    private func setUpButtons() {
        deleteButton.backgroundColor = .white
        deleteButton.makeCircular()

        deleteButton.rx.tap.bind { [weak self] in
            self?.viewModel.removeFilters()
        }.disposed(by: bag)
    }

    private func reloadAds() {
        showLoading()
        refetchAds()
    }

    // MARK: - Actions

    @IBAction func backAction(_: UIButton) {
        search.removeAllFilters()
        navigationController?.popViewController(animated: true)
    }

    @IBAction func filtersAction(_: UIButton) {
        viewModel.showFilters()
    }

    @IBAction func mapAction(_: UIButton) {
        viewModel.openMap()
    }

    @IBAction func saveSearchBarAction(_: UIButton) {
        viewModel.save { [weak self] in
            guard let self = self else { return }
            self.saveToastView.show(in: self.view)
        }
    }

    @IBAction func changeAdsPresentationAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        viewModel.changeMoreItemsPresentation(sender.isSelected ? .list : .grid)
    }

    @IBAction func sortAction(_: UIButton) {
        viewModel.openSortDialog()
    }
}

// MARK: - UICollectionViewDelegate

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchResultsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case filtersCollectionView:
            let width = viewModel.getFilterWidth(atIndex: indexPath.row)
            return CGSize(width: width, height: 32.0)
        case subCategoryfiltersCollectionView:
            let width = viewModel.getSubCategoryfilterWidth(atIndex: indexPath.row)
            return CGSize(width: width, height: 32.0)
        default:
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        switch collectionView {
        case filtersCollectionView:
            return UIEdgeInsets(top: 0, left: 40.0, bottom: 0, right: 16.0)
        case subCategoryfiltersCollectionView:
            return UIEdgeInsets(top: 0, left: 16.0, bottom: 0, right: 16.0)
        default:
            return UIEdgeInsets.zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        switch collectionView {
        case filtersCollectionView, subCategoryfiltersCollectionView:
            return 8.0
        default:
            return 0.0
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        switch collectionView {
        case filtersCollectionView, subCategoryfiltersCollectionView:
            return 8.0
        default:
            return 0.0
        }
    }
}

// MARK: - FilterCellDelegate

extension SearchResultsViewController: FilterCellDelegate {
    func filterCellDidTapDelete(_ cell: FilterCell) {
        guard let indexPath = filtersCollectionView.indexPath(for: cell) ?? subCategoryfiltersCollectionView.indexPath(for: cell) else { return }
        viewModel.removeFilter(atIndex: indexPath.row)
    }

    func filterCellDidSelect(_ cell: FilterCell) {
        guard let indexPath = filtersCollectionView.indexPath(for: cell) ?? subCategoryfiltersCollectionView.indexPath(for: cell) else { return }
        viewModel.addSubcategoryFilter(atIndex: indexPath.row)
    }
}

// MARK: - UITextFieldDelegate

extension SearchResultsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let customTextField = textField.superview?.superview as? SearchField {
            viewModel.applySearch(customTextField.textField.text ?? "")
            customTextField.autocompleteDropdown.hide()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let customTextField = textField.superview?.superview as? SearchField else { return true }
        customTextField.textField.resignFirstResponder()
        customTextField.autocompleteDropdown.hide()
        guard let searchText = textField.text else { return true }
        viewModel.applySearch(searchText)
        return true
    }
}

// MARK: - SearchFieldDelegate

extension SearchResultsViewController: SearchFieldDelegate {
    func searchFieldDidClickCamera(_: SearchField) {
        viewModel.openSearchByPhoto()
    }

    func searchFieldDidReturn(_ searchField: SearchField) {
        searchField.textField.resignFirstResponder()
        viewModel.applySearch(searchField.text)
    }

    func searchFieldDidBeginEditing(_: SearchField) {}

    func searchField(_: SearchField, didChangeText text: String) {
        viewModel.onSearchTextChanged(text)
    }
}

// MARK: - SearchListInterface

extension SearchResultsViewController: SearchListInterface {
    func refetchAds() {
        moreItemLoadPage.accept(1)
        viewModel.load()
    }

    func loadMoreAds() {
        // Silences re-entrancy issue with RxSwift
        DispatchQueue.main.async {
            self.moreItemLoadPage.accept(self.viewModel.pager.nextPage)
        }
    }

    func didSelectAd(ad _: AdViewModel) {
        
    }

    func didSelectAR(ad _: AdViewModel) {}

    func didViewVideo(ad: AdViewModel) {
        viewModel.trackVideoView(ad)
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView.offsetY > offsetY {
            fabButton.setTitle(nil, for: .normal)
            fabButton.mode = .normal
        } else {
            fabButton.setTitle(R.string.localizable.searchResultSaveSearchButton().uppercased(), for: .normal)
            fabButton.mode  = .expanded
        }
        
        offsetY = scrollView.offsetY
    }

    func getNumberOfAds() -> Int {
        viewModel.getNumberOfItems()
    }

    func getAdViewModel(atIndex: Int) -> AdViewModel? {
        viewModel.getCell(row: atIndex)
    }
}
