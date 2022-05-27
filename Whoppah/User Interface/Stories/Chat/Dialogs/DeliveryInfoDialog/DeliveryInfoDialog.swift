//
//  DeliveryInfoDialog.swift
//  Whoppah
//
//  Created by Alisa Martirosyan on 06.07.21.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import UIKit

class DeliveryInfoDialog: BaseDialog {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var deliveryContainerView: UIView!
    @IBOutlet weak var pickupContainerView: UIView!
    @IBOutlet weak var deliveryMethodLabel: UILabel!
    @IBOutlet weak var deliveryPriceLabel: UILabel!
    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var pickupPrice: UILabel!
    @IBOutlet weak var wholeView: UIView!
    
    var deliveryData: DeliveryUIData!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wholeView.layer.cornerRadius = 4
        wholeView.layer.masksToBounds = true

        deliveryContainerView.isHidden = deliveryData.delivery.description.isEmpty
        pickupContainerView.isHidden = deliveryData.pickUp.description.isEmpty

        if deliveryData.delivery.description != "" {
            deliveryMethodLabel.text = "product-shipping-\(deliveryData.delivery.type.lowercased())-title".localized
            deliveryPriceLabel.text = deliveryData.delivery.price
        }

        if deliveryData.pickUp.description != "" {
            pickupLabel.text = deliveryData.pickUp.description
            pickupPrice.text = deliveryData.pickUp.price
        }
    }

    static func create(with data: DeliveryUIData) -> DeliveryInfoDialog {
        let dialog = DeliveryInfoDialog()
        dialog.deliveryData = data
        return dialog
    }
    
    @IBAction override func closeAction(_ sender: UIButton) {
        dismiss()
    }
}
