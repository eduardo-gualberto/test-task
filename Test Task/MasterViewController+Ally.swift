//
//  MasterViewController+Ally.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 26/03/24.
//

import Foundation

extension MasterViewController {
    func setupAlly() {
        tableView.isAccessibilityElement = true
        tableView.accessibilityLabel = "Listing of all contacts"
    }
}
