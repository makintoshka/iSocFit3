//
//  ProfileInfoTableViewController.swift
//  iSocFit
//
//  Created by makintosh on 20.02.2021.
//

import UIKit
import SideMenu

class ProfileInfoTableViewController: UITableViewController {
        
    @IBOutlet var userFullName: UILabel!
    @IBOutlet var userTag: UILabel!
    @IBOutlet var userPhoto: UIImageView!
    @IBOutlet var userNumber: UILabel!
    @IBOutlet var userEmail: UILabel!
    @IBOutlet var userAbout: UILabel!
    @IBOutlet var aboutControl: UISegmentedControl!
    
    override func loadView() {
        
        super.loadView()
        userPhoto.image = UIImage(named: "User image.jpg")
        
        self.navigationItem.setLeftBarButtonItems(nil, animated: true)
        self.navigationItem.setHidesBackButton(true, animated: false)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutControl.addTarget(self, action: #selector(openAbilityVC(sender:)), for: .valueChanged)
        
        let menuBarButton = UIBarButtonItem(image: UIImage(named: "list (1).png"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(openMenuAction(sender:)))
        
        menuBarButton.tintColor = UIColor(red: 138/255.0, green: 149/255.0, blue: 158/255.0, alpha: 1.0)
        self.navigationItem.leftBarButtonItem = menuBarButton
        
    }
    
    
    // MARK: - Actions
    
    @objc func openAbilityVC(sender: UISegmentedControl){
        

        aboutControl.selectedSegmentIndex = 0
        
    }
    
    @objc func openMenuAction(sender: UIBarButtonItem){
        
        //let loginVC = ViewController()
        let menuVC = storyboard?.instantiateViewController(identifier: "menuViewController")
        
        let leftMenuNavigationController = SideMenuNavigationController(rootViewController: menuVC!)
        leftMenuNavigationController.leftSide = false
        SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        //SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        present(leftMenuNavigationController, animated: true, completion: nil)
        
        //dismiss(animated: true, completion: nil)
        //let menuVC = storyboard?.instantiateViewController(identifier: "menuViewController")
        //self.navigationController?.pushViewController(menuVC!, animated: true)
        
    }

    // MARK: - Table view data source
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        
    }
    */
    /*override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }*/
    

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
