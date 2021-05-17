//
//  ExerciseInfoViewController.swift
//  iSocFit
//
//  Created by makintosh on 15.03.2021.
//

import UIKit

private let reuseIdentifier = "ExerciseInfoCell"
private let sectionInsets = UIEdgeInsets(
  top: 5.0,
  left: 5.0,
  bottom: 5.0,
  right: 5.0)

var paramsToUpdate: [String:String] = [:]

class ExerciseInfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UITextViewDelegate, ExerciseVariableCellDelegate {
    
    func didChangeValue(newValue: Any, forParameter: String, workoutId: String, exerciseId: String) {
        
        if forParameter == "Weight" {
            paramsToUpdate["weight"] = "\(newValue)"
        } else if forParameter == "Repeats"{
            paramsToUpdate["repeats"] = "\(newValue)"
        } else if forParameter == "Sets"{
            paramsToUpdate["sets"] = "\(newValue)"
        }
        
        print("________________iChangeValue__________________-")
        print(paramsToUpdate)
        print(newValue)
    }
    
    func didIncreaseValue(newValue: Any, forParameter: String, workoutId: String, exerciseId: String) {
        
        let tmpExercise = UserModel.workouts[workoutId]?.exercises[exerciseId]
        
        if forParameter == "Weight" {
            paramsToUpdate["weight"] = "\(newValue)"
        } else if forParameter == "Repeats"{
            paramsToUpdate["repeats"] = "\(newValue)"
        } else if forParameter == "Sets"{
            paramsToUpdate["sets"] = "\(newValue)"
        }
        
        print("________________iIncreaseValue__________________-")
        print(paramsToUpdate)
    }
    
    func didDecreaseValue(newValue: Any, forParameter: String, workoutId: String, exerciseId: String) {
        
        if forParameter == "Weight" {
            paramsToUpdate["weight"] = "\(newValue)"
        } else if forParameter == "Repeats"{
            paramsToUpdate["repeats"] = "\(newValue)"
        } else if forParameter == "Sets"{
            paramsToUpdate["sets"] = "\(newValue)"
        }
        
        print("________________iDecreaseValue__________________-")
        print(paramsToUpdate)
    }
    
    
    
    
    
    private var _currentExerciseId: String = ""
    public var currentExerciseId: String{
        get {
            return _currentExerciseId
        }
        set {
            _currentExerciseId = newValue
        }
    }
    
    private var _currentWorkoutId: String = ""
    public var currentWorkoutId: String{
        get {
            return _currentWorkoutId
        }
        set {
            _currentWorkoutId = newValue
        }
    }
    
    @IBOutlet var exerciseCollectionView: UICollectionView!
    @IBOutlet var exerciseName: UILabel!
    @IBOutlet var exerciseNotesTextVIew: UITextView!
    @IBOutlet var exerciseNotes: UILabel!
    @IBOutlet var exerciseNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavBar()
        configTextFields()
        configCollectionView()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.exerciseCollectionView.isEditing = editing
        
        exerciseName.isHidden = editing; exerciseNameField.isHidden = !editing
        exerciseNameField.text = exerciseName.text
        exerciseNotes.isHidden = editing; exerciseNotesTextVIew.isHidden = !editing
        exerciseNotesTextVIew.text = exerciseNotes.text
        
        self.exerciseCollectionView.isEditing = editing
        
        editButtonItem.image = UIImage(systemName: "square.and.pencil")
        
        if self.exerciseCollectionView.isEditing {
            editButtonItem.image = UIImage(systemName: "checkmark")
        } else {
            print("______________paramsToUpdate_2_______________")
            print(paramsToUpdate)
            
            update()
            
            
        }
        navigationItem.rightBarButtonItem = editButtonItem
        
        let indexPaths = exerciseCollectionView.indexPathsForVisibleItems
        
