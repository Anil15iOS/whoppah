//
//  CategoryCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 11/15/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit

class CircleImageCell: UICollectionViewCell {
    static let identifier = "CircleImageCell"
    static let nibName = "CircleImageCell"

    // MARK: - IBOutlets

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    private var vm: CircleImageCellViewModel!
    private var bag: DisposeBag!

    // MARK: - Nib

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.backgroundColor = .smoke
        
    }

    func configure(with vm: CircleImageCellViewModel) {
        bag = DisposeBag()
        vm.title.bind(to: nameLabel.rx.text).disposed(by: bag)
        vm.image.compactMap { $0 }.subscribe(onNext: { [weak self] url in
            guard let self = self else { return }
            self.imageView.setImage(url: url)
        }).disposed(by: bag)
        self.vm = vm
    }
    
    func onClick() {
        vm.onClick()
    }
}
