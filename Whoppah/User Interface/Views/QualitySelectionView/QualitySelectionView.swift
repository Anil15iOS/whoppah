//
//  QualitySelectionView.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/8/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
import WhoppahCore
import WhoppahDataStore

protocol QualitySelectionViewDelegate: AnyObject {
    func qualitySelectionView(didChangeQuality value: GraphQL.ProductQuality)
}

class QualitySelectionView: UIView {
    private var goodQualityButton: QualityButton!
    private var veryGoodQualityButton: QualityButton!
    private var excellentQualityButton: QualityButton!

    let buttonGap: CGFloat = 24

    weak var delegate: QualitySelectionViewDelegate?
    struct Inputs {
        var quality = PublishSubject<GraphQL.ProductQuality>()
    }

    struct Outputs {
        var qualityRelay = BehaviorRelay<GraphQL.ProductQuality?>(value: nil)
    }

    let inputs = Inputs()
    let outputs = Outputs()
    private let bag = DisposeBag()

    var selectedQuality: GraphQL.ProductQuality = .good {
        willSet {
            switch selectedQuality {
            case .good:
                goodQualityButton.isSelected = false
            case .great:
                veryGoodQualityButton.isSelected = false
            case .perfect:
                excellentQualityButton.isSelected = false
            case .__unknown: break
            }
        }
        didSet {
            switch selectedQuality {
            case .good:
                goodQualityButton.isSelected = true
            case .great:
                veryGoodQualityButton.isSelected = true
            case .perfect:
                excellentQualityButton.isSelected = true
            case .__unknown: break
            }
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

    // MARK: - Common Init

    private func commonInit() {
        let stackView = ViewFactory.createHorizontalStack(spacing: buttonGap)
        stackView.alignment = .center
        stackView.distribution = .fillEqually

        goodQualityButton = QualityButton(frame: .zero)
        goodQualityButton.translatesAutoresizingMaskIntoConstraints = false
        goodQualityButton.setAspect(1)
        goodQualityButton.name = R.string.localizable.create_ad_main_condition_value_1()
        goodQualityButton.quality = .good
        let goodTap = UITapGestureRecognizer(target: self, action: #selector(goodAction(_:)))
        goodQualityButton.addGestureRecognizer(goodTap)
        stackView.addArrangedSubview(goodQualityButton)

        veryGoodQualityButton = QualityButton(frame: .zero)
        veryGoodQualityButton.translatesAutoresizingMaskIntoConstraints = false
        veryGoodQualityButton.setAspect(1)
        veryGoodQualityButton.name = R.string.localizable.create_ad_main_condition_value_2()
        veryGoodQualityButton.quality = .great
        let veryGoodTap = UITapGestureRecognizer(target: self, action: #selector(veryGoodAction(_:)))
        veryGoodQualityButton.addGestureRecognizer(veryGoodTap)
        stackView.addArrangedSubview(veryGoodQualityButton)

        excellentQualityButton = QualityButton(frame: .zero)
        excellentQualityButton.translatesAutoresizingMaskIntoConstraints = false
        excellentQualityButton.setAspect(1)
        excellentQualityButton.name = R.string.localizable.create_ad_main_condition_value_3()
        excellentQualityButton.quality = .perfect
        let excellentTap = UITapGestureRecognizer(target: self, action: #selector(excellentAction(_:)))
        excellentQualityButton.addGestureRecognizer(excellentTap)
        stackView.addArrangedSubview(excellentQualityButton)

        addSubview(stackView)
        stackView.pinToAllEdges(of: self)

        inputs.quality.subscribe(onNext: { [weak self] newQuality in
            self?.selectedQuality = newQuality
        }).disposed(by: bag)
    }

    @objc func goodAction(_: UITapGestureRecognizer) {
        selectedQuality = .good
        outputs.qualityRelay.accept(selectedQuality)
        delegate?.qualitySelectionView(didChangeQuality: selectedQuality)
    }

    @objc func veryGoodAction(_: UITapGestureRecognizer) {
        selectedQuality = .great
        outputs.qualityRelay.accept(selectedQuality)
        delegate?.qualitySelectionView(didChangeQuality: selectedQuality)
    }

    @objc func excellentAction(_: UITapGestureRecognizer) {
        selectedQuality = .perfect
        outputs.qualityRelay.accept(selectedQuality)
        delegate?.qualitySelectionView(didChangeQuality: selectedQuality)
    }
}
