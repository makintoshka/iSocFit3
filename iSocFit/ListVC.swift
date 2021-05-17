//
//  ListVC.swift
//  iSocFit
//
//  Created by makintosh on 08.05.2021.
//

import UIKit

private let reuseIdentifier = "ExerciseListCustomCell"
private let sectionInsets = UIEdgeInsets(
  top: 2.8,
  left: 2.8,
  bottom: 2.8,
  right: 2.8)

class ListVC: UIViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    
    let availableExercises: [Exercise] = Exercise.generateAvailableExercises()
    
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
        
        configCollectionView()
        
    }
    
    private var selectedCell = [IndexPath]()
    private var selectedExercises: [Exercise] = []
    
    //MARK: - Config
    
    private func configCollectionView(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.register(UINib(nibName: "ExerciseListCustomCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    
    //MARK: - Actions
    
    @IBAction func addAction(_ sender: Any) {
        
        if selectedExercises.count != 0 {
            
            let manager = ServerManager.sharedManager
            
            manager.addExercises(workoutId: currentWorkoutId, parameters: selectedExercises as NSArray) { resultArray, error in
                if (resultArray != nil){
                    
                    print("______________zopazopazopa_______________")
                    print(resultArray)
                    
                    var tmp: [String:Exercise] = [:]
                    
                    for exercise in resultArray! {
                        
                        let currentExercise = exercise as! NSDictionary
                    
                        let repeats = currentExercise.object(forKey: "repeats") as? Int
                        let sets = currentExercise.object(forKey: "sets") as? Int
                        let duration = currentExercise.object(forKey: "duration") as? Int
                        let name = currentExercise.object(forKey: "name") as? String
                        let about = currentExercise.object(forKey: "about") as? String
                        let calories = currentExercise.object(forKey: "calories") as? Int
                        let weight = currentExercise.object(forKey: "weight") as? Double
                        let category = currentExercise.object(forKey: "category") as? String
                        let id = currentExercise.object(forKey: "workoutId") as? String
                        let order = currentExercise.object(forKey: "order") as? Int
                        
                        let tmpExercise = Exercise(repeatsNumber: repeats ?? 0, setsNumber: sets ?? 0, duration: duration ?? 0, name: name!, about: about!, calories: calories ?? 0, weight: weight ?? 0, category: category ?? "category", id: id!, order: order!)
                        
                        tmp[id!] = tmpExercise
                        
                    }
                    
                    UserModel.workouts[self.currentWorkoutId]?.exercises = tmp
                    tmp = [:]
                    
                    
                    self.dismiss(animated: true) {
                        
                    }
                    
                } else if (error != nil){
                    
                    let errorAlert = UIAlertController(title: "Error", message: "There is \(error)", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                    
                }
            }
            
        }
        
    }

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ExerciseListCustomCell
    
        cell.exerciseName.text = availableExercises[indexPath.row].name
        cell.exerciseRepeatsValue.text = "\(availableExercises[indexPath.row].repeatsNumber)"
        cell.exerciseSetsValue.text = "\(availableExercises[indexPath.row].setsNumber)"
        cell.exerciseLeadTime.text = "\(availableExercises[indexPath.row].duration)"
    
        if selectedCell.contains(indexPath) {
                
            cell.backgroundColor = UIColor(red: 95.0/255.0, green: 96.0/255.0, blue: 197.0/255.0, alpha: 1.0)
            
        } else {
            
            cell.backgroundColor = UIColor(red: 99.0/255.0, green: 132.0/255.0, blue: 228.0/255.0, alpha: 1.0)
        }
        
        return cell
    }

    //MARK: Search
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(!(searchBar.text?.isEmpty)!){
            //reload your data source if necessary
            self.collectionView.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty){
            //reload your data source if necessary
            self.collectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "exercisesSearch", for: indexPath)

                 return headerView
             }

             return UICollectionReusableView()

        }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ExerciseListCustomCell
            
        selectedCell.append(indexPath)
        
        selectedExercises.append(availableExercises[indexPath.row])
        
        cell.backgroundColor = UIColor(red: 95.0/255.0, green: 96.0/255.0, blue: 197.0/255.0, alpha: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ExerciseListCustomCell
        
        if selectedCell.contains(indexPath) {
            selectedCell.remove(at: selectedCell.firstIndex(of: indexPath)!)
            //selectedExercises.remove(at: indexPath.row)
            cell.backgroundColor = UIColor(red: 99.0/255.0, green: 132.0/255.0, blue: 228.0/255.0, alpha: 1.0)
        }
        
        
    }

    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (view.frame.width - sectionInsets.left * 10)/5
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.top
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2.8
    }

}
