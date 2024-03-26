//
//  DetailTableCell+Ally.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 26/03/24.
//

import Foundation

extension DetailTableCell {
    func setupAlly() {
        guard let keyLabel = keyLabel, let valueLabel = valueLabel, let keyText = keyLabel.text, let valueText = valueLabel.text else { return }
        self.isAccessibilityElement = true
        accessibilityElements = [keyLabel, valueLabel]
        
        let keyAndValueLabel = "\(keyText), \(valueText)"
        self.accessibilityLabel = keyAndValueLabel
        
    }
}
