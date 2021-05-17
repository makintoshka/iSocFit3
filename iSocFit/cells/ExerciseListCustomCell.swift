//
//  ExerciseListCustomCell.swift
//  iSocFit
//
//  Created by makintosh on 02.04.2021.
//

import UIKit

class ExerciseListCustomCell: UICollectionViewCell {

    @IBOutlet var exerciseName: UILabel!
    @IBOutlet var exerciseRepeatsValue: UILabel!
    @IBOutlet var exerciseSetsValue: UILabel!
    @IBOutlet var exerciseLeadTime: UILabel!
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 7.0
        layer.masksToBounds = true
        layer.cornerRadius = 7.0
        layer.masksToBounds = false
        
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.1
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        
        
        
    }
    
    
        
        
}
    


