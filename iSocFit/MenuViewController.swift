//
//  MenuViewController.swift
//  iSocFit
//
//  Created by makintosh on 22.02.2021.
//

import UIKit
import SideMenu

class MenuViewController: UITableViewController {
    
    @IBAction func openWorkouts(){
        
        let workoutsVC = WorkoutsViewController()
        navigationController?.pushViewController(workoutsVC, animated: true)
        
    }
    
    @IBAction func openProfile(){
        
        let profileVC = ProfileInfoTableViewController()
        navigationController?.pushViewController(profileVC, animated: true)
        
    }
    
    @IBAction func logout(){
        
        let loginvc = ViewController()
        //let menuVC = UINavigationController(rootViewController: loginvc)
        //menuVC.popToRootViewController(animated: true)
    
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    override func loadView() {
        super.loadView()
        
        //let menuVc = MenuViewController()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
