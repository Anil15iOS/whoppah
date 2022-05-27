//
//  ListAction.swift
//  Whoppah
//
//  Created by Eddie Long on 25/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

enum ListPresentation: String {
    case grid
    case list
}

protocol ListUpdater {
    func apply()
}

enum ListAction {
    case initial
    case loadingInitial
    // When updating a collectionview we cannot have the ViewModel return the total number of new rows
    // Until the batchUpdates have begun. So when updating the list we need to only apply the new rows
    // At a particular point. The `ListUpdater` object is has apply() called within the batchedUpdates call
    case newRows(rows: [IndexPath], updater: ListUpdater)
    case reloadRows(rows: [IndexPath])
    case deleteRows(rows: [IndexPath])
    case reloadAll
    case changePresentation(style: ListPresentation)
    case endRefresh // Similar to noNewData but may be that something cancelled the refresh - just hide any refresh controls
}
