//
//  DetailTableCell+Ally.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 26/03/24.
//

import Foundation

extension DetailTableCell {
    func setupAlly() {
        guard let keyLabel = keyLabel, let valueLabel = valueLabel, let value = valueLabel.text else { return }
        self.isAccessibilityElement = true
        
        var allyKey = self.detailKey.rawValue
        
        switch self.detailKey {
        case .orgName, .ownerName:
            allyKey = "name"
        case .orgEmail, .contactEmail, .ownerEmail:
            allyKey = "email"
            
        case .last:
            allyKey = "last activity done on"
        case .people:
            allyKey = "head count"
        default:
            allyKey = self.detailKey.rawValue
        }
                
        accessibilityElements = [keyLabel, valueLabel]
        
        let keyAndValueLabel = "\(allyKey): \(value)"
        self.accessibilityLabel = keyAndValueLabel
    }
}
