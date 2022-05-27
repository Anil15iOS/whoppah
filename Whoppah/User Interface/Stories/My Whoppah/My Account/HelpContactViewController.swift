//
//  HelpContactViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/28/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import ExpandableCell
import RxSwift
import SkeletonView
import UIKit
import WhoppahCore
import WhoppahCoreNext
import Resolver

class HelpContactViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var navigationBar: NavigationBar!
    @IBOutlet var tableView: ExpandableTableView!
    @IBOutlet var loadingTableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var sendMessageButton: SecondaryLargeButton!
    @IBOutlet var suggestionButton: SecondaryLargeButton!
    @IBOutlet var footerView: UIView!

    private var repo: PageRepository?
    private let bag = DisposeBag()
    var items: [TextBlock] = []
    var isExpanded: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        setUpButtons()
        setUpTableViews()
        setUpDatasource()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        loadContent()
    }

    // MARK: - Private

    private func setUpDatasource() {
        let repo = PageRepositoryImpl()
        repo.blocks
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] blocks in
                guard let self = self else { return }

                self.items = blocks.compactMap { $0.asTextBlock }
                self.isExpanded = Array(repeating: false, count: self.items.count)
                self.loadingTableView.hideSkeleton()
                self.loadingTableView.isHidden = true
                self.tableView.isHidden = false
                self.footerView.isHidden = false
                self.tableView.reloadData()
                self.tableViewHeight.constant = CGFloat(self.items.count) * 56.0
            }, onError: { [weak self] error in
                self?.showError(error)
            }).disposed(by: bag)
        self.repo = repo
    }

    private func setUpNavigationBar() {
        navigationBar.titleLabel.text = R.string.localizable.main_my_profile_faq()
        navigationBar.backButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
    }

    private func setUpButtons() {
        sendMessageButton.buttonColor = .orange
        suggestionButton.buttonColor = .white
    }

    private func setUpTableViews() {
        tableView.animation = .none
        tableView.expandableDelegate = self
        tableView.register(UINib(nibName: FAQQuestionCell.nibName, bundle: nil), forCellReuseIdentifier: FAQQuestionCell.identifier)
        tableView.register(UINib(nibName: FAQAnswerCell.nibName, bundle: nil), forCellReuseIdentifier: FAQAnswerCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.isVisible = false

        loadingTableView.dataSource = self
        loadingTableView.register(UINib(nibName: FAQAnswerCell.nibName, bundle: nil), forCellReuseIdentifier: FAQAnswerCell.identifier)
    }

    private func loadContent() {
        guard items.isEmpty else { return }
        repo?.load(slug: "faq")
    }

    // MARK: - Actions

    @objc func backAction(_: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func sendMessageAction(_: SecondaryLargeButton) {
        let questionFormVC: QuestionFormViewController = UIStoryboard(storyboard: .myWhoppah).instantiateViewController()
        navigationController?.pushViewController(questionFormVC, animated: true)
    }

    @IBAction func suggestionAction(_: SecondaryLargeButton) {
        let questionFormVC: QuestionFormViewController = UIStoryboard(storyboard: .myWhoppah).instantiateViewController()
        navigationController?.pushViewController(questionFormVC, animated: true)
    }
}

// MARK: SkeletonDatasource

extension HelpContactViewController: SkeletonTableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        20
    }

    func tableView(_: UITableView, cellForRowAt _: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }

    func numSections(in _: UITableView) -> Int {
        1
    }

    func collectionSkeletonView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        20
    }

    func collectionSkeletonView(_: UITableView, cellIdentifierForRowAt _: IndexPath) -> ReusableCellIdentifier {
        FAQAnswerCell.identifier
    }
}

// MARK: - ExpandableDelegate

extension HelpContactViewController: ExpandableDelegate {
    func expandableTableView(_: ExpandableTableView, numberOfRowsInSection _: Int) -> Int {
        items.count
    }

    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = expandableTableView.dequeueReusableCell(withIdentifier: FAQQuestionCell.identifier) as! FAQQuestionCell
        cell.configure(with: items[indexPath.row])
        return cell
    }

    func expandableTableView(_: ExpandableTableView, heightForRowAt _: IndexPath) -> CGFloat {
        56.0
    }

    private func getAnswerHeight(_ text: String, _ expandableTableView: ExpandableTableView) -> CGFloat? {
        let font = UIFont.bodyText
        guard let attributed = text.htmlAttributed(family: font.familyName, size: 10.0, color: UIColor.space) else { return nil }
        return attributed.height(withConstrainedWidth: expandableTableView.bounds.width - 32.0) + 32.0
    }

    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        let cell = expandableTableView.dequeueReusableCell(withIdentifier: FAQAnswerCell.identifier) as! FAQAnswerCell
        cell.configure(with: items[indexPath.row])
        return [cell]
    }

    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        let item = items[indexPath.row]
        guard let text = localizedString(item.descriptionKey) else {
            return nil
        }
        guard let height = getAnswerHeight(text, expandableTableView) else { return nil }
        return [height]
    }

    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAt indexPath: IndexPath) {
        expandableTableView.deselectRow(at: indexPath, animated: true)
        let cell = expandableTableView.cellForRow(at: indexPath) as! FAQQuestionCell
        let index = items.enumerated().filter { $0.element.titleKey == cell.titleKey }.first!.offset
        isExpanded[index] = !isExpanded[index]
        cell.state = isExpanded[index] ? .expanded : .normal

        var totalHeight = CGFloat(items.count) * 56.0
        for (offset, element) in items.enumerated() {
            guard isExpanded[offset] else { continue }
            guard let text = localizedString(element.descriptionKey) else {
                continue
            }

            guard let height = getAnswerHeight(text, expandableTableView) else { continue }
            totalHeight += height
        }

        tableViewHeight.constant = totalHeight
    }

    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCell _: UITableViewCell, didSelectExpandedRowAt indexPath: IndexPath) {
        expandableTableView.deselectRow(at: indexPath, animated: true)
    }

    @objc(expandableTableView:didCloseRowAt:) func expandableTableView(_: UITableView, didCloseRowAt _: IndexPath) {}

    func expandableTableView(_: UITableView, shouldHighlightRowAt _: IndexPath) -> Bool {
        true
    }

    func numberOfSections(in _: ExpandableTableView) -> Int {
        1
    }
}
