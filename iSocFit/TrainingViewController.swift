//
//  TrainingViewController.swift
//  iSocFit
//
//  Created by makintosh on 01.03.2021.
//

import UIKit
import Rideau
import SideMenu

struct Exercise: Encodable {
    let repeatsNumber: Int
    var repeatsNumberString: String? {
        return "\(repeatsNumber)"
    }
    let setsNumber: Int
    var setsNumberString: String? {
        return "\(setsNumber)"
    }
    let duration: Int
    let name: String
    let about: String
    let calories: Int
    let weight: Double
    var weightString: String? {
        return "\(weight)"
    }
    let category: String
    let id: String
    let order: Int
    
    static func generateAvailableExercises() -> [Exercise]{
        
        var tmp: [Exercise] = []
        
        for i in 0...50 {
            let exercise = Exercise(repeatsNumber: i, setsNumber: i, duration: i, name: "exercise", about: "about", calories: i, weight: Double(i), category: "category \(i)", id: "0", order: 0)
            
            tmp.append(exercise)
        }
        
        return tmp
        
    }
    
}

private let sectionInsets = UIEdgeInsets(
    top: 0.0,
    left: 0.0,
    bottom: 0.0,
    right: 0.0)

private let reuseIdentifier = "Cell"

class TrainingViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, DeleteExerciseCustomCellDelegate {
    
