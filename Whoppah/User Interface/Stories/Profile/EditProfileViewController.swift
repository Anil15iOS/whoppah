//
//  EditProfileViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 10/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit

class EditProfileViewController: UIViewController {
    // MARK: Privates

    var viewModel: EditProfileViewModel?

    // MARK: - IBOutlets

    @IBOutlet var navigationBar: NavigationBar!
    @IBOutlet var username: WPTextField!
    @IBOutlet var about: WPTextViewContainer!
    @IBOutlet var submitButton: PrimaryLargeButton!
    @IBOutlet var whoppahIsNotAllowedLabel: UILabel!
    @IBOutlet var cannotBeEmptyLabel: UILabel!

    private let bag = DisposeBag()

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        setUpLabel()
        setUpButtons()
        setUpUser()
    }

    // MARK: - Private

    private func setUpNavigationBar() {
        navigationBar.titleLabel.text = R.string.localizable.main_my_profile_navigation_title()
        navigationBar.backButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
    }

    private func setUpLabel() {
        username.placeholder = R.string.localizable.main_my_profile_username_placeholder()
        about.placeholder = R.string.localizable.main_my_profile_about_description_title()
    }

    private func setUpButtons() {
        submitButton.style = .primary
    }

    private func setUpUser() {
        let data = viewModel!.getUIData()
        refreshData(data)
    }

    private func refreshData(_ data: EditProfileUIData) {
        username.text = data.name
        about.textview.text = data.about
    }

    private func dismiss() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Actions

    @objc func backAction(_: UIButton) {
        dismiss()
    }

    @IBAction func submit(_: UIButton) {
        let data = EditProfileUIData(name: username.text!, about: about.textview.text!)
        
        cannotBeEmptyLabel.isHidden = true
        whoppahIsNotAllowedLabel.isHidden = true
        
        if username.text?.isEmpty == true {
            cannotBeEmptyLabel.isHidden = false
            return
        }
        
        if username.text?.lowercased().contains("whoppah") == true {
            whoppahIsNotAllowedLabel.isHidden = false
            return
        }
        
        submitButton.startAnimating()
        viewModel?.save(profileData: data)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.submitButton.stopAnimating()
                self?.dismiss()
            }, onError: { [weak self] error in
                self?.submitButton.stopAnimating()
                self?.showError(error)
            }).disposed(by: bag)
    }
}