        for indexPath in indexPaths {
            
            if (indexPath.row <= 2){
                let variableCell = exerciseCollectionView.cellForItem(at: indexPath) as! ExerciseInfoVariableCell
                variableCell.isInEditingMode = editing
            } else {
                let cell = exerciseCollectionView.cellForItem(at: indexPath) as! ExerciseInfoCell
                cell.isInEditingMode = editing
            }
        }
        //self.exerciseCollectionView.reloadData()
        
    }
    
    //MARK: - Config
    
    func configCollectionView(){
        
        exerciseCollectionView.dataSource = self
        exerciseCollectionView.delegate = self
        exerciseCollectionView!.register(UINib(nibName: "ExerciseInfoCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        exerciseCollectionView!.register(UINib(nibName: "ExerciseInfoVariableCell", bundle: nil), forCellWithReuseIdentifier: "ExerciseInfoVariableCell")
        
    }
    
    func configTextFields(){
        
        exerciseName.text = UserModel.workouts[currentWorkoutId]?.exercises[currentExerciseId]?.name
        exerciseNotes.text = UserModel.workouts[currentWorkoutId]?.exercises[currentExerciseId]?.about
        
        exerciseNameField.isHidden = true
        exerciseNameField.delegate = self
        exerciseNotesTextVIew.delegate = self
        exerciseNotesTextVIew.isHidden = true
        
    }
    
    func configNavBar(){
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "Title Color"),
            NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 30)
        ]
        
        self.navigationItem.title = "\(currentExerciseId)"
        
        editButtonItem.image = UIImage(systemName: "square.and.pencil")
        self.navigationItem.rightBarButtonItem = editButtonItem
    }
    
    //MARK: - API
    
    func update(){
        
        let manager = ServerManager.sharedManager
        
        let exercise = UserModel.workouts["\(currentWorkoutId)"]?.exercises["\(currentExerciseId)"]
        
        let parameters: NSDictionary = [
            "weight": Double(paramsToUpdate["weight"]!),
            "sets": Int(paramsToUpdate["sets"]!),
            "name": self.exerciseName.text ?? "",
            "about": self.exerciseNotes.text ?? "",
            "repeats": Int(paramsToUpdate["repeats"]!)
        ]
        
        print("parameters____________________")
        print(parameters)
        
        manager.updateExercise(exerciseId: currentExerciseId,
                               workoutId: currentWorkoutId,
                               parameters: parameters) { resultDict, error in
            if (resultDict != nil){
                
                print("______________SomeResult________________")
                print(resultDict)
                
            } else if (error != nil){
                
                let errorAlert = UIAlertController(title: "Error", message: "There is \(error)", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
        
    }
    
    //MARK: - TextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        exerciseNameField.isHidden = !isEditing
        exerciseName.isHidden = isEditing
        exerciseName.text = exerciseNameField.text
        
        return true
    }
    
    //MARK: - TextViewDelegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        exerciseNotes.isHidden = isEditing; exerciseNotesTextVIew.isHidden = !isEditing
        exerciseNotes.text = exerciseNotesTextVIew.text
        
        return true
        
    }
    
    //MARK: - Data source
    
    private var dataToView: [(name: String, value: Any)] = []
    
    func prepareData(){
        
        let exercise = UserModel.workouts["\(currentWorkoutId)"]?.exercises["\(currentExerciseId)"]
        
        dataToView.append((name: "Weight", value: exercise!.weight as Double))
        dataToView.append((name: "Sets", value: exercise!.setsNumber as Int))
        dataToView.append((name: "Repeats", value: exercise!.repeatsNumber as Int))
        dataToView.append((name: "Category", value: exercise!.category as String))
        dataToView.append((name: "Calories", value: exercise!.calories as Int))
        dataToView.append((name: "Duration", value: exercise!.duration as Int))
        
        let tmpExercise = UserModel.workouts[currentWorkoutId]?.exercises[currentExerciseId]
        
        paramsToUpdate = [
            "weight":"\(tmpExercise?.weight)",
            "repeats":"\(tmpExercise?.repeatsNumber)",
            "sets":"\(tmpExercise?.setsNumber)"
        ]
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        dataToView = []
        prepareData()
        
        print("__________________dataToView___________-")
        print(dataToView)
        
        if (dataToView[indexPath.row].name == "Weight") || (dataToView[indexPath.row].name == "Sets") || (dataToView[indexPath.row].name == "Repeats"){
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseInfoVariableCell", for: indexPath) as! ExerciseInfoVariableCell
            
            cell.parameterName.text = dataToView[indexPath.row].name as? String
            cell.valueForParam.text = "\(dataToView[indexPath.row].value)"
            cell.unitsForParam.text = ""
            cell.currentWorkoutId = currentWorkoutId
            cell.currentExerciseId = currentExerciseId
            cell.delegate = self
            
            if (dataToView[indexPath.row].name == "Weight") {
                cell.unitsForParam.text = "kg"
                
            }
                
                print("_________________cell_____________")
                print(cell.parameterName.text)
                print(cell.value)
            
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ExerciseInfoCell
        
        cell.parameterName.text = dataToView[indexPath.row].name
        cell.valueForParam.text = "\(dataToView[indexPath.row].value)"
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 128.0, height: 128.0)
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
    

}
