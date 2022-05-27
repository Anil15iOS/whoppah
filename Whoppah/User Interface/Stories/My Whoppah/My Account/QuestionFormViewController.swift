//
//  QuestionFormViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/28/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCoreNext
import WhoppahCore
import Resolver

class QuestionFormViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var navigationBar: NavigationBar!
    @IBOutlet var questionTextField: WPTextField!
    @IBOutlet var topDescriptionLabel: UILabel!
    @IBOutlet var questionCountLabel: UILabel!
    @IBOutlet var bottomDescriptionLabel: UILabel!
    @IBOutlet var sendButton: PrimaryLargeButton!

    private let bag = DisposeBag()
    
    @Injected private var user: WhoppahCore.LegacyUserService
    
    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        setUpButtons()
        setUpTextField()
        setUpLabels()
    }

    // MARK: - Private

    private func setUpNavigationBar() {
        navigationBar.titleLabel.text = R.string.localizable.question_form_navigation_title()
        navigationBar.backButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
    }

    private func setUpButtons() {
        sendButton.style = .primary
        sendButton.isEnabled = false
    }

    private func setUpLabels() {
        bottomDescriptionLabel.isVisible = false
    }

    private func setUpTextField() {
        questionTextField.placeholder = R.string.localizable.question_form_text_field_placeholder()
        questionTextField.delegate = self
    }

    private func dismiss() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Actions

    @objc func backAction(_: UIButton) {
        dismiss()
    }

    @IBAction func sendAction(_ sender: PrimaryLargeButton) {
        sender.startAnimating()

        user.sendQuestionForSupport(text: questionTextField.text!)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.questionTextField.text = nil
                self.sendButton.isEnabled = false
                let questionWasSentDialog = QuestionWasSentDialog()
                questionWasSentDialog.onComplete = {
                    self.dismiss()
                }
                self.present(questionWasSentDialog, animated: true, completion: nil)
            }, onError: { [weak self] error in
                self?.showError(error)
            }).disposed(by: bag)
    }
}

extension QuestionFormViewController: UITextFieldDelegate {
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        let currentText = textField.text!
        sendButton.isEnabled = !currentText.isEmpty
        questionCountLabel.text = R.string.localizable.question_form_character_count_label(currentText.count, 2000)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        let char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        var currentText = ""
        if isBackSpace == -92 {
            if !textField.text!.isEmpty {
                currentText = String(textField.text![..<textField.text!.index(before: textField.text!.endIndex)])
            }
        } else {
            currentText = textField.text! + string
        }

        return currentText.count <= 2000
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
