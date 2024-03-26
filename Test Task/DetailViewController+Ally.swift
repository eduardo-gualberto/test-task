//
//  DetailViewController+Ally.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 26/03/24.
//

import Foundation

extension DetailViewController {
    func setupAlly() {
        nameLabel.isAccessibilityElement = true
        if let name = nameLabel.text {
            nameLabel.accessibilityLabel = "Details of \(name)"
        }
    }
}
