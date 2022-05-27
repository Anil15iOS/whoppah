//
//  TextBlockView.swift
//  Whoppah
//
//  Created by Eddie Long on 26/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class TextBlockView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var title: UILabel!
    @IBOutlet var titleContainer: UIView!
    @IBOutlet var button: UIButton!
    @IBOutlet var container: UIView!
    @IBOutlet var titleHeader: UIView!

    // Outlets

    // Properties
    var carousel: Carousel?
    var pageControl: UIPageControl?
    var onPageSelected: ((TextSectionViewModel) -> Void)?

    var viewModel: TextBlockViewModel!
    private var bag: DisposeBag!

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
        Bundle.main.loadNibNamed("TextBlockView", owner: self, options: nil)
        addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.pinToEdges(of: self, orientation: .horizontal)
        contentView.pinToEdges(of: self, orientation: .vertical)
    }

    func configure(withBlock vm: TextBlockViewModel) {
        viewModel = vm
        bag = DisposeBag()
        vm.title.bind(to: title.rx.text).disposed(by: bag)
        vm.showTitleView.bind(to: titleContainer.rx.isVisible).disposed(by: bag)
        vm.button.bind(to: button.rx.title(for: .normal)).disposed(by: bag)
        vm.showTitleView.bind(to: button.rx.isVisible).disposed(by: bag)
        Observable.zip([vm.title, vm.button])
            .flatMapLatest { Observable.just($0.compactMap { $0 }.isEmpty) }
            .bind(to: titleHeader.rx.isHidden).disposed(by: bag)

        button.rx.tap.bind { [weak self] in
            self?.viewModel.didClickButton()
        }.disposed(by: bag)

        switch vm.style {
        case .single:
            guard !vm.sections.isEmpty else { return }
            let view = getSectionView(withVM: vm.sections.first!)
            container.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.pinToEdges(of: container, orientation: .horizontal)
            view.pinToEdges(of: container, orientation: .vertical)
        case .type1:
            let view = getType1SectionView(withVM: vm)
            container.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.pinToEdges(of: container, orientation: .horizontal)
            view.pinToEdges(of: container, orientation: .vertical)
        case .carousel:
            guard !vm.sections.isEmpty else { return }
            let carousel = Carousel(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))

            carousel.translatesAutoresizingMaskIntoConstraints = false
            carousel.pageSizePadding = 0
            carousel.leftRightPadding = 0
            carousel.onPageChange = { _, index in
                self.pageControl?.currentPage = index
            }
            carousel.onPageTapped = { index in
                guard index < vm.sections.count else { return }
                self.onPageSelected?(vm.sections[index])
            }

            for vm in vm.sections {
                let view = getSectionView(withVM: vm)
                carousel.addCarouselItem(view: view)
                view.pinToEdges(of: carousel, orientation: .horizontal)
                view.pinToEdges(of: carousel, orientation: .vertical)
            }

            let pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: 100, height: 37))
            pageControl.translatesAutoresizingMaskIntoConstraints = false
            pageControl.isVisible = true
            pageControl.currentPage = 0
            pageControl.numberOfPages = vm.sections.count
            pageControl.currentPageIndicatorTintColor = .cherry
            pageControl.pageIndicatorTintColor = .silver
            container.addSubview(pageControl)
            container.addSubview(carousel)
            carousel.pinToEdges(of: container, orientation: .horizontal)
            carousel.topAnchor.constraint(equalTo: container.topAnchor,
                                          constant: 0).isActive = true
            carousel.bottomAnchor.constraint(equalTo: container.bottomAnchor,
                                             constant: -40).isActive = true
            carousel.layout()
            pageControl.bottomAnchor.constraint(equalTo: container.bottomAnchor,
                                                constant: 0).isActive = true
            pageControl.centerXAnchor.constraint(equalTo: container.centerXAnchor,
                                                 constant: 0).isActive = true
            pageControl.subviews.forEach {
                $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            self.pageControl = pageControl
            self.carousel = carousel
        }
    }

    private func getSectionView(withVM vm: TextSectionViewModel) -> TextSectionView {
        let view = TextSectionView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        view.configure(withBlock: vm)
        vm.outputs.onClick.bind(to: viewModel.inputs.sectionClicked).disposed(by: bag)
        return view
    }
    
    private func getType1SectionView(withVM vm: TextBlockViewModel) -> Type1TextSectionView {
        let view = Type1TextSectionView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        view.configure(withBlock: vm)
        return view
    }
}
