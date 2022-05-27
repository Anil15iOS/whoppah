//
//  GridADCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/26/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore

protocol GridADCellDelegate: AnyObject {
    func gridAdCell(_ cell: GridADCell, didClickLike button: RoundedButton)
    func gridAdCellDidViewVideo(_ cell: GridADCell)
}

class GridADCell: UICollectionViewCell {
    static let identifier = "GridADCell"
    static let nibName = "GridADCell"
    static let aspect: CGFloat = 1.2846

    // MARK: - IBOutlets

    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var likeButton: RoundedButton!
    @IBOutlet var arButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var badgeView: UIView!
    @IBOutlet var badgeLabel: UILabel!
    @IBOutlet var badgeIcon: UIImageView!
    @IBOutlet var mediaView: MediaView!
    @IBOutlet var inactiveOverlay: UIView!
    @IBOutlet var darkeningOverlay: UIView!
    @IBOutlet var widthConstraint: NSLayoutConstraint!
    
    // MARK: - Properties

    override var bounds: CGRect {
        didSet {
            // Without this for some reason the cell resizes itself based off the downloaded image
            // EVEN IF the contentMode is set to aspect fill
            // Setting this constraint seems to solve the problem, though it's rather unsatisfactory
            self.widthConstraint.constant = bounds.width
        }
    }
    var ad: AdViewModel!
    weak var delegate: GridADCellDelegate?
    weak var collectionView: UICollectionView?
    private var bag: DisposeBag!

    // MARK: - Nib

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = false

        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 4
        productImageView.backgroundColor = .smoke

        mediaView.showControls = false
        mediaView.layer.cornerRadius = 4
        mediaView.clipsToBounds = true
        mediaView.delegate = self
        mediaView.propogateThumbnailTaps = true

        setUpButtons()
        updateBadge(badge: nil)
    }

    // MARK: -

    func configure(withVM vm: AdViewModel) {
        bag = DisposeBag()
        ad = vm
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

    private func setUpButtons() {
        likeButton.backgroundColor = .white
        likeButton.setBackgroundImage(R.image.btn_like_normal(), for: .normal)
        likeButton.setBackgroundImage(R.image.btn_like_active(), for: .selected)
    }

    override func prepareForReuse() {
        arButton.isVisible = false
        badgeView.isVisible = false
        playButton.isVisible = false
    }

    func stopVideo() {
        if mediaView.isPlaying {
            mediaView.pause()
            playButton.isVisible = true
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

    // MARK: - Actions

    @IBAction func likeAction(_ sender: RoundedButton) {
        sender.isSelected = !sender.isSelected
        delegate?.gridAdCell(self, didClickLike: sender)
    }

    @IBAction func playAction(_: UIButton) {
        mediaView.play()
        mediaView.isVisible = true
        playButton.isVisible = false
    }
}

extension GridADCell: MediaViewDelegate {
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
        view.isVisible = true
        view.alpha = 1.0
        darkeningOverlay.isVisible = false
        delegate?.gridAdCellDidViewVideo(self)
    }
}
