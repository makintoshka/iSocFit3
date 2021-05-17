//
//  AbilitiesCustomCell.swift
//  iSocFit
//
//  Created by makintosh on 22.02.2021.
//

import UIKit

enum AbilityType {
    case weight
    case height
    case leanMass
    case bodyFat
    case fatPercentage
    case fatAroundOrgans
    case muscleMass
    case musclePercentage
    case boneMass
    case waterPercentage
    case bodyMassIndex
    case metabolicAge
    case waist
    case thighs
    case legVolume
    case bicepsVolume
    case backVolume
    case breastVolume
    case dailyCaloryIntake
    case none
}

class AbilitiesCustomCell: UICollectionViewCell {
    
    @IBOutlet var imageIconForCell: UIImageView!
    @IBOutlet var abilityTitleForCell: UILabel!
    @IBOutlet var abilityValueLabel: UILabel!
    
    var type: AbilityType = .none
    
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
        
        
        
        switch self.type {
        case .weight:
            self.abilityTitleForCell.text = "Weight"
            self.imageIconForCell.image = UIImage(named: "weight.png")
        case .height:
            self.abilityTitleForCell.text = "Height"
            self.imageIconForCell.image = UIImage(named: "height.png")
        case .leanMass:
            self.abilityTitleForCell.text = "Lean mass"
            self.imageIconForCell.image = UIImage(named: "weight.png")
        case .bodyFat:
            self.abilityTitleForCell.text = "Body fat"
            self.imageIconForCell.image = UIImage(named: "weight.png")
        case .fatPercentage:
            self.abilityTitleForCell.text = "Fat percent"
            self.imageIconForCell.image = UIImage(named: "percent.png")
        case .fatAroundOrgans:
            self.abilityTitleForCell.text = "Fat around organs"
            self.imageIconForCell.image = UIImage(named: "weight.png")
        case .muscleMass:
            self.abilityTitleForCell.text = "Muscle mass"
            self.imageIconForCell.image = UIImage(named: "weight.png")
        case .musclePercentage:
            self.abilityTitleForCell.text = "Muscle percent"
            self.imageIconForCell.image = UIImage(named: "percent.png")
        case .boneMass:
            self.abilityTitleForCell.text = "Bone mass"
            self.imageIconForCell.image = UIImage(named: "weight.png")
        case .waterPercentage:
            self.abilityTitleForCell.text = "Water percent"
            self.imageIconForCell.image = UIImage(named: "percent.png")
        case .bodyMassIndex:
            self.abilityTitleForCell.text = "Body mass index"
            self.imageIconForCell.image = UIImage(named: "weight.png")
        case .metabolicAge:
            self.abilityTitleForCell.text = "Height"
            self.imageIconForCell.image = UIImage(named: "height.png")
        case .waist:
            self.abilityTitleForCell.text = "Waist"
            self.imageIconForCell.image = UIImage(named: "weight.png")
        case .thighs:
            self.abilityTitleForCell.text = "Thigs"
            self.imageIconForCell.image = UIImage(named: "height.png")
        default:
            self.abilityTitleForCell.text = "None"
        }
        
    }

}
