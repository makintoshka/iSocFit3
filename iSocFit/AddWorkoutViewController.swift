//
//  AddWorkoutViewController.swift
//  iSocFit
//
//  Created by makintosh on 05.05.2021.
//

import UIKit

class AddWorkoutViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var aboutTextView: UITextView!
    @IBOutlet private weak var categoryPicker: UIPickerView!
    
    let categoryPickerDelegate = CategoryPickerDelegate()
    
    private var _workoutId: String = ""
    
    
    public var workoutId: String{
        get {
            return _workoutId
        }
        set {
            _workoutId = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavBarAndFields()
        
    }
    
    //MARK: - Config
    
    func configNavBarAndFields(){
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "Title Color"),
            NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 25)
        ]
        
        nameTextField.delegate = self
        aboutTextView.delegate = self
        
        categoryPicker.delegate = categoryPickerDelegate
        categoryPicker.dataSource = categoryPickerDelegate
        
        if (workoutId != "") {
            
            self.navigationItem.title = "Change workout"
            
            nameTextField.text = UserModel.workouts["\(workoutId)"]?.name
            aboutTextView.text = UserModel.workouts["\(workoutId)"]?.about
            
            let saveBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveAction))
            
            self.navigationItem.rightBarButtonItem = saveBarButton
        } else {
            
            self.navigationItem.title = "Add new workout"
            
            let addBarButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addAction))
            
            nameTextField.text = ""
            aboutTextView.text = ""
            
            self.navigationItem.rightBarButtonItem = addBarButton
            
        }
        
    }
    
//MARK: - Actions
    
    @objc func saveAction(){
        
        let manager = ServerManager.sharedManager
        
        let params: NSDictionary = [
            "name":nameTextField.text ?? "",
            "about":self.aboutTextView.text ?? "",
            "workoutId":self.workoutId
        ]
        
        manager.updateWorkout(parameters: params) { jsonDict, error in
            
            if (jsonDict != nil){
                
                self.navigationController?.popViewController(animated: true)
                
            } else if (error != nil){
                
                let errorAlert = UIAlertController(title: "Error", message: "There is \(error)", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
        
            }
        }
        
    }
    
    @objc func addAction(){
        
        let manager = ServerManager.sharedManager
        
        let params = [
            "name":nameTextField.text,
            "about":aboutTextView.text,
            
        ] as! [String : String]
        
        manager.addWorkout(parameters: params as NSDictionary) { resultDict, error in
            if (resultDict != nil){
                
                let newWorkout = WorkoutModel(id: resultDict?.object(forKey: "workoutId") as? String ?? "",
                                              about: resultDict?.object(forKey: "about") as? String ?? "",
                                              created: resultDict?.object(forKey: "createdAt") as? String ?? "",
                                              name: resultDict?.object(forKey: "name") as? String ?? "")
                
                UserModel.workouts[resultDict?.object(forKey: "workoutId") as? String ?? ""] = newWorkout
                
                let trainingVC = self.storyboard?.instantiateViewController(identifier: "trainingVC") as TrainingViewController?
                trainingVC?.currentWorkoutId = newWorkout.id
                self.navigationController?.pushViewController(trainingVC!, animated: true)
                
            } else if (error != nil){
                let errorAlert = UIAlertController(title: "Error", message: "There is \(String(describing: error))", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
        
        
        
    }

}

class CategoryPickerDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let categoriesData = ["Legs", "Arms", "Back"]
    static var selectedType = ""
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoriesData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        CategoryPickerDelegate.selectedType = categoriesData[row]
    }
    
    
    
    
}
