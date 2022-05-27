//
//  TextSectionView.swift
//  Whoppah
//
//  Created by Eddie Long on 26/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class Type1TextSectionView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var blockDescription: UILabel!
    @IBOutlet var button: UIButton!

    var viewModel: TextBlockViewModel!

    private var bag = DisposeBag()

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
        Bundle.main.loadNibNamed("Type1TextSectionView", owner: self, options: nil)
        addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.pinToEdges(of: self, orientation: .horizontal)
        contentView.pinToEdges(of: self, orientation: .vertical)
    }

    func configure(withBlock vm: TextBlockViewModel) {
        viewModel = vm
        viewModel.image.compactMap { $0 }.subscribe(onNext: { [weak self] url in
            guard let self = self else { return }
            self.backgroundImage.setImage(url: url)
        }).disposed(by: bag)

        vm.title.map { $0 == nil }.bind(to: title.rx.isHidden).disposed(by: bag)
        vm.title.bind(to: title.rx.text).disposed(by: bag)

        vm.description.map { $0 == nil }.bind(to: blockDescription.rx.isHidden).disposed(by: bag)
        vm.description.bind(to: blockDescription.rx.text).disposed(by: bag)

        vm.button.map { $0 == nil }.bind(to: button.rx.isHidden).disposed(by: bag)
        vm.button.bind(to: button.rx.title(for: .normal)).disposed(by: bag)

        let tapGesture = UITapGestureRecognizer()
        contentView.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: { _ in
            vm.didClickButton()
        }).disposed(by: bag)
    }
}
