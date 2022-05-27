//
//  TabBar.swift
//  Whoppah
//
//  Created by Boris Sagan on 10/30/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

protocol TabBarDelegate: AnyObject {
    @discardableResult
    func tabBar(_ tabBar: TabBar, canSelectTab type: TabBar.Tab) -> Bool
    func tabBar(_ tabBar: TabBar, didSelectTab type: TabBar.Tab)
    func tabBarDidSelectCamera(_ tabBar: TabBar)
}

class TabBar: UIView {
    enum Tab {
        case home
        case favorites
        case myWhoppah
        case chat
    }

    // MARK: - IBOutlets

    @IBOutlet var contentView: UIView!
    @IBOutlet var homeButton: UIButton!
    @IBOutlet var homeLabel: UILabel!
    @IBOutlet var favoritesButton: UIButton!
    @IBOutlet var favoritesLabel: UILabel!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var cameraLabel: UILabel!
    @IBOutlet var myWhoppahButton: UIButton!
    @IBOutlet var myWhoppahLabel: UILabel!
    @IBOutlet var chatButton: UIButton!
    @IBOutlet var chatLabel: UILabel!
    @IBOutlet var chatBadgeView: UIView!
    @IBOutlet var chatUnreadCountLabel: UILabel!

    // MARK: - Properties

    weak var delegate: TabBarDelegate?
    var selectedTab: Tab = .home {
        willSet {
            switch selectedTab {
            case .home:
                homeButton.isSelected = false
                homeLabel.textColor = .steel
            case .favorites:
                favoritesButton.isSelected = false
                favoritesLabel.textColor = .steel
            case .myWhoppah:
                myWhoppahButton.isSelected = false
                myWhoppahLabel.textColor = .steel
            case .chat:
                chatButton.isSelected = false
                chatLabel.textColor = .steel
            }
        }
        didSet {
            switch selectedTab {
            case .home:
                homeButton.isSelected = true
                homeLabel.textColor = .orange
            case .favorites:
                favoritesButton.isSelected = true
                favoritesLabel.textColor = .orange
            case .myWhoppah:
                myWhoppahButton.isSelected = true
                myWhoppahLabel.textColor = .orange
            case .chat:
                chatButton.isSelected = true
                chatLabel.textColor = .orange
            }
        }
    }

    var chatBadgeNumber: Int = 0 {
        didSet {
            chatBadgeView.isHidden = chatBadgeNumber == 0
            chatUnreadCountLabel.text = "\(chatBadgeNumber)"
            UIApplication.shared.applicationIconBadgeNumber = chatBadgeNumber
        }
    }

    override var bounds: CGRect {
        didSet {
            contentView.frame = bounds
        }
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: - Common

    private func commonInit() {
        Bundle.main.loadNibNamed("TabBar", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        homeButton.adjustsImageWhenHighlighted = false
        favoritesButton.adjustsImageWhenHighlighted = false
        myWhoppahButton.adjustsImageWhenHighlighted = false
        chatButton.adjustsImageWhenHighlighted = false

        homeButton.setImage(R.image.ic_home()?.tinted(with: .orange), for: .selected)
        favoritesButton.setImage(R.image.ic_favorites()?.tinted(with: .orange), for: .selected)
        myWhoppahButton.setImage(R.image.ic_my_profile()?.tinted(with: .orange), for: .selected)
        chatButton.setImage(R.image.ic_chats()?.tinted(with: .orange), for: .selected)

        cameraButton.makeCircular()

        chatBadgeView.layer.cornerRadius = 8.0
    }

    // MARK: - Actions

    @IBAction func homeAction(_: UIButton) {
        guard let canSelect = delegate?.tabBar(self, canSelectTab: .home), canSelect == true else { return }
        delegate?.tabBar(self, didSelectTab: .home)
    }

    @IBAction func favoriteAction(_: UIButton) {
        guard let canSelect = delegate?.tabBar(self, canSelectTab: .favorites), canSelect == true else { return }
        delegate?.tabBar(self, didSelectTab: .favorites)
    }

    @IBAction func cameraAction(_: UIButton) {
        delegate?.tabBarDidSelectCamera(self)
    }

    @IBAction func myWhoppahAction(_: UIButton) {
        guard let canSelect = delegate?.tabBar(self, canSelectTab: .myWhoppah), canSelect == true else { return }
        delegate?.tabBar(self, didSelectTab: .myWhoppah)
    }

    @IBAction func chatAction(_: UIButton) {
        guard let canSelect = delegate?.tabBar(self, canSelectTab: .chat), canSelect == true else { return }
        delegate?.tabBar(self, didSelectTab: .chat)
    }
}
