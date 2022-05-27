//
//  AdAnnotationView.swift
//  Whoppah
//
//  Created by Boris Sagan on 11/19/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import MapKit

class AdAnnotationView: MKAnnotationView {
    @IBOutlet var contentView: UIView?
    @IBOutlet var containerView: UIView?
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var priceLabel: UILabel!

    // MARK: - Initialization

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        guard let nibView = loadViewFromNib() else { return }
        contentView = nibView
        bounds = nibView.frame
        addSubview(nibView)

        contentView?.translatesAutoresizingMaskIntoConstraints = false
        containerView?.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        containerView?.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        containerView?.widthAnchor.constraint(equalTo: widthAnchor, constant: 0).isActive = true
        containerView?.heightAnchor.constraint(equalTo: heightAnchor, constant: 0).isActive = true

        imageView.layer.cornerRadius = 2.0
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
    }

    func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let name = "AdAnnotationView"
        let nib = UINib(nibName: name, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        bounds = containerView!.bounds
    }

    override func prepareForReuse() {
        super.layoutSubviews()
        bounds = containerView!.bounds
    }
}
