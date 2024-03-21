//
//  MasterTableCell.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 22/03/24.
//

import Foundation
import UIKit

class MasterTableCell: UITableViewCell {
    
    @IBOutlet weak var dimmedLabel: UILabel!
    
    @IBOutlet weak var personNameLabel: UILabel!
        
    @IBOutlet weak var wonDealsLabel: UILabel!
    
    @IBOutlet weak var lostDealsLabel: UILabel!

    
    func setPersonName(_ name: String) {
        let prefix = "[Sample] "
        personNameLabel.text = name.deletingPrefix(prefix)
    }
    func setDimmed(_ dimmed: String) {
        let prefix = "[Sample] "
        dimmedLabel.text = dimmed.deletingPrefix(prefix)
    }
    func setWonDeals(_ won: Int) {
        wonDealsLabel.text = "\(won)"
    }
    func setLostDeals(_ lost: Int) {
        lostDealsLabel.text = "\(lost)"
    }
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
