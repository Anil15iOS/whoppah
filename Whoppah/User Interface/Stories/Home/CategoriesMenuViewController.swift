//
//  LeftMenuViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 11/14/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore

class CategoriesMenuViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var tableView: UITableView!

    // MARK: - Properties
 
    weak var parentVC: ParentCategoriesMenuViewController!

    var category: CategoryStateAndHierarchy? {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        //tableView.reloadData()
//    }

    // MARK: - Private

    private func setUpTableView() {
        tableView.register(UINib(nibName: ExpandableCategoryMenuCell.identifier, bundle: nil), forCellReuseIdentifier: ExpandableCategoryMenuCell.identifier)
        tableView.register(UINib(nibName: CategoryMenuCell.identifier, bundle: nil), forCellReuseIdentifier: CategoryMenuCell.identifier)
    }
}

// MARK: - ExpandableDelegate

extension CategoriesMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let category = category else { return 0 }
        if category.isExpanded {
            return category.childCategories.count + 1 // Add an extra row for category (eg Furniture)
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { // eg Furniture case
            return 1
        }
        
        var numberOfRows = 1 // Add an extra row for category (eg Sofa)

        guard let category = category else { return 0 }
        if category.childCategories[section - 1].isExpanded {
            numberOfRows += category.childCategories[section - 1].childCategories.count
        }
        
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let category = category else { return UITableViewCell() }
        
        if indexPath.section == 0 { // Furniture
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpandableCategoryMenuCell.identifier) as! ExpandableCategoryMenuCell
        
            cell.configure(with: category.category, isExpanded: category.isExpanded)
            return cell
        }
        
        let child = category.childCategories[indexPath.section - 1]
        let lastLevelChilds = category.childCategories[indexPath.section - 1].childCategories
       
        if indexPath.row == 0 { // Sofas, Baby and children (subcategories)
           
            if !lastLevelChilds.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: ExpandableCategoryMenuCell.identifier) as! ExpandableCategoryMenuCell
                cell.configure(with: child.category,
                               isExpanded: child.isExpanded)
                return cell
            }
            
            if lastLevelChilds.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: CategoryMenuCell.identifier) as! CategoryMenuCell
                cell.configure(with: child.category)
                
                return cell
            }
        }
        
        // 3-seat
        // indexPath.row >= 1
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryMenuCell.identifier) as! CategoryMenuCell
        cell.configure(with: lastLevelChilds[indexPath.row - 1].category)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let category = category else { return } // Furniture
        
        if indexPath.section == 0 { // Furniture
            category.isExpanded = !category.isExpanded
            tableView.reloadData()
            parentVC.tableView?.reloadData()
            return
        }
        
        if indexPath.row == 0 { // Sofas, Baby and children (subcategories)
            
            let childs = category.childCategories[indexPath.section - 1].childCategories
            if childs.isEmpty {
                let cat = category.childCategories[indexPath.section - 1].category
                parentVC.delegate?.parentCategoriesMenuViewController(parentVC, didSelectCategory: cat!, andProduct: cat)
            }
            
            category.childCategories[indexPath.section - 1].isExpanded = !category.childCategories[indexPath.section - 1].isExpanded
            tableView.reloadData()
            parentVC.tableView?.reloadData()
            return
        }
        
        // 3-seat
        // indexPath.row >= 1
        
        let lastLevelCategories = category.childCategories[indexPath.section - 1].childCategories
        let cat = lastLevelCategories[indexPath.row - 1].category
   
        parentVC.delegate?.parentCategoriesMenuViewController(parentVC, didSelectCategory: cat!, andProduct: cat)
    }
}
