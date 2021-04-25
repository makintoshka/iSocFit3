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
        
        valuePicker.delegate = valuePickerDelegate; valuePicker.dataSource = valuePickerDelegate
        typePicker.delegate = typePickerDelegate; typePicker.dataSource = typePickerDelegate
        
//        let menuBarButton = UIBarButtonItem(image: UIImage(named: "list (1).png"),
//                                            style: .plain,
//                                            target: self,
//                                            action: #selector(openMenuAction(sender:)))
//
//        menuBarButton.tintColor = UIColor(red: 138/255.0, green: 149/255.0, blue: 158/255.0, alpha: 1.0)
//        self.navigationItem.leftBarButtonItem = menuBarButton
        
        let addBarButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addAction))
        
        self.navigationItem.rightBarButtonItem = addBarButton
        
        typePicker.selectRow(0, inComponent: 0, animated: true)
        valuePicker.selectRow(100, inComponent: 0, animated: true)
    }
    
    //MARK: - Actions
    
//    @objc func openMenuAction(sender: UIBarButtonItem){
//
//        //let loginVC = ViewController()
//        let menuVC = self.storyboard?.instantiateViewController(identifier: "menuViewController")
//
//        let leftMenuNavigationController = SideMenuNavigationController(rootViewController: menuVC!)
//        leftMenuNavigationController.leftSide = false
//        SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
//        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
//        //SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
//        present(leftMenuNavigationController, animated: true, completion: nil)
//
//    }
    
    @objc func addAction(){
        
        let manager = ServerManager.sharedManager
        
        let params = [
            "key":TypePickerDelegate.selectedType,
            "value":ValuePickerDelegate.selectedValue,
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
    
    let typesData = ["Weight", "Height", "Fat %"]
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
