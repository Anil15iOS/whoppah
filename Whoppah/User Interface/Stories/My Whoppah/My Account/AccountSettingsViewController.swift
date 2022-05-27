//
//  AccountSettingsViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 2/12/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import GoogleSignIn
import RxSwift
import UIKit
import WhoppahCore
import WhoppahCoreNext
import WhoppahModel
import Resolver
import Combine
import WhoppahUI

class AccountSettingsViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var navigationBar: NavigationBar!
    @IBOutlet var currentPasswordTextField: WPTextField!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var newPasswordTextField: WPTextField!
    @IBOutlet var repeatNewPasswordTextField: WPTextField!
    @IBOutlet var passwordStrongnessView: PasswordStrongnessView!
    @IBOutlet var saveButton: PrimaryLargeButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var passwordResetToast: ToastMessage!
    @IBOutlet var usernameChangedToast: ToastMessage!
    
    @LazyInjected private var userProvider: UserProviding
    @LazyInjected private var authenticationStore: AuthenticationStoring
    @LazyInjected private var deeplinkCoordinator: DeepLinkCoordinator
    
    private var cancellables = Set<AnyCancellable>()
    private var currentUser: Member?

    // MARK: - Properties

    private var items: [MenuItem] = []
    private var isNewPasswordValid: Bool {
        guard let oldPassword = currentPasswordTextField.text, !oldPassword.isEmpty else { return false }
        guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty else { return false }
        guard let repeatNewPassword = repeatNewPasswordTextField.text, !repeatNewPassword.isEmpty else { return false }
        let passwordMatches = newPassword == repeatNewPassword
        return passwordMatches && passwordStrongnessView.isValid
    }

    private var isNewPasswordEmpty: Bool {
        guard let newPassword = newPasswordTextField.text, newPassword.isEmpty else { return false }
        guard let repeatNewPassword = repeatNewPasswordTextField.text, repeatNewPassword.isEmpty else { return false }
        return true
    }

    private let bag = DisposeBag()

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        generateData()
        setUpTableView()
        setUpButtons()
        setUpTextFields()
        loadData()
    }

    // MARK: - Private

    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: MenuCell.nibName, bundle: nil), forCellReuseIdentifier: MenuCell.identifier)
    }

    private func generateData() {
        items.removeAll()
        items.append(MenuItem(title: R.string.localizable.my_account_terms_title(), icon: R.image.ic_document()))
        items.append(MenuItem(title: R.string.localizable.my_account_privacy_policy_title(), icon: R.image.ic_document()))
        items.append(MenuItem(title: R.string.localizable.my_account_logout_title(), icon: R.image.ic_exit_to_app()))
    }

    private func setUpNavigationBar() {
        navigationBar.titleLabel.text = R.string.localizable.main_my_profile_account_settings()
        navigationBar.backButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    private func setUpButtons() {
        saveButton.style = .primary
        saveButton.isEnabled = false
    }

    private func setUpTextFields() {
        currentPasswordTextField.placeholder = R.string.localizable.my_account_current_password_placeholder()
        currentPasswordTextField.delegate = self

        newPasswordTextField.placeholder = R.string.localizable.my_account_new_password_placeholder()
        newPasswordTextField.delegate = self

        repeatNewPasswordTextField.placeholder = R.string.localizable.my_account_reenter_new_password_placeholder()
        repeatNewPasswordTextField.delegate = self
    }

    private func loadData() {
        userProvider
            .currentUserPublisher?
            .sink(receiveValue: { [weak self] member in
                self?.currentUser = member
            })
            .store(in: &cancellables)
    }

    // MARK: - Actions

    @objc func backAction(_: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func saveAction(_ sender: PrimaryLargeButton) {
        view.endEditing(true)
        sender.startAnimating()

        guard let oldPassword = currentPasswordTextField.text, !oldPassword.isEmpty else { return }
        guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty else { return }
        guard let repeatNewPassword = repeatNewPasswordTextField.text, !repeatNewPassword.isEmpty else { return }
        
        userProvider.changePassword(oldPassword: oldPassword,
                                    newPassword: newPassword)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink { [weak self] result in
                guard let self = self else { return }
                
                sender.stopAnimating()
                
                switch result {
                case .failure(let error):
                    self.showError(error)
                case .finished:
                    self.saveButton.isEnabled = false
                    self.currentPasswordTextField.text = nil
                    self.newPasswordTextField.text = nil
                    self.repeatNewPasswordTextField.text = nil
                    self.passwordStrongnessView.text = ""
                    if !self.usernameChangedToast.isVisible {
                        self.passwordResetToast.show(in: self.view)
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + self.usernameChangedToast.totalDuration) {
                            self.passwordResetToast.show(in: self.view)
                        }
                    }
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }

    @IBAction func forgotPasswordAction(_: UIButton) {
        dismiss(animated: true) { [weak self] in
            self?.deeplinkCoordinator.handle(LoginView.NavigationView.forgotPassword)
        }
    }
}

// MARK: - UITableViewDataSource

extension AccountSettingsViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        tableViewHeight.constant = CGFloat(items.count) * 56.0
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier) as! MenuCell
        cell.configure(with: items[indexPath.row])
        cell.backgroundColor = .white
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AccountSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.row {
        case 0:
            let documentVC: DocumentViewController = createTermsVC()
            documentVC.isModalInPresentation = true
            if UIDevice.current.userInterfaceIdiom != .pad { documentVC.modalPresentationStyle = .fullScreen }
            present(documentVC, animated: true, completion: nil)
        case 1:
            let documentVC: DocumentViewController = createPrivacyVC()
            documentVC.isModalInPresentation = true
            if UIDevice.current.userInterfaceIdiom != .pad { documentVC.modalPresentationStyle = .fullScreen }
            present(documentVC, animated: true, completion: nil)
        case 2:
            let cell = tableView.cellForRow(at: indexPath) as? MenuCell
            cell?.toggleLoading(true)
            authenticationStore
                .signOutAll()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] result in
                    guard let self = self else { return }
                    self.navigationController?.popViewController(animated: false)
                    let route = Navigator.Route.home
                    Navigator().navigate(route: route)
                    cell?.toggleLoading(false)
                } receiveValue: { _ in }
                .store(in: &cancellables)
        default:
            break
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        56.0
    }
}

// MARK: - UITextFieldDelegate

extension AccountSettingsViewController: UITextFieldDelegate {
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        if textField == newPasswordTextField {
            passwordStrongnessView.text = textField.text!
        }

        saveButton.isEnabled = (isNewPasswordValid || isNewPasswordEmpty)
    }

    func textFieldDidEndEditing(_: UITextField) {
        saveButton.isEnabled = isNewPasswordValid || isNewPasswordEmpty
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
