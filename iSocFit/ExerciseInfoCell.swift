//
//  ExerciseInfoCell.swift
//  iSocFit
//
//  Created by makintosh on 15.03.2021.
//

import UIKit

class ExerciseInfoCell: UICollectionViewCell {

    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var parameterName: UILabel!
    @IBOutlet var valueForParam: UILabel!
    
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
        
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.1
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        
        
        
        
        
    }
}
