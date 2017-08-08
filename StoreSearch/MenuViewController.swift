//
//  MenuViewController.swift
//  StoreSearch
//
//  Created by Travis Cunningham on 8/7/17.
//  Copyright © 2017 Travis Cunningham. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
    func menuViewControllerSendSupportEmail(_ controller:
        MenuViewController)
}

class MenuViewController: UITableViewController {
    weak var delegate: MenuViewControllerDelegate?
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            delegate?.menuViewControllerSendSupportEmail(self)
        }
    }
}
