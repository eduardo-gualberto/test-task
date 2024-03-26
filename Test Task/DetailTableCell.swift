//
//  DetailTableCell.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 23/03/24.
//

import UIKit

class DetailTableCell: UITableViewCell {
    static let identifier = "detailCell"
   
    var detailKey: DetailTableKeys!
    
    @IBOutlet weak var keyLabel: CopyableLabel!
    
    @IBOutlet weak var valueLabel: CopyableLabel!
    
    func setDetailKey(_ key: DetailTableKeys) {
        self.detailKey = key
        switch key {
        case .contactEmail, .orgEmail, .ownerEmail:
            keyLabel.text = "email"
        case .orgName, .ownerName:
            keyLabel.text = "name"
        default:
            keyLabel.text = key.rawValue
        }
    }
    
}
