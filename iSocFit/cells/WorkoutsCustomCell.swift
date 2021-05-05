//
//  WorkoutsCustomCell.swift
//  iSocFit
//
//  Created by makintosh on 28.02.2021.
//

import UIKit

class WorkoutsCustomCell: UITableViewCell {

    @IBOutlet var workoutTitle: UILabel!
    
    @IBOutlet var timeIconForCell: UIImageView!
    
    @IBOutlet var workoutTimeForCell: UILabel!
    
    @IBOutlet var workoutDateForCell: UILabel!
    
    @IBOutlet var workoutNotesLabel: UILabel!
    
    //@IBOutlet var deleteButton: UIButton!
    
    var isInEditingMode: Bool = false {
        
        didSet{
            //deleteButton.isHidden = !isInEditingMode
        }
        
    }
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: .default, reuseIdentifier: "workoutCell")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 5.0
        contentView.layer.masksToBounds = true
        layer.cornerRadius = 5.0
        layer.masksToBounds = false
        /*
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.1
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)*/
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 5)
        
        contentView.frame = contentView.frame.inset(by: insets)
        
    }
    
    
    
    
}
