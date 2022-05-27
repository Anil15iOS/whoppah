//
//  MySearchCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 2/18/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit
import WhoppahCore
import RxSwift
import WhoppahDataStore

class MySearchCell: UITableViewCell {
    static let nibName = "MySearchCell"
    static let identifier = "MySearchCell"

    private var bag = DisposeBag()
    // MARK: - IBOutlets

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var deleteButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with search: GraphQL.SavedSearchesQuery.Data.SavedSearch.Item, deleted: @escaping (() -> Void)) {
        bag = DisposeBag()
        nameLabel.text = search.title
        deleteButton.rx.tap.subscribe { _ in
            deleted()
        }.disposed(by: bag)
    }
}
