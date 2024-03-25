//
//  EmptyView.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 25/03/24.
//

import UIKit

class EmptyView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        
    }
}
