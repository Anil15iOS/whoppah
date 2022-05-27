//
//  ListADCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/6/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore

protocol ListADCellDelegate: AnyObject {
    func listAdCell(_ cell: ListADCell, didClickLike button: UIButton)
    func listAdCellDidViewVideo(_ cell: ListADCell)
}

class ListADCell: UICollectionViewCell {
    static let identifier = "ListADCell"
    static let nibName = "ListADCell"

    // MARK: - IBOutlets

    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var likeButton: RoundedButton!
    @IBOutlet var arButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var mediaView: MediaView!
    @IBOutlet var inactiveOverlay: UIView!
    @IBOutlet var darkeningOverlay: UIView!
    @IBOutlet var badgeView: UIView!
    @IBOutlet var badgeLabel: UILabel!
    @IBOutlet var badgeIcon: UIImageView!

    // MARK: - Properties

    var ad: AdViewModel!
    weak var delegate: ListADCellDelegate?
    private var bag: DisposeBag!

    override func awakeFromNib() {
        super.awakeFromNib()

        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 4
        productImageView.backgroundColor = .smoke
        mediaView.showControls = false
        mediaView.delegate = self
        mediaView.propogateThumbnailTaps = true
        mediaView.layer.cornerRadius = 4
        mediaView.clipsToBounds = true

        setUpButtons()
    }

    // MARK: -

    func configure(withVM vm: AdViewModel) {
        ad = vm
        bag = DisposeBag()
        nameLabel.text = vm.title
        productImageView.loadImage(vm.thumbnail, mediaCache: vm.mediaCache)
        priceLabel.textColor = vm.priceColor
        priceLabel.attributedText = vm.price
        inactiveOverlay.isVisible = vm.showInactiveOverlay

        darkeningOverlay.isVisible = true
        vm.isLiked.bind(to: likeButton.rx.isSelected).disposed(by: bag)
        vm.showLike.bind(to: likeButton.rx.isVisible).disposed(by: bag)

        arButton.isVisible = vm.supportsAR
        mediaView.isVisible = false

        updateBadge(badge: vm.badge)

        if let video = vm.video {
            vm.mediaCache.loadVideo(video: video, expiry: userGeneratedContentDurationSeconds) { [weak self] url in
                guard let self = self, let url = url else { return }
                self.mediaView.configure(videoUrl: url)
            }
            playButton.isVisible = true
        } else {
            playButton.isVisible = false
        }
    }
    
    private func updateBadge(badge: ProductBadge?) {
        if let badge = badge {
            badgeView.isHidden = true
            let text = observedLocalizedString(badge.textKey)
            text.bind(to: badgeLabel.rx.text).disposed(by: bag)
            text.compactMap { $0?.isEmpty }.bind(to: badgeView.rx.isHidden).disposed(by: bag)
            let hex = badge.backgroundHex ?? localizedString(badge.colorKey) ?? "#000"
            badgeView.backgroundColor = UIColor(hexString: hex)
            
            if  let icon = UIImage(named: badge.slug) {
                badgeIcon.isHidden = false
                badgeIcon.image = icon
            } else {
                badgeIcon.isHidden = true
            }
        } else {
            badgeView.isHidden = true
        }
    }

    private func setUpButtons() {
        likeButton.backgroundColor = .white
        likeButton.setBackgroundImage(R.image.btn_like_normal(), for: .normal)
        likeButton.setBackgroundImage(R.image.btn_like_active(), for: .selected)
    }

    func stopVideo() {
        if mediaView.isPlaying {
            mediaView.pause()
            playButton.isVisible = true
        }
    }

    // MARK: - Actions

    @IBAction func likeAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.listAdCell(self, didClickLike: sender)
    }

    @IBAction func playAction(_: UIButton) {
        mediaView.play()
        mediaView.isVisible = true
        playButton.isVisible = false
    }
}

extension ListADCell: MediaViewDelegate {
    func mediaViewDidSelect(_: MediaView, at _: Int?) {}

    func videoDidEnd() {
        UIView.animate(withDuration: 0.2, animations: {
            self.mediaView.alpha = 0.0
        }, completion: { _ in
            self.darkeningOverlay.isVisible = true
            self.mediaView.isVisible = false
            self.playButton.isVisible = true
        })
    }

    func videoDidStart(_ view: MediaView) {
        darkeningOverlay.isVisible = false
        view.isVisible = true
        view.alpha = 1.0
        delegate?.listAdCellDidViewVideo(self)
    }
}
