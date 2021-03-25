//
//  TrainingViewController.swift
//  iSocFit
//
//  Created by makintosh on 01.03.2021.
//

import UIKit

private let sectionInsets = UIEdgeInsets(
  top: 0.0,
  left: 0.0,
  bottom: 0.0,
  right: 0.0)

private let reuseIdentifier = "Cell"

class TrainingViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = editButtonItem
        
        self.collectionView!.register(UINib(nibName: "TrainingCustomCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        let indexPaths = collectionView.indexPathsForVisibleItems
        
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath) as! TrainingCustomCell
            
            cell.isInEditingMode = editing
        }
        
    }
    
    // MARK: - Actions
    
    
    
    
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
        
        performSegue(withIdentifier: "openExerciseInfo", sender: self)
    }
    
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
}
