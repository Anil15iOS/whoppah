//
//  ChatCellProperties.swift
//  Whoppah
//
//  Created by Eddie Long on 25/02/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation

class ChatCellProperty<Key, Value> where Key: Hashable {
    // Whether the dialog is present for the 'ask pay' payload
    private var values = [Key: Value]()
    private let defaultValue: Value
    init(defaultValue: Value) {
        self.defaultValue = defaultValue
    }

    func setValue(forKey key: Key, value: Value) {
        values[key] = value
    }

    func getValue(forKey key: Key) -> Value {
        guard let vis = values[key] else {
            values[key] = defaultValue
            return defaultValue
        }
        return vis
    }

    func clear() {
        values.removeAll()
    }
}

var orderIncompleteDialogExpanded = ChatCellProperty<UUID, Bool>(defaultValue: false)
var outgoingBidDialogExpanded = ChatCellProperty<UUID, Bool>(defaultValue: false)
var orderDialogExpanded = ChatCellProperty<UUID, Bool>(defaultValue: false)
var receiveDialogVisibility = ChatCellProperty<UUID, Bool>(defaultValue: true)

func clearChatCellProperties() {
    orderIncompleteDialogExpanded.clear()
    outgoingBidDialogExpanded.clear()
    orderDialogExpanded.clear()
    receiveDialogVisibility.clear()
}
