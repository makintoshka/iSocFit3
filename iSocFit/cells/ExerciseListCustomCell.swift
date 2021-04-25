//
//  ExerciseListCustomCell.swift
//  iSocFit
//
//  Created by makintosh on 02.04.2021.
//

import UIKit

class ExerciseListCustomCell: UICollectionViewCell {

    @IBOutlet private weak var exerciseTitle: UILabel!
    @IBOutlet private weak var exerciseRepeatsValue: UILabel!
    @IBOutlet private weak var exerciseSetsValue: UILabel!
    @IBOutlet private weak var exerciseLeadTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 7.0
        layer.masksToBounds = true
        layer.cornerRadius = 7.0
        layer.masksToBounds = false
    }

}
