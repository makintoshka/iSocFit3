//
//  AbilitiesCustomCell.swift
//  iSocFit
//
//  Created by makintosh on 22.02.2021.
//

import UIKit

class AbilitiesCustomCell: UICollectionViewCell {

    @IBOutlet var imageIconForCell: UIImageView!
    @IBOutlet var abilityTitleForCell: UILabel!
    @IBOutlet var abilityValueLabel: UILabel!
    
    var isInEditingMode: Bool = false {
        
        didSet{
            //deleteButton.isHidden = !isInEditingMode
        }
        
    }
    
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
        
        contentView.layer.cornerRadius = 12.0
        contentView.layer.masksToBounds = true
        layer.cornerRadius = 12.0
        layer.masksToBounds = false
        
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.1
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        
        
        imageIconForCell.image = UIImage(named: "body-scale.jpg")
        
    }

}
