//
//  DocumentViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 2/19/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit
import WebKit

class DocumentViewController: UIViewController {
    @IBOutlet var navigationBar: NavigationBar!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var loadingView: LoadingView!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var forwardButton: UIBarButtonItem!

    var titleText: String?
    var dateText: String?
    var mode: ContentMode?

    enum ContentMode {
        case text(text: String)
        case bundled(name: String)
        case url(name: URL)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        setUpWebview()
        dateText?.isEmpty != false ? dateLabel.removeFromSuperview() : (dateLabel.text = dateText)
        loadingView.isVisible = true

        switch mode {
        case let .text(text):
            webView.loadHTMLString(text, baseURL: nil)
        case let .bundled(name):
            let path = Bundle.main.path(forResource: name, ofType: "html", inDirectory: "HTML")!
            let resourcePath = Bundle.main.resourcePath
            let readAccessPath = URL(fileURLWithPath: resourcePath!).appendingPathComponent("HTML")
            webView.loadFileURL(URL(fileURLWithPath: path), allowingReadAccessTo: readAccessPath)
        case let .url(url):
            webView.load(URLRequest(url: url))
        case .none:
            break
        }
    }
}

// MARK: - Private

private extension DocumentViewController {
    func setUpWebview() {
        webView.navigationDelegate = self

        switch mode {
        case .url:
            backButton.isEnabled = false
            forwardButton.isEnabled = false
            backButton.tintColor = .black
            forwardButton.tintColor = .black
        default:
            toolBar.removeFromSuperview()
        }
    }

    func setUpNavigationBar() {
        navigationBar.titleLabel.text = titleText
        navigationBar.delegate = self
        if navigationController == nil {
            navigationBar.backButton.setImage(R.image.ic_close(), for: .normal)
        }
    }

    @IBAction func backPressed(_: Any) {
        webView.goBack()
    }

    @IBAction func forwardPressed(_: Any) {
        webView.goForward()
    }
}

// MARK: -

extension DocumentViewController: AddAnADNavigationBarDelegate {
    func navigationBarDidPressCloseButton(_: NavigationBar) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: -

extension DocumentViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
        loadingView.isHidden = true
    }

    func webView(_ webView: WKWebView, didCommit _: WKNavigation!) {
        backButton?.isEnabled = webView.canGoBack
        forwardButton?.isEnabled = webView.canGoForward
    }

    func webView(_: WKWebView, didFail _: WKNavigation!, withError _: Error) {
        loadingView.isHidden = true
    }
}

// MARK: -

private func getLastUpdatedString() -> String {
    let date = Date(timeIntervalSince1970: 1_574_419_785) // 22nd November 2019
    let customFormat = "MMMM YYYY"
    let format = DateFormatter.dateFormat(fromTemplate: customFormat, options: 0, locale: Locale.whoppahLocale().toLocale())

    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: date)
}

func createTermsVC() -> DocumentViewController {
    let documentVC: DocumentViewController = UIStoryboard(storyboard: .myWhoppah).instantiateViewController()
    documentVC.titleText = R.string.localizable.whoppah_terms_view_title()
    documentVC.dateText = R.string.localizable.whoppah_terms_last_updated_date(getLastUpdatedString()).uppercased()
    documentVC.mode = .bundled(name: "terms")
    return documentVC
}

func createPrivacyVC() -> DocumentViewController {
    let documentVC: DocumentViewController = UIStoryboard(storyboard: .myWhoppah).instantiateViewController()
    documentVC.titleText = R.string.localizable.whoppah_privacy_policy_view_title()
    documentVC.dateText = R.string.localizable.whoppah_privacy_policy_last_updated_date(getLastUpdatedString()).uppercased()
    documentVC.mode = .bundled(name: "privacy")
    return documentVC
}

func createStripeVC() -> DocumentViewController {
    let documentVC: DocumentViewController = UIStoryboard(storyboard: .myWhoppah).instantiateViewController()
    documentVC.titleText = R.string.localizable.stripeTermsViewTitle()
    documentVC.dateText = nil
    documentVC.mode = .url(name: URL(string: "https://stripe.com/en-nl/ssa")!)
    return documentVC
}
