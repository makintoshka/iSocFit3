//
//  ViewController.swift
//  iSocFit
//
//  Created by makintosh on 18.02.2021.
//

import UIKit
import SideMenu

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    
    @IBAction func actionLogin(){
        
        let manager = ServerManager.sharedManager
        
        emailTextField.text = "test4@gm.ua"
        
        manager.authorizeUser(parameters: NSDictionary(object: emailTextField.text!, forKey: "email" as NSCopying)) { (someDict, error) in
            if (someDict != nil) {
                let profileVC = self.storyboard?.instantiateViewController(identifier: "profileInfo")
                
                self.navigationController?.pushViewController(profileVC!, animated: true)
            }
            else if (error != nil){
                
                let errorAlert = UIAlertController(title: "Error", message: "There is \(String(describing: error))", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
                
            }
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func loadView() {
        super.loadView()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
}

