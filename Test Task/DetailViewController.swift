//
//  DetailViewController.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 22/03/24.
//

import UIKit

class DetailViewController: UIViewController, Storyboarded {
    var viewModel: DetailViewModelProtocol!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = viewModel.person.name.deletingPrefix("[Sample] ")
        setupTableView()
        self.setupAlly()
    }

}


//MARK: UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getTableViewSectionsCount()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.getTableViewSection(for: section).name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTableViewSection(for: section).items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableCell.identifier, for: indexPath) as! DetailTableCell
        
        let section = viewModel.getTableViewSection(for: indexPath.section)
        let item = section.items[indexPath.row]
        
        cell.selectionStyle = .none
        cell.keyLabel.text = item.keys.first
        cell.valueLabel.text = item.values.first
        
        setLabelColorFor(cell)
        
        cell.setupAlly()
        
        return cell
    }
}

//MARK: Utilities
extension DetailViewController {
    private func setLabelColorFor(_ cell: DetailTableCell) {
        guard let textValue = cell.valueLabel.text, let key = cell.keyLabel.text else { return }
        let intValue = Int(textValue) ?? 0
        
        
        
        if intValue == 0 { return }
        if intValue > 0 {
            switch key {
            case "done": fallthrough
            case "won":
                cell.valueLabel.textColor = .systemGreen
            case "undone": fallthrough
            case "lost":
                cell.valueLabel.textColor = .systemRed
            default:
                return
            }
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        tableView.sectionHeaderHeight = 30
    }
}
