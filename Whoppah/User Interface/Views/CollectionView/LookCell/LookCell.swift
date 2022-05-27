//
//  LookCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 2/25/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit

class LookCell: UICollectionViewCell {
    static let identifier = "LookCell"
    static let nibName = "LookCell"

    // MARK: - IBOutlets

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabelFeatured: UILabel!
    @IBOutlet var featuredView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var buyView: UIView!

    static let aspect: CGFloat = 0.6722

    // MARK: -

    var gradient: CAGradientLayer?
    private var bag: DisposeBag!
    private let tapGesture = UITapGestureRecognizer()

    // MARK: -

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.backgroundColor = .smoke

        gradient = CAGradientLayer()
        gradient?.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.34).cgColor
        ]

        buyView.isVisible = false
        gradient?.locations = [0, 1]
        imageView.layer.insertSublayer(gradient!, at: 0)
        addGestureRecognizer(tapGesture)
    }

    func configure(with vm: AttributeBlockSectionViewModel, isFeatured: Bool) {
        bag = DisposeBag()
        vm.title.bind(to: nameLabel.rx.text).disposed(by: bag)
        vm.title.bind(to: nameLabelFeatured.rx.text).disposed(by: bag)
        vm.image.bind(to: imageView.rx.imageUrl).disposed(by: bag)
        tapGesture.rx.event.bind(onNext: { _ in
            vm.cellClicked()
        }).disposed(by: bag)

        featuredView.isVisible = isFeatured
        nameLabel.isVisible = !isFeatured
        buyView.isVisible = true
    }

    override func prepareForReuse() {
        buyView.isVisible = false
    }
}
