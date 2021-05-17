//
//  MenuViewController.swift
//  iSocFit
//
//  Created by makintosh on 22.02.2021.
//

import UIKit
import SideMenu

class MenuViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let workoutsVC = storyboard?.instantiateViewController(identifier: "workoutsVC")
            navigationController?.pushViewController(workoutsVC!, animated: true)
        } else if indexPath.row == 1 {
            let loginVC = storyboard?.instantiateViewController(identifier: "loginVC")
            navigationController?.pushViewController(loginVC!, animated: true)
            
            
        } else if indexPath.row == 2 {
            let profileVC = storyboard?.instantiateViewController(identifier: "profileInfo")
            navigationController?.pushViewController(profileVC!, animated: true)
        }
        
        
    }
    
}
