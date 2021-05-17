//
//  AbilitiesViewController.swift
//  iSocFit
//
//  Created by makintosh on 22.02.2021.
//

import UIKit
import SideMenu

private let sectionInsets = UIEdgeInsets(
  top: 10.0,
  left: 10.0,
  bottom: 10.0,
  right: 10.0)
private let reuseIdentifier = "cell"

var images = ["body-scale.jpg"]

struct Ability: Encodable {
    let id: String
    let key: String
    let value: Int
    let createdAt: String
}

class AbilitiesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var abilityCollectionView: UICollectionView!
    @IBOutlet var aboutControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAbilities()
        configNavBar()
        configCollectionView()
        
        
    }
    
    //MARK: - Config
    
    func configCollectionView(){
        
        
        abilityCollectionView.dataSource = self
        abilityCollectionView.delegate = self
        self.abilityCollectionView.register(UINib(nibName: "AbilitiesCustomCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.abilityCollectionView.allowsSelection = true
        
    }
    
    func configNavBar(){
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "Title Color"),
            NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 25)
        ]
        
        self.navigationItem.title = "\(UserModel.firstName) \(UserModel.lastName)"
        
        aboutControl.selectedSegmentIndex = 1;
        
        aboutControl.addTarget(self, action: #selector(openProfileInfo(sender:)), for: .valueChanged)
        
        self.navigationItem.setLeftBarButtonItems(nil, animated: true)
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        
        let menuBarButton = UIBarButtonItem(image: UIImage(named: "list (1).png"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(openMenuAction(sender:)))
        
        let addAbilityBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addAbilityAction))
        
        self.navigationItem.rightBarButtonItem = addAbilityBarButton
        
        menuBarButton.tintColor = UIColor(red: 138/255.0, green: 149/255.0, blue: 158/255.0, alpha: 1.0)
        self.navigationItem.leftBarButtonItem = menuBarButton
        
    }
    
    //MARK: - API
    
    func getAbilities(){
        
        let manager = ServerManager.sharedManager
        
        manager.getUserAbilities { [self] (userAbilities, error) in
            if ((userAbilities) != nil){
                
                
                var tmp: [String:NSMutableArray] = [:]
                
                for abilities in userAbilities! {
                    let currentAbility = abilities as! NSDictionary
                    let name = currentAbility.object(forKey: "key")
                    let value = currentAbility.object(forKey: "value") as! Int
                    let id = currentAbility.object(forKey: "userStatsId") as! String
                    let created = currentAbility.object(forKey: "createdAt") as! String
                    let category = currentAbility.object(forKey: "statsCategoryId")
                    let key = currentAbility.object(forKey: "key") as! String
                    let ability = Ability(id: id, key: key, value: value, createdAt: created)
                    
                    
                    
                    if (tmp[key] == nil){
                        tmp[key] = []
                    }
                    tmp[key]?.add(ability)
                    
                }
                let user = UserModel.currentUser
                
                UserModel.abilities = tmp
                abilityCollectionView.reloadData()
                
            } else if((error) != nil){
                
                let errorAlert = UIAlertController(title: "Error", message: "There is \(String(describing: error))", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    //MARK: - Actions
    
    @objc func addAbilityAction(){
        
        let addValueVC = storyboard?.instantiateViewController(identifier: "addAbilityValueVC") as! AddAbilityValueController
        self.navigationController?.pushViewController(addValueVC, animated: true)
        
    }
    
    @objc func openMenuAction(sender: UIBarButtonItem){
        
        let menuVC = storyboard?.instantiateViewController(identifier: "menuViewController")
        
        let leftMenuNavigationController = SideMenuNavigationController(rootViewController: menuVC!)
        leftMenuNavigationController.leftSide = false
        SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        
        present(leftMenuNavigationController, animated: true, completion: nil)
    }

    @objc func openProfileInfo(sender: UISegmentedControl){
        
        navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    private var _dataToView: [Ability] = []


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        _dataToView = []
        let user = UserModel.currentUser
        
        for i in UserModel.abilities{
            _dataToView.append(i.value[0] as! Ability)
        }
        _dataToView.sort { (a, b) -> Bool in
            return a.createdAt > b.createdAt
        }
        print("__________zopa______________")
        print(UserModel.abilities.count)
        
        return _dataToView.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let user = UserModel.currentUser
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AbilitiesCustomCell
    
        cell.abilityTitleForCell.text = _dataToView[indexPath.row].key
        cell.abilityValueLabel.text = "\(_dataToView[indexPath.row].value)"
       
        
       
        return cell
    }
    
    //MARK: - Search
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(!(searchBar.text?.isEmpty)!){
            
            
            
            self.abilityCollectionView?.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty){
            
            self.abilityCollectionView?.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView:UICollectionReusableView =  abilityCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "abilitySearch", for: indexPath)

                 return headerView
             }

             return UICollectionReusableView()

        }
    
    // MARK: UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width/3, height: view.frame.width/3)
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let abilityProgressVC = self.storyboard?.instantiateViewController(identifier: "abilityProgressVC") as! AbilityProgressViewController
        abilityProgressVC.abilityKey = _dataToView[indexPath.row].key
        self.navigationController?.pushViewController(abilityProgressVC, animated: true)
        
        
    }
    
    
    
}


    
    

