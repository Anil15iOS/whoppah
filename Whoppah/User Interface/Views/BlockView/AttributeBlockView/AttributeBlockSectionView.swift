//
//  AttributeBlockSectionView.swift
//  Whoppah
//
//  Created by Eddie Long on 26/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift

class AttributeBlockSectionView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var trendTitle: UILabel!

    private var viewModel: AttributeBlockSectionViewModel!
    private let bag = DisposeBag()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Common

    private func commonInit() {
        Bundle.main.loadNibNamed("AttributeBlockSectionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    func configure(withVM vm: AttributeBlockSectionViewModel) {
        viewModel = vm
        vm.image.bind(to: backgroundImage.rx.imageUrl).disposed(by: bag)
        vm.title.bind(to: title.rx.text).disposed(by: bag)
        vm.showTrendTitle.bind(to: trendTitle.rx.isVisible).disposed(by: bag)

        let tap = UITapGestureRecognizer()
        tap.rx.event.bind(onNext: { [weak self] _ in
            self?.viewModel.cellClicked()
        }).disposed(by: bag)
        addGestureRecognizer(tap)
    }
}
