//
//  MasterTableCell.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 22/03/24.
//

import Foundation
import UIKit

class MasterTableCell: UITableViewCell {
    static let identifier = "masterCell"
    
    @IBOutlet weak var dimmedLabel: UILabel!
    
    @IBOutlet weak var personNameLabel: UILabel!
    
    func setPersonName(_ name: String) {
        let prefix = "[Sample] "
        personNameLabel.text = name.deletingPrefix(prefix)
    }
    func setDimmed(_ dimmed: String) {
        let prefix = "[Sample] "
        dimmedLabel.text = dimmed.deletingPrefix(prefix)
    }
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
