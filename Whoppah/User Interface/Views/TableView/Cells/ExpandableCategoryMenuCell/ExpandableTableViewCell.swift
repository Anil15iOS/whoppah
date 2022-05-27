//
//  ExpandableTableViewCell.swift
//  Whoppah
//
//  Created by macbook on 1/23/21.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore

class ExpandableTableViewCell: UITableViewCell {
    static let identifier = "ExpandableTableViewCell"

    // MARK: - Properties
    
    var category: CategoryStateAndHierarchy!
    private var categoriesMenuVC: CategoriesMenuViewController!
    weak var parentVC: ParentCategoriesMenuViewController!
    
    // MARK: - Nib
  
    func configure(with category: CategoryStateAndHierarchy) {
        self.category = category
      
        categoriesMenuVC = (UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "CategoriesMenuViewController") as! CategoriesMenuViewController)
        contentView.addSubview(categoriesMenuVC.view)
        
        categoriesMenuVC.view.translatesAutoresizingMaskIntoConstraints = false
        categoriesMenuVC.view.pinToAllEdges(of: contentView)
        categoriesMenuVC.view.layoutIfNeeded()
        
        categoriesMenuVC.category = category
        categoriesMenuVC.parentVC = parentVC
    }
}
