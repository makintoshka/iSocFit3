//
//  WorkoutsViewController.swift
//  iSocFit
//
//  Created by makintosh on 28.02.2021.
//

import UIKit
import SideMenu

class WorkoutsViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWorkouts()
        configNavBar()
        configTableView()
    
    }

    //MARK: - Config
    
    func configTableView(){
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl!.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        
        
        //self.navigationItem.rightBarButtonItem = editButtonItem
        
        self.tableView.register(UINib(nibName: "WorkoutsCustomCell", bundle: nil), forCellReuseIdentifier: "workoutCell")
        
       
        
        self.tableView.allowsSelectionDuringEditing = true
        
    }
    
    func configNavBar(){
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "Title Color"),
            NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 25)
        ]
        
        self.navigationItem.title = "Workouts"
        
        let menuBarButton = UIBarButtonItem(image: UIImage(named: "list (1).png"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(openMenuAction(sender:)))
        
        menuBarButton.tintColor = UIColor(red: 138/255.0, green: 149/255.0, blue: 158/255.0, alpha: 1.0)
        self.navigationItem.leftBarButtonItem = menuBarButton
        
        let addMenuBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addWorkoutAction))
        
        editButtonItem.image = UIImage(systemName: "square.and.pencil")
        
        self.navigationItem.rightBarButtonItems = [editButtonItem, addMenuBarButton]
        
    }
    
    //MARK: - API
    
    func getWorkouts(){
        
        let manager = ServerManager.sharedManager
        
        manager.getWorkouts { (workouts, error) in
            if (workouts != nil){
                
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
                
                let user = UserModel.currentUser
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
    
    @objc func refresh(_ sender: AnyObject) {
       
        getWorkouts()
        
        tableView.reloadData()
        
        DispatchQueue.main.async {
              self.refreshControl?.endRefreshing()
           }
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        self.tableView.setEditing(editing, animated: true)
        
        editButtonItem.image = UIImage(systemName: "square.and.pencil")
        
        if self.tableView.isEditing {
            editButtonItem.image = UIImage(systemName: "checkmark")
        } else{
            self.refresh(self)
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
        
        present(leftMenuNavigationController, animated: true, completion: nil)
        
    }
    
    @objc func addWorkoutAction(){
        
        
        let addWorkoutVC = storyboard?.instantiateViewController(identifier: "addWorkoutVC")
        self.navigationController?.pushViewController(addWorkoutVC!, animated: true)
        
        
        
    }
    
    // MARK: - Table view data source

    private var dataToView: [WorkoutModel] = []
    
    func prepareData(){
        
        
        
        self.dataToView = []
        
        for workout in UserModel.workouts.values {
            
            self.dataToView.append(workout)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        prepareData()
        
        return dataToView.count
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as! WorkoutsCustomCell
        
        dataToView.sort { (a, b) -> Bool in
            return a.createdAt > b.createdAt
        }

        cell.workoutDateForCell.text = dataToView[indexPath.row].createdAt
        cell.workoutNotesLabel.text = dataToView[indexPath.row].about
        cell.workoutTitle.text = dataToView[indexPath.row].name
    
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isEditing {
            let editWorkoutVC = (storyboard?.instantiateViewController(identifier: "addWorkoutVC"))! as AddWorkoutViewController
            editWorkoutVC.workoutId = dataToView[indexPath.row].id
            navigationController?.pushViewController(editWorkoutVC, animated: true)
            
        } else {
            
            let exerciseVC = storyboard?.instantiateViewController(identifier: "trainingVC") as! TrainingViewController
            exerciseVC.currentWorkoutId = dataToView[indexPath.row].id
            navigationController?.pushViewController(exerciseVC, animated: true)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            let manager = ServerManager.sharedManager
            
            manager.deleteWorkout(workoutId: dataToView[indexPath.row].id) { resultDict, error in
                if (resultDict != nil) {
                    
                    self.dataToView.remove(at: indexPath.row)
                    
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    
                    self.refresh(self)
                    
                } else if (error != nil){
                    
                    let errorAlert = UIAlertController(title: "Error", message: "There is \(error)", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }
    
            }
            
        self.refresh(self)
        
    }
    
}
