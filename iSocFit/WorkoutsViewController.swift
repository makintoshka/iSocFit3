//
//  WorkoutsViewController.swift
//  iSocFit
//
//  Created by makintosh on 28.02.2021.
//

import UIKit
import SideMenu

class WorkoutsViewController: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWorkouts()
        
        self.navigationItem.title = "Workouts"
        
        //self.navigationItem.rightBarButtonItem = editButtonItem
        
//        let editBarButton = UIBarButtonItem(barButtonSystemItem: .edit,
//                                            target: self,
//                                            action: #selector(editingAction(sender:)))
        
        let menuBarButton = UIBarButtonItem(image: UIImage(named: "list (1).png"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(openMenuAction(sender:)))
        
        menuBarButton.tintColor = UIColor(red: 138/255.0, green: 149/255.0, blue: 158/255.0, alpha: 1.0)
        self.navigationItem.leftBarButtonItem = menuBarButton
        //self.navigationItem.rightBarButtonItem = editButtonItem
        
        self.tableView.register(UINib(nibName: "WorkoutsCustomCell", bundle: nil), forCellReuseIdentifier: "workoutCell")
        
        let addMenuBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addWorkoutAction))
        
        editButtonItem.image = UIImage(systemName: "square.and.pencil")
        
        self.navigationItem.rightBarButtonItems = [editButtonItem, addMenuBarButton]
    }

    //MARK: - API
    
    func getWorkouts(){
        
        let manager = ServerManager.sharedManager
        
        manager.getWorkouts { (workouts, error) in
            if (workouts != nil){
                print("________________________")
                print(workouts)
                
                
                var tmp: [String:WorkoutModel] = [:]
                
                for workout in workouts! {
                    
                    let currentWorkout = workout as! NSDictionary
                    let name = currentWorkout.object(forKey: "name") as! String
                    let id = currentWorkout.object(forKey: "workoutId") as! String
                    let about = currentWorkout.object(forKey: "about") as! String
                    let created = currentWorkout.object(forKey: "createdAt") as! String
                    
                    let tmpWorkout = WorkoutModel(id: id, about: about, created: created, name: name)
                    
                    tmp[id] = tmpWorkout
                    
                }
                
                print("________________________")
                print(tmp)
                UserModel.workouts = tmp
                tmp = [:]
                self.tableView.reloadData()
                
                
                
            } else if (error != nil){
                
                let errorAlert = UIAlertController(title: "Error", message: "There is \(error)", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    
    // MARK: - Actions
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        self.tableView.setEditing(editing, animated: true)
        
        editButtonItem.image = UIImage(systemName: "square.and.pencil")
        
        if self.tableView.isEditing {
            editButtonItem.image = UIImage(systemName: "checkmark")
        }
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        let indexPaths = tableView.indexPathsForVisibleRows
        
        for indexPath in indexPaths! {
            let cell = tableView.cellForRow(at: indexPath) as! WorkoutsCustomCell
            cell.isInEditingMode = editing
        }
    }
    
    @objc func openMenuAction(sender: UIBarButtonItem){
        
        let menuVC = storyboard?.instantiateViewController(identifier: "menuViewController")
        
        let leftMenuNavigationController = SideMenuNavigationController(rootViewController: menuVC!)
        leftMenuNavigationController.leftSide = false
        SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        //SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        present(leftMenuNavigationController, animated: true, completion: nil)
        
    }
    
    @objc func addWorkoutAction(){
        
        
        let addWorkoutVC = storyboard?.instantiateViewController(identifier: "addWorkoutVC")
        self.navigationController?.pushViewController(addWorkoutVC!, animated: true)
        
        
        
    }
    
    // MARK: - Table view data source

    private var dataToView: [WorkoutModel] = []
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        dataToView = []
        
        for workout in UserModel.workouts.values {
            print("ASDASDASDASDA")
            print(workout)
            dataToView.append(workout)
        }
        return dataToView.count
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as! WorkoutsCustomCell

        cell.workoutDateForCell.text = dataToView[indexPath.row].createdAt
        cell.workoutNotesLabel.text = dataToView[indexPath.row].about
        cell.workoutTitle.text = dataToView[indexPath.row].name
        
        //print("____________________________")
        //print(dataToView[indexPath.row])
        

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let exerciseVC = storyboard?.instantiateViewController(identifier: "trainingVC") as! TrainingViewController
        exerciseVC.workoutId = dataToView[indexPath.row].id
        navigationController?.pushViewController(exerciseVC, animated: true)
        
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
