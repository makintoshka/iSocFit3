//
//  ProfileInfoTableViewController.swift
//  iSocFit
//
//  Created by makintosh on 20.02.2021.
//

import UIKit
import SideMenu

class ProfileInfoTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
    @IBOutlet private weak var userFullName: UILabel!
    @IBOutlet private weak var userTag: UILabel!
    @IBOutlet private weak var userPhoto: UIImageView!
    @IBOutlet private weak var userNumber: UILabel!
    @IBOutlet private weak var userEmail: UILabel!
    @IBOutlet private weak var userAbout: UILabel!
    @IBOutlet private weak var userEmailField: UITextField!
    @IBOutlet private weak var userNumberField: UITextField!
    @IBOutlet private weak var aboutControl: UISegmentedControl!
    @IBOutlet private weak var userAboutTextView: UITextView!
    
    @IBAction func didTapUserPhoto(_ sender: UITapGestureRecognizer){
        
        ImagePickerManager().pickImage(self) { (image, fileName) in
            self.userPhoto.image = image
            
            self.updateUserPhoto(photo: image, photoFileName: fileName)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getInfo()
        getUserPhoto()
        getUserAbout()
        
        userEmailField.isHidden = true; userEmailField.delegate = self
        userNumberField.isHidden = true; userNumberField.delegate = self
        userAboutTextView.isHidden = true; userAboutTextView.delegate = self
        
        //userPhoto.image = UIImage(named: "User image.jpg"); userPhoto.isUserInteractionEnabled = false
        
        //self.navigationItem.setLeftBarButtonItems(nil, animated: true)
        //self.navigationItem.setHidesBackButton(true, animated: false)
        
        aboutControl.addTarget(self, action: #selector(openAbilityVC(sender:)), for: .valueChanged)
        
        let menuBarButton = UIBarButtonItem(image: UIImage(named: "list (1).png"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(openMenuAction(sender:)))
        
        menuBarButton.tintColor = UIColor(red: 138/255.0, green: 149/255.0, blue: 158/255.0, alpha: 1.0)
        self.navigationItem.leftBarButtonItem = menuBarButton
        
        editButtonItem.image = UIImage(systemName: "square.and.pencil")
        self.navigationItem.rightBarButtonItem = editButtonItem
        
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        userNumber.isHidden = editing; userEmail.isHidden = editing
        userNumberField.isHidden = !editing; userEmailField.isHidden = !editing
        userAbout.isHidden = editing; userAboutTextView.isHidden = !editing
        userNumberField.text = userNumber.text; userEmailField.text = userEmail.text
        userAboutTextView.text = userAbout.text;
        userPhoto.isUserInteractionEnabled = editing
        
        self.tableView.setEditing(editing, animated: true)
        
        
        
        editButtonItem.image = UIImage(systemName: "square.and.pencil")
        
        if self.tableView.isEditing {
            editButtonItem.image = UIImage(systemName: "checkmark")
        }else{
            update()
            updateUserAbout()
        }
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        let indexPaths = tableView.indexPathsForVisibleRows
        
        for indexPath in indexPaths! {
            let cell = tableView.cellForRow(at: indexPath)
            
            cell?.isEditing = editing
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        userEmailField.isHidden = !isEditing; userEmail.isHidden = isEditing
        userNumberField.isHidden = !isEditing; userNumber.isHidden = isEditing
        userNumber.text = userNumberField.text; userEmail.text = userEmailField.text
        
        
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        userAbout.isHidden = isEditing; userAboutTextView.isHidden = !isEditing
        userAbout.text = userAboutTextView.text
        
        return true
    }
   
    //MARK: - API
    
    func getInfo(){
        
        let manager = ServerManager.sharedManager
        
        manager.getUser(userID: "") { (userInfo) in
            let user = UserModel.currentUser
            self.userFullName.text = userInfo.object(forKey: "firstName") as! String
            self.userEmail.text = userInfo.object(forKey: "email") as! String
            self.userNumber.text = userInfo.object(forKey: "phone") as! String
            self.userTag.text = userInfo.object(forKey: "username") as! String
        } onFailure: { (error, statusCode) in
            let errorAlert = UIAlertController(title: "Error", message: "There is \(error)", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
            self.present(errorAlert, animated: true, completion: nil)
        }

        
    }
    
    func update(){
        
        let manager = ServerManager.sharedManager
        
        let params: NSDictionary = [
            "phone": userNumber.text
            
        ]
        
        manager.updateUser(parameters: params) { (newInfo, error) in
            if(error != nil){
                let errorAlert = UIAlertController(title: "Error", message: "There is \(error)", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
                
            }
            
        }
    }
    
    func getUserPhoto(){
        
        let manager = ServerManager.sharedManager
        
        manager.getUserPhotoUrl { (url, error) in
            if (url != nil){
                
                manager.getUserPhoto(url: url!) { (image, error) in
                    if (image != nil) {
                        self.userPhoto.image = image
                    } else if (error != nil){
                        let errorAlert = UIAlertController(title: "Error", message: "There is \(error)", preferredStyle: .alert)
                        errorAlert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                        self.present(errorAlert, animated: true, completion: nil)
                    }
                }
                
            } else if (error != nil){
                let errorAlert = UIAlertController(title: "Error", message: "There is \(error)", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
        
    }
    
    func updateUserPhoto(photo: UIImage, photoFileName: String){
        
        let manager = ServerManager.sharedManager

        manager.updateUserPhoto(photo: photo, photoFileName: photoFileName) { (dict, error) in
            if (dict != nil) {
                print(dict)
            } else if (error != nil){
                let errorAlert = UIAlertController(title: "Error", message: "There is \(error)", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
        
    }
    
    func getUserAbout(){
        
        let manager = ServerManager.sharedManager

        manager.getUserAbout { (json, error) in
            if (json != nil){
                
                self.userAbout.text = json?.object(forKey: "value") as! String
                
            } else if (error != nil){
                
                let errorAlert = UIAlertController(title: "Error", message: "There is \(error)", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
                
            }
        }
        
    }
    
    func updateUserAbout(){
        
        let manager = ServerManager.sharedManager
        
        let params: NSDictionary = [
            "about": userAbout.text
        ]
        
        manager.updateUserAbout(parameters: params) { (json, error) in
            if (json != nil){
                print(json)
            } else if (error != nil){
                
                let errorAlert = UIAlertController(title: "Error", message: "There is \(error)", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
        
    }
    
    // MARK: - Actions
    
    @objc func openAbilityVC(sender: UISegmentedControl){
        
        let abilityVC = storyboard?.instantiateViewController(identifier: "abilitiesVC")
        navigationController?.pushViewController(abilityVC!, animated: true)
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
        
    }
    
    //MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .none
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    

    
    
}
