//
//  ContactViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 29/09/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import MessageUI

class ContactViewController: UIViewController {
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        let root = ViewFactory.createView()
        view.addSubview(root)
        root.pinToEdges(of: view, orientation: .horizontal)
        root.verticalPin(to: view, orientation: .top)

        let spark = ViewFactory.createImage(image: R.image.sparkOrange())
        root.addSubview(spark)
        spark.verticalPin(to: root, orientation: .top, padding: 60)
        spark.horizontalPin(to: root, orientation: .leading, padding: UIConstants.margin)

        let title = ViewFactory.createTitle(R.string.localizable.contactTitle())
        title.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        title.textColor = .orange
        root.addSubview(title)
        title.numberOfLines = 0

        title.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        title.alignBelow(view: spark, withPadding: 8)

        let description = ViewFactory.createLabel(text: R.string.localizable.contactDescription(), font: .descriptionLabel)
        root.addSubview(description)
        description.numberOfLines = 0
        description.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        description.alignBelow(view: title, withPadding: 16)
        
        let callButton = ViewFactory.createPrimaryButton(text: R.string.localizable.contactPhoneButton(),
                                                         style: .shinyBlue)
        callButton.setImage(R.image.ic_call(), for: .normal)
        callButton.setImage(R.image.ic_call(), for: .highlighted)
        callButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        callButton.setHeightAnchor(62)
        callButton.rx.tap.subscribe(onNext: { _ in
            var phoneNumber = R.string.localizable.whoppahPhoneNumberIntl()
            phoneNumber = String(phoneNumber.unicodeScalars.filter(CharacterSet.whitespaces.inverted.contains))
            
            guard let url = URL(string: "tel://\(phoneNumber)") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }).disposed(by: bag)
        let emailButton = ViewFactory.createPrimaryButton(text: R.string.localizable.contactEmailButton(),
                                                          style: .shinyBlue)
        emailButton.setImage(R.image.ic_mail(), for: .normal)
        emailButton.setImage(R.image.ic_mail(), for: .highlighted)
        emailButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        emailButton.setHeightAnchor(62)
        emailButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard MFMailComposeViewController.canSendMail() else {
                self.showErrorDialog(message: R.string.localizable.emailNotSetupError())
                return
            }
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients([R.string.localizable.contactEmailTo()])
            composeVC.setSubject(R.string.localizable.contactEmailSubject())
             
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }).disposed(by: bag)
        
        var buttons = [emailButton]
        if let url = URL(string: "tel://"), UIApplication.shared.canOpenURL(url) {
            buttons.append(callButton)
        }
        let stack = ViewFactory.createVerticalStack(views: buttons, spacing: 16, skeletonable: false)
        root.addSubview(stack)
        stack.alignBelow(view: description, withPadding: 16)
        stack.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        root.verticalPin(to: stack, orientation: .bottom, padding: 8)
    }
}

extension ContactViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}
