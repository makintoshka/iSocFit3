//
//  AbilitiesCustomCell.swift
//  iSocFit
//
//  Created by makintosh on 22.02.2021.
//

import UIKit

class AbilitiesCustomCell: UICollectionViewCell {

    let iconForCell: UIImageView = {
        
        let abilitiesImageView = UIImageView()
        abilitiesImageView.translatesAutoresizingMaskIntoConstraints = false
        abilitiesImageView.contentMode = .topLeft
        abilitiesImageView.clipsToBounds = true
        abilitiesImageView.image = UIImage(named: "body-scale.jpg")
        abilitiesImageView.layer.cornerRadius = 12
        abilitiesImageView.backgroundColor = .red
        return abilitiesImageView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(iconForCell)
        
        iconForCell.image = UIImage(named: "body-scale.jpg")
        iconForCell.backgroundColor = .red
        iconForCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
        iconForCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40).isActive = true
        iconForCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 40).isActive = true
        iconForCell.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: 40).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
     }*/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
