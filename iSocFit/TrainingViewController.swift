//
//  TrainingViewController.swift
//  iSocFit
//
//  Created by makintosh on 01.03.2021.
//

import UIKit
import SemiModalViewController
import Rideau

struct Exercise {
    let repeatsNumber: Int
    let setsNumber: Int
    let duration: Int
    let name: String
    let calories: Int
    let weight: Double
}

private let sectionInsets = UIEdgeInsets(
    top: 0.0,
    left: 0.0,
    bottom: 0.0,
    right: 0.0)

private let reuseIdentifier = "Cell"

class TrainingViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
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
        
        getExercises()
        
        editButtonItem.image = UIImage(systemName: "square.and.pencil")
        
        let addExerciseBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addExerciseAction))
        
        self.navigationItem.rightBarButtonItems = [editButtonItem, addExerciseBarButton]
        
        
        
        self.collectionView!.register(UINib(nibName: "TrainingCustomCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        self.collectionView.isEditing = editing
        
        editButtonItem.image = UIImage(systemName: "square.and.pencil")
        
        if self.collectionView.isEditing {
            editButtonItem.image = UIImage(systemName: "checkmark")
        }
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        
        let indexPaths = collectionView.indexPathsForVisibleItems
        
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath) as! TrainingCustomCell
            
            cell.isInEditingMode = editing
        }
        
    }
    
    //MARK: - API
    
    func getExercises(){
        
        let manager = ServerManager.sharedManager
        
        manager.getWorkoutExercises(id: workoutId) { exercises, error in
            if (exercises != nil){
                print("___________________________________________")
                print(exercises!)
            } else if (error != nil){
                
                let errorAlert = UIAlertController(title: "Error", message: "There is \(error)", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
            
        }
        
        
        
        
    }
    
    // MARK: - Actions
    
    @objc func addExerciseAction(){
        
        let exerciseListVC = (storyboard?.instantiateViewController(identifier: "exerciseListVC"))
        
        exerciseListVC?.modalPresentationStyle = .custom
        
        let rideuController = RideauViewController(
            bodyViewController: exerciseListVC!,
            configuration: {
                var config = RideauView.Configuration()
                config.snapPoints = [.pointsFromBottom(200), .fraction(0.5), .fraction(0.8), .fraction(1)]
                return config
        }(),
            initialSnapPoint: .pointsFromBottom(200),
            resizingOption: .noResize)
        
        present(rideuController, animated: true, completion: nil)
        
        
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 4
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
        
        let exerciseInfoVC = storyboard?.instantiateViewController(identifier: "exerciseInfoVC")
        navigationController?.pushViewController(exerciseInfoVC!, animated: true)
    }
    
}

