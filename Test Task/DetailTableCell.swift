//
//  DetailTableCell.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 23/03/24.
//

import UIKit

class DetailTableCell: UITableViewCell {
    static let identifier = "detailCell"
   
    @IBOutlet weak var keyLabel: CopyableLabel!
    
    @IBOutlet weak var valueLabel: CopyableLabel!
    
}
