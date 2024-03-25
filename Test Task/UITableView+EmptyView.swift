//
//  UITableView+EmptyView.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 25/03/24.
//

import UIKit

extension UITableView {
    
    func setEmptyView(title: String, message: String) {
        guard let allXibViews = Bundle.main.loadNibNamed("EmptyView", owner: self) else { return }
        
        let emptyView = allXibViews.first as! EmptyView
        emptyView.titleLabel.text = title
        emptyView.messageLabel.text = message
        
        let width = 100
        let height = 100
        emptyView.frame = CGRect(x: Int(self.center.x) - width/2, y: Int(self.center.y) - height/2, width: width, height: height)
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
