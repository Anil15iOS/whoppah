//
//  UITableView.swift
//  Whoppah
//
//  Created by Eddie Long on 27/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import SkeletonView
import WhoppahCore

extension UITableView {
    func applyAction(_ action: ListAction, pager: PagedView? = nil, addSkeleton: Bool = true) {
        switch action {
        case .loadingInitial:
            if addSkeleton {
                if isSkeletonActive {
                    hideSkeleton()
                }
                showAnimatedGradientSkeleton()
            }
        case .endRefresh:
            hideRefreshControls(pager)
        case .reloadAll:

            if addSkeleton {
                if isSkeletonActive {
                    hideSkeleton()
                } else {
                    reloadData()
                }
            } else {
                reloadData()
            }

            hideRefreshControls(pager)
        case let .deleteRows(rows):
            performBatchUpdates({
                self.deleteRows(at: rows, with: .automatic)
            }, completion: nil)
        case let .newRows(indexPaths, updater):
            if addSkeleton {
                hideSkeleton(reloadDataAfter: false)

                // performBatchUpdates calls numberOfItems for the collection view
                // If the VM list has been updated then we get a crash
                // So we let the performBatchUpdate get the old could and then apply the new
                performBatchUpdates({
                    updater.apply()
                    self.insertRows(at: indexPaths, with: .none)
                }, completion: { _ in
                    self.hideRefreshControls(pager)
                })
            } else {
                // performBatchUpdates calls numberOfItems for the collection view
                // If the VM list has been updated then we get a crash
                // So we let the performBatchUpdate get the old could and then apply the new
                performBatchUpdates({
                    updater.apply()
                    self.insertRows(at: indexPaths, with: .none)
                }, completion: { _ in
                    self.hideRefreshControls(pager)
                })
            }

        case .changePresentation:
            reloadData()
        default: break
        }
    }

    func hideRefreshControls(_ pager: PagedView?) {
        if let footer = footRefreshControl {
            if let pager = pager {
                if pager.hasMorePages() {
                    footer.endRefreshing()
                } else {
                    footer.endRefreshingAndNoLongerRefreshing(withAlertText: "")
                    footer.isHidden = true
                }
            } else {
                footer.endRefreshingAndNoLongerRefreshing(withAlertText: "")
                footer.isHidden = true
            }
        }
        if let header = headRefreshControl {
            header.endRefreshing()
        }
    }

    func showFooterRefreshControl() {
        if let control = footRefreshControl {
            control.isHidden = false
            control.beginRefreshing()
        }
    }

    func showHeaderRefreshControl() {
        if let control = headRefreshControl {
            control.isHidden = false
            control.beginRefreshing()
        }
    }

    func needsLoadsMore(presentation _: ListPresentation, row: Int, totalItems: Int, numsColums _: Int) -> Bool {
        guard totalItems > 0 else { return false }

        let numCols = 1
        guard totalItems > numCols * 2 else { return false }
        // Fetch if 1.5 screens away
        let screenFraction = 2.0
        let totalRows = totalItems / numCols
        let currentRow = row / numCols
        let offsetForLoad = Double(numCols) * screenFraction
        return currentRow >= Int(Double(totalRows) - offsetForLoad)
    }
}
