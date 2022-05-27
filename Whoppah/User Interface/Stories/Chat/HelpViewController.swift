//
//  HelpViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 04/03/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxSwift

class HelpViewController: UIViewController {
    var viewModel: HelpViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar(title: viewModel.navTitle, enabled: true)
        
        let scrollView = ViewFactory.createScrollView()
        view.addSubview(scrollView.scroll)
        scrollView.scroll.pinToAllEdges(of: view)

        let root = scrollView.root

        let title = ViewFactory.createTitle(viewModel.title)
        root.addSubview(title)
        title.textColor = .shinyBlue

        title.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        title.verticalPin(to: root, orientation: .top, padding: UIConstants.titleTopMargin)

        let divider = ViewFactory.createDivider(orientation: .horizontal)
        root.addSubview(divider)
        divider.pinToEdges(of: root, orientation: .horizontal)
        divider.alignBelow(view: title, withPadding: 16)

        var lastSection: UIView?
        for (index, section) in viewModel.sections.enumerated() {
            let view = getSection(section, addDivider: index < viewModel.sections.count - 1)
            root.addSubview(view)
            view.pinToEdges(of: root, orientation: .horizontal)

            if let last = lastSection {
                view.alignBelow(view: last)
            } else {
                view.alignBelow(view: title, withPadding: 8)
            }
            lastSection = view
        }

        if let last = lastSection {
            root.verticalPin(to: last, orientation: .bottom, padding: 16)
        } else {
            root.verticalPin(to: title, orientation: .bottom, padding: 16)
        }
    }

    private func getSection(_ section: HelpViewModel.Section, addDivider: Bool) -> UIView {
        let root = ViewFactory.createView()
        let title = ViewFactory.createTitle(section.title)
        root.addSubview(title)
        title.numberOfLines = 0
        title.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        title.verticalPin(to: root, orientation: .top, padding: 16)

        switch section.mode {
        case .bullets(let texts):
            var lastBullet: UIView?
            for bullet in texts {
                let point = ViewFactory.createView()
                point.setSize(4, 4)
                point.backgroundColor = .black
                point.layer.cornerRadius = 2
                root.addSubview(point)
                point.horizontalPin(to: root, orientation: .leading, padding: UIConstants.margin)

                let text = ViewFactory.createLabel(text: bullet, lines: 0)
                root.addSubview(text)
                text.alignAfter(view: point, withPadding: 12)
                text.horizontalPin(to: root, orientation: .trailing, padding: -UIConstants.margin)
                if let last = lastBullet {
                    text.alignBelow(view: last, withPadding: 8)
                } else {
                    text.alignBelow(view: title, withPadding: 16)
                }
                point.verticalPin(to: text, orientation: .top, padding: 8)
                lastBullet = text
            }

            if let last = lastBullet {
                root.verticalPin(to: last, orientation: .bottom, padding: 24)
            } else {
                root.verticalPin(to: title, orientation: .bottom, padding: 24)
            }
        case .description(let text):
            let label = ViewFactory.createLabel(text: text, lines: 0)
            if text.containsHtml() {
                label.setHtml(text)
            } else {
                label.text = text
            }
            root.addSubview(label)
            label.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
            label.alignBelow(view: title, withPadding: 16)
            label.horizontalPin(to: root, orientation: .trailing, padding: -UIConstants.margin)
            root.verticalPin(to: label, orientation: .bottom, padding: 16)
        }

        if addDivider {
            let divider = ViewFactory.createDivider(orientation: .horizontal)
            root.addSubview(divider)
            divider.pinToEdges(of: root, orientation: .horizontal)
            divider.verticalPin(to: root, orientation: .bottom)
        }

        return root
    }
}
