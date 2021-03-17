//
//  TrainingCustomCell.swift
//  iSocFit
//
//  Created by makintosh on 01.03.2021.
//

import UIKit

class TrainingCustomCell: UICollectionViewCell {
    
    @IBOutlet private weak var exerciseTitle: UILabel!
    @IBOutlet var exerciseRepeatsValue: UILabel!
    @IBOutlet var exerciseSetsValue: UILabel!
    @IBOutlet var exerciseLeadTime: UILabel!
    @IBOutlet var visibleRect: UIView!
    @IBOutlet var topLine: UIView!
    @IBOutlet var leftLine: UIView!
    @IBOutlet var rightLine: UIView!
    @IBOutlet var bottomLine: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
     }*/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        visibleRect.layer.cornerRadius = 7.0
        visibleRect.layer.masksToBounds = true
        layer.cornerRadius = 7.0
        layer.masksToBounds = false
        
        
        
        
        
    }

}
