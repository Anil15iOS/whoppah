//
//  ParentCategoriesMenuViewController.swift
//  Whoppah
//
//  Created by macbook on 1/23/21.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore

protocol ParentCategoriesMenuViewControllerDelegate: AnyObject {
    func parentCategoriesMenuViewController(_ viewController: ParentCategoriesMenuViewController, didSelectCategory category: WhoppahCore.Category, andProduct product: WhoppahCore.Category?)
}

class CategoryStateAndHierarchy {
    var category: WhoppahCore.Category!
    var isExpanded: Bool = false
  
    var childCategories: [CategoryStateAndHierarchy] = []
}

class ParentCategoriesMenuViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties

    var categories: [CategoryStateAndHierarchy] = []
  
    var repo: CategoryRepository? {
        didSet {
            loadCategories()
        }
    }
    
    weak var delegate: ParentCategoriesMenuViewControllerDelegate?
    private let bag = DisposeBag()
    
    // MARK: - ViewController's Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    // MARK: - Private

    private func setUpTableView() {
       
        tableView.register(UINib(nibName: ExpandableCategoryMenuCell.identifier, bundle: nil), forCellReuseIdentifier: ExpandableCategoryMenuCell.identifier)
        tableView.register(UINib(nibName: ExpandableTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ExpandableTableViewCell.identifier)
    }
 
    private func loadCategories() {
        guard let repo = repo, isViewLoaded else { return }
   
        repo.categories.drive(onNext: { [weak self] result in
            guard let self = self else { return }
            self.categories = []
            
            switch result {
            case let .success(data):
                guard let categories = data?.categories.items.map({ $0 as WhoppahCore.Category }) else { return }
                
                //
                for category in categories {
                    let cat = CategoryStateAndHierarchy()
                    cat.category = category
                    cat.isExpanded = false
                    
                    for subcategory in category.children {
                        let subcat = CategoryStateAndHierarchy()
                        subcat.category = subcategory
                        subcat.isExpanded = false
                        cat.childCategories.append(subcat)
                        
                        for lastLevelCategory in subcategory.children {
                            let lastLevelCat = CategoryStateAndHierarchy()
                            lastLevelCat.category = lastLevelCategory
                            lastLevelCat.isExpanded = false
                            subcat.childCategories.append(lastLevelCat)
                        }
                    }
                    
                    self.categories.append(cat)
                }
                
                self.tableView.reloadData()
            case let .failure(error):
                self.showError(error)
            }
        }).disposed(by: bag)
    }
}

// MARK: - ExpandableDelegate

extension ParentCategoriesMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var numberOfCells = 1 // For header category, eg furniture
       
        if categories[indexPath.row].isExpanded {
            
            numberOfCells += categories[indexPath.row].childCategories.count
            
            for child in categories[indexPath.row].childCategories where child.isExpanded {
                numberOfCells += child.childCategories.count
            }
   
            return CGFloat(numberOfCells) * 56.0
        }
        
        return 56.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ExpandableTableViewCell.identifier) as! ExpandableTableViewCell
        
        let category = categories[indexPath.row]
        cell.parentVC = self
        cell.configure(with: category)
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
