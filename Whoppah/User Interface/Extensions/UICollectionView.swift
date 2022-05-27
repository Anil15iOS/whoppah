//
//  UICollectionView.swift
//  Whoppah
//
//  Created by Eddie Long on 07/05/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import DifferenceKit
import SkeletonView
import UIKit
import WhoppahCore

extension UICollectionView {
    func addSkeleton() {
        SkeletonAppearance.default.gradient = SkeletonGradient(baseColor: UIColor(hexString: "#F3F4F6"))
        removeSkeleton()
        showAnimatedGradientSkeleton()
    }

    func removeSkeleton() {
        isUserInteractionEnabled = true
        hideSkeleton(reloadDataAfter: false)
    }
}

extension UICollectionView {
    func applyAction(_ action: ListAction, pager: PagedView? = nil, addSkeleton: Bool = true) {
        switch action {
        case .loadingInitial:
            if addSkeleton {
                if isSkeletonActive {
                    self.addSkeleton()
                } else {
                    self.addSkeleton()
                }
            }
        case .endRefresh:
            hideRefreshControls(pager)
        case .reloadAll:
            if addSkeleton {
                if isSkeletonActive {
                    hideSkeleton(reloadDataAfter: true, transition: .none)
                } else {
                    reloadSections(IndexSet(integer: 0))
                }
            } else {
                reloadSections(IndexSet(integer: 0))
            }

            hideRefreshControls(pager)
        case let .deleteRows(rows):
            performBatchUpdates({
                self.deleteItems(at: rows)
            }, completion: nil)
        case let .newRows(indexPaths, updater):
            if addSkeleton {
                removeSkeleton()
                // performBatchUpdates calls numberOfItems for the collection view
                // If the VM list has been updated then we get a crash
                // So we let the performBatchUpdate get the old could and then apply the new
                performBatchUpdates({
                    updater.apply()
                    self.insertItems(at: indexPaths)
                }, completion: { _ in
                    self.hideRefreshControls(pager)
                })
            } else {
                // performBatchUpdates calls numberOfItems for the collection view
                // If the VM list has been updated then we get a crash
                // So we let the performBatchUpdate get the old could and then apply the new
                performBatchUpdates({
                    updater.apply()
                    self.insertItems(at: indexPaths)
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

    func needsLoadsMore(presentation: ListPresentation, row: Int, totalItems: Int, numsColums _: Int) -> Bool {
        guard totalItems > 0 else { return false }

        let numCols = presentation == .list ? 1 : 2
        guard totalItems > numCols * 2 else { return false }
        // Fetch if 1.5 screens away
        let screenFraction = presentation == .list ? 2 : 1.5
        let totalRows = totalItems / numCols
        let currentRow = row / numCols
        let offsetForLoad = Double(numCols) * screenFraction
        return currentRow >= Int(Double(totalRows) - offsetForLoad)
    }
}

extension UICollectionView {
    func reloadDiff<C>(using stagedChangeset: StagedChangeset<C>,
                       setData: () -> Void,
                       completed: @escaping (Bool) -> Void) {
        performBatchUpdates({
            setData()

            for changeset in stagedChangeset {
                if !changeset.sectionDeleted.isEmpty {
                    deleteSections(IndexSet(changeset.sectionDeleted))
                }

                if !changeset.sectionInserted.isEmpty {
                    insertSections(IndexSet(changeset.sectionInserted))
                }

                if !changeset.sectionUpdated.isEmpty {
                    reloadSections(IndexSet(changeset.sectionUpdated))
                }

                for (source, target) in changeset.sectionMoved {
                    moveSection(source, toSection: target)
                }

                if !changeset.elementDeleted.isEmpty {
                    deleteItems(at: changeset.elementDeleted.map { IndexPath(item: $0.element, section: $0.section) })
                }

                if !changeset.elementInserted.isEmpty {
                    insertItems(at: changeset.elementInserted.map { IndexPath(item: $0.element, section: $0.section) })
                }

                if !changeset.elementUpdated.isEmpty {
                    reloadItems(at: changeset.elementUpdated.map { IndexPath(item: $0.element, section: $0.section) })
                }

                for (source, target) in changeset.elementMoved {
                    moveItem(at: IndexPath(item: source.element, section: source.section), to: IndexPath(item: target.element, section: target.section))
                }
            }
        }, completion: { result in
            completed(result)
        })
    }
}
