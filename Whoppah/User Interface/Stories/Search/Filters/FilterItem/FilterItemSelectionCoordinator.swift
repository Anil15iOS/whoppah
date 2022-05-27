//
//  FilterItemSelectionCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 17/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

class FilterItemSelectionCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(filterItems: [FilterAttribute],
               selected: [FilterAttribute],
               selectionsAllowed: Int,
               title: String,
               isSearchable: Bool,
               completion: @escaping (([FilterAttribute]) -> Void)) {
        let vc: FilterItemSelectionViewController = UIStoryboard(storyboard: .search).instantiateViewController()
        vc.onSelectionCompleted = completion
        vc.viewModel = FilterItemSelectionViewModel(coordinator: self,
                                                    filterItems: filterItems,
                                                    selectedItems: selected,
                                                    selectionsAllowed: selectionsAllowed,
                                                    title: title,
                                                    isSearchable: isSearchable)
        navigationController.pushViewController(vc, animated: true)
    }

    func dismiss() {
        navigationController.popViewController(animated: true)
    }
}