    private var _currentWorkoutId: String = ""
    
    
    public var currentWorkoutId: String{
        get {
            return _currentWorkoutId
        }
        set {
            _currentWorkoutId = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getExercises()
        
        configNavBar()
        configCollectionView()
        
        guard let navigationController = self.navigationController else { return }
        var navigationArray = navigationController.viewControllers
        print("___________________vc____________________")
        print(navigationArray[navigationArray.count - 1])
        print(navigationArray[navigationArray.count - 2])
        if (navigationArray[navigationArray.count - 2] is AddWorkoutViewController){
            navigationArray.remove(at: navigationArray.count - 2)
        }
        self.navigationController?.viewControllers = navigationArray
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.collectionView.reloadData()
        self.collectionView.setNeedsDisplay()
    }
    
    func reload(){
        
        self.collectionView.reloadData()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        self.collectionView.isEditing = editing
        
        editButtonItem.image = UIImage(systemName: "square.and.pencil")
        
        if self.collectionView.isEditing {
            editButtonItem.image = UIImage(systemName: "checkmark")
        } else{
            getExercises()
            let indexPaths = self.collectionView.indexPathsForVisibleItems
            for indePath in indexPaths {
                let cell = self.collectionView.cellForItem(at: indePath) as! TrainingCustomCell
                cell.backgroundColor = .white
            }
            self.collectionView.reloadData()
            
        }
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        
        let indexPaths = collectionView.indexPathsForVisibleItems
        
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath) as! TrainingCustomCell
            
            cell.isInEditingMode = editing
        }
        
    }
    
    //MARK: - Config
    
    func configCollectionView(){
        
        
        self.collectionView!.register(UINib(nibName: "TrainingCustomCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    
    func configNavBar(){
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "Title Color"),
            NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 25)
        ]
        
        self.navigationItem.title = "Training constructor"
        
        editButtonItem.image = UIImage(systemName: "square.and.pencil")
        
        let addExerciseBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addExerciseAction))
        
        self.navigationItem.rightBarButtonItems = [editButtonItem, addExerciseBarButton]
        
    }
    
    //MARK: - API
    
    func deleteExercise(workoutId: String, exerciseId: String, atIndexPath: IndexPath) {
        let manager = ServerManager.sharedManager
        
        manager.deleteExercise(exerciseId: exerciseId, workoutId: workoutId) { resultDict, error in
            if (resultDict != error){
                
                //var workout = UserModel.workouts[self.currentWorkoutId]?.exercises
                //workout?.removeValue(forKey: exerciseId)
                //self.collectionView.deleteItems(at: [atIndexPath])
                //self.collectionView.reloadData()
                //self.reload()
            }
        }
    }
    
    func getExercises(){
        
        let manager = ServerManager.sharedManager
        
        manager.getWorkoutExercises(id: currentWorkoutId) { exercises, error in
            if (exercises != nil){
                
                
                print("_____________________________exercises_______________________")
                print(exercises)
                
                var tmp: [String:Exercise] = [:]
                
                for exercise in exercises! {
                    
                    let currentExercise = exercise as! NSDictionary
                
                    let repeats = currentExercise.object(forKey: "repeats") as! Int
                    let sets = currentExercise.object(forKey: "sets") as! Int
                    let duration = currentExercise.object(forKey: "duration") as! Int
                    let name = currentExercise.object(forKey: "name") as! String
                    let about = currentExercise.object(forKey: "about") as! String
                    let calories = currentExercise.object(forKey: "calories") as! Int
                    let weight = currentExercise.object(forKey: "weight") as! Double
                    let category = currentExercise.object(forKey: "category") as? String
                    let id = currentExercise.object(forKey: "workoutExcerciseId") as! String
                    let order = currentExercise.object(forKey: "order") as! Int
                    
                    let created = currentExercise.object(forKey: "createdAt") as? String
                    
                    let tmpExercise = Exercise(repeatsNumber: repeats ?? 0, setsNumber: sets ?? 0, duration: duration ?? 0, name: name, about: about, calories: calories ?? 0, weight: weight ?? 0, category: category ?? "", id: id, order: order)
                    
                    tmp[id] = tmpExercise
                    
                }
                
                
                UserModel.workouts[self.currentWorkoutId]?.exercises = tmp
                print(tmp)
                tmp = [:]
                print("_____________________________________")
                print(UserModel.workouts[self.currentWorkoutId]?.exercises)
                self.collectionView.reloadData()
                
            } else if (error != nil){
                
                let errorAlert = UIAlertController(title: "Error", message: "There is \(String(describing: error))", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
            
        }
        
    }
    
    // MARK: - Actions
    
    @objc func addExerciseAction(){
        
        let exerciseListVC = (storyboard?.instantiateViewController(identifier: "exerciseListVC")) as! ListVC
        
        exerciseListVC.currentWorkoutId = currentWorkoutId
        
        exerciseListVC.modalPresentationStyle = .custom
        
        let rideuController = RideauViewController(
            bodyViewController: exerciseListVC,
            configuration: {
                var config = RideauView.Configuration()
                config.snapPoints = [.pointsFromBottom(200), .fraction(0.5), .fraction(0.8), .fraction(1)]
                return config
        }(),
            initialSnapPoint: .pointsFromBottom(200),
            resizingOption: .noResize)
        
        
        present(rideuController, animated: true) {
           
        }
        
        
        
        
    }
    
    func refresh(){
        self.getExercises()
        self.collectionView.reloadData()
        
    }
    
    // MARK: UICollectionViewDataSource

    private var dataToView: [Exercise] = []
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        dataToView = []
        
        for exercise in UserModel.workouts[currentWorkoutId]!.exercises.values {
            
            dataToView.append(exercise)
        }
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataToView.count
    }

    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)  as! TrainingCustomCell
        
        cell.deleteButton.isHidden = true
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.topLine.isHidden = true
                cell.bottomLine.isHidden = true
                cell.leftLine.isHidden = true
            } else if indexPath.row == 1 || indexPath.row == 2 {
                cell.topLine.isHidden = true
                cell.bottomLine.isHidden = true
            } else if indexPath.row == 3 {
                cell.rightLine.isHidden = true
                cell.topLine.isHidden = true
            }
        }
        
        if (indexPath.section % 2 == 0) && (indexPath.section != 0){
            if indexPath.row % 4 == 0 {
                cell.leftLine.isHidden = true
                cell.topLine.isHidden = true
                cell.bottomLine.isHidden = true
            } else if indexPath.row % 4 == 3 {
                cell.rightLine.isHidden = true
                cell.topLine.isHidden = true
            } else if (indexPath.row % 4 == 1) || (indexPath.row % 4 == 2){
                cell.topLine.isHidden = true
                cell.bottomLine.isHidden = true
            }
        } else if (indexPath.section % 2 != 0) {
            if indexPath.row % 4 == 0 {
                cell.leftLine.isHidden = true
                cell.topLine.isHidden = true
            } else if indexPath.row % 4 == 3 {
                cell.rightLine.isHidden = true
                cell.bottomLine.isHidden = true
            } else {
                cell.topLine.isHidden = true
                cell.bottomLine.isHidden = true
            }
            
        }
        
        cell.exerciseTitle.text = dataToView[indexPath.row].name
        cell.exerciseRepeatsValue.text = "\(dataToView[indexPath.row].repeatsNumber)"
        cell.exerciseSetsValue.text = "\(dataToView[indexPath.row].setsNumber)"
        cell.currentWorkoutId = currentWorkoutId
        cell.currentExerciseId = dataToView[indexPath.row].id
        cell.cellNumber = indexPath
        
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (view.frame.width - sectionInsets.left * 8)/4
        
        return CGSize(width: collectionView.frame.width/4, height: collectionView.frame.width/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if !self.collectionView.isEditing {
            
            let exerciseInfoVC = storyboard?.instantiateViewController(identifier: "exerciseInfoVC") as! ExerciseInfoViewController
            
            exerciseInfoVC.currentExerciseId = dataToView[indexPath.row].id
            exerciseInfoVC.currentWorkoutId = currentWorkoutId
            
            navigationController?.pushViewController(exerciseInfoVC, animated: true)
        }
        
        
    }
    
}

