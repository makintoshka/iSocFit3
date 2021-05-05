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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        aboutTextView.delegate = self
        
        categoryPicker.delegate = categoryPickerDelegate
        categoryPicker.dataSource = categoryPickerDelegate
        
        let addBarButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addAction))
        
        self.navigationItem.rightBarButtonItem = addBarButton
    }
    
//MARK: - Actions
    
    @objc func addAction(){
        
        let manager = ServerManager.sharedManager
        
        let params = [
            "name":nameTextField.text,
            "about":aboutTextView.text,
            "categoryId": "00fe3f17-4bff-427e-83b1-a76d28018c75"
        ] as [String : Any]
        
        manager.addAbility(parameters: params as NSDictionary, abilityKey: TypePickerDelegate.selectedType) { (result, error) in
            if (error != nil){
                let errorAlert = UIAlertController(title: "Error", message: "There is \(error)", preferredStyle: .alert)
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
