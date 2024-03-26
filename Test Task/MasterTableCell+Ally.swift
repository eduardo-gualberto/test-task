//
//  MasterTableCell+Ally.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 26/03/24.
//

import Foundation

extension MasterTableCell {
    func setupAlly() {
        guard let name = personNameLabel.text, let employer = dimmedLabel.text else { return }
        
        self.isAccessibilityElement = true
        
        self.accessibilityElements = [personNameLabel, dimmedLabel]
        let personAndEmployerLabel = "\(name) from \(employer)"
        
        self.accessibilityLabel = personAndEmployerLabel
        self.accessibilityHint = "Click to open details"
    }
}
