//
//  AddAbilityValueController.swift
//  iSocFit
//
//  Created by makintosh on 16.04.2021.
//

import UIKit
import SideMenu

class AddAbilityValueController: UITableViewController{
    
    private var _abilityKey: String = ""
    
    
    public var abilityKey: String{
        get {
            return _abilityKey
        }
        set {
            _abilityKey = newValue
        }
    }

    @IBOutlet private weak var valuePicker: UIPickerView!
    @IBOutlet private weak var typePicker: UIPickerView!
    @IBOutlet private weak var datePicker: UIDatePicker!
    
    let valuePickerDelegate = ValuePickerDelegate()
    let typePickerDelegate = TypePickerDelegate()
    var selectedValue = 0
    var selectedType = ""
    
    @IBAction func increaseValue(_ sender: Any) {
        
        let data = valuePickerDelegate.valuesData
        for i in 0...99 {
            if (data[i] == selectedValue) {
                selectedValue = data[i+1]
                valuePicker.selectRow(i+1, inComponent: 0, animated: true)
            }
        }
        
    }
    @IBAction func decreaseValue(_ sender: Any) {
        
        let data = valuePickerDelegate.valuesData
        for i in 0...99 {
            if (data[i] == selectedValue) {
                selectedValue = data[i-1]
                valuePicker.selectRow(i-1, inComponent: 0, animated: true)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavBar()
        configPickers()
        
        
    }
    
    //MARK: - Config
    
    func configPickers(){
        
        valuePicker.delegate = valuePickerDelegate; valuePicker.dataSource = valuePickerDelegate
        typePicker.delegate = typePickerDelegate; typePicker.dataSource = typePickerDelegate
        typePicker.selectRow(0, inComponent: 0, animated: true)
        valuePicker.selectRow(100, inComponent: 0, animated: true)
        
    }
    
    func configNavBar(){
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "Title Color"),
            NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 25)
        ]
        
        self.navigationItem.title = "Add new ability"
        
        let addBarButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addAction))
        
        self.navigationItem.rightBarButtonItem = addBarButton
        
    }
    
    //MARK: - Actions
    
    @objc func addAction(){
        
        let manager = ServerManager.sharedManager
        
        let params = [
            "key":TypePickerDelegate.selectedType,
            "value":ValuePickerDelegate.selectedValue,
            "categoryId": "00fe3f17-4bff-427e-83b1-a76d28018c75"
        ] as [String : Any]
        
        manager.addAbility(parameters: params as NSDictionary, abilityKey: TypePickerDelegate.selectedType) { (result, error) in
            if (error != nil){
                let errorAlert = UIAlertController(title: "Error", message: "There is \(String(describing: error))", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
        
        self.navigationController?.popViewController(animated: true)
        
        
    }

}

    

class ValuePickerDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let valuesData = Array(1...100)
    static var selectedValue = 0
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return valuesData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(valuesData[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ValuePickerDelegate.selectedValue = valuesData[row]
    }
    
    
}

class TypePickerDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let typesData = ["Weight", "Height", "Fat"]
    static var selectedType = ""
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typesData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typesData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        TypePickerDelegate.selectedType = typesData[row]
    }
    
    
    
    
}
