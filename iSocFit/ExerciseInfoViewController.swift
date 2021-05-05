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

class ExerciseInfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    @IBOutlet var exerciseCollectionView: UICollectionView!
    @IBOutlet var exerciseName: UILabel!
    @IBOutlet var notesForExercise: UILabel!
    @IBOutlet var exerciseNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        editButtonItem.image = UIImage(systemName: "square.and.pencil")
        self.navigationItem.rightBarButtonItem = editButtonItem
        
        exerciseNameField.isHidden = true
        exerciseNameField.delegate = self
        
        navigationItem.title = "Push ups"
        
        exerciseCollectionView.dataSource = self
        exerciseCollectionView.delegate = self
        exerciseCollectionView!.register(UINib(nibName: "ExerciseInfoCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        exerciseName.isHidden = editing
        exerciseNameField.isHidden = !editing
        exerciseNameField.text = exerciseName.text
        
        self.exerciseCollectionView.isEditing = editing
        
        editButtonItem.image = UIImage(systemName: "square.and.pencil")
        
        if self.exerciseCollectionView.isEditing {
            editButtonItem.image = UIImage(systemName: "checkmark")
        }
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        
        let indexPaths = exerciseCollectionView.indexPathsForVisibleItems
        
        for indexPath in indexPaths {
            let cell = exerciseCollectionView.cellForItem(at: indexPath) as! ExerciseInfoCell
            
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        exerciseNameField.isHidden = !isEditing
        exerciseName.isHidden = isEditing
        exerciseName.text = exerciseNameField.text
        return true
    }
    
    //MARK: - Data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)  as! ExerciseInfoCell
        
        
        
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
