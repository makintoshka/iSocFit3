//
//  TrainingCustomCell.swift
//  iSocFit
//
//  Created by makintosh on 01.03.2021.
//

import UIKit

protocol DeleteExerciseCustomCellDelegate {
    func deleteExercise(workoutId: String, exerciseId: String, atIndexPath: IndexPath)
}

class TrainingCustomCell: UICollectionViewCell {
    
    @IBOutlet var exerciseTitle: UILabel!
    @IBOutlet var exerciseRepeatsValue: UILabel!
    @IBOutlet var exerciseSetsValue: UILabel!
    @IBOutlet var exerciseLeadTime: UILabel!
    @IBOutlet var visibleRect: UIView!
    @IBOutlet var topLine: UIView!
    @IBOutlet var leftLine: UIView!
    @IBOutlet var rightLine: UIView!
    @IBOutlet var bottomLine: UIView!
    @IBOutlet var deleteButton: UIButton!
    var delegate: DeleteExerciseCustomCellDelegate!
    var cellNumber: IndexPath = IndexPath(item: 0, section: 0)
    @IBAction func deleteExercise(_ sender: Any) {
        
        print("_______________________button pressed________________________")
        
        
        self.backgroundColor = .red
        
        self.delegate = TrainingViewController()
        self.delegate.deleteExercise(workoutId: currentWorkoutId, exerciseId: currentExerciseId, atIndexPath: cellNumber)
        
        //self.backgroundColor = .white
    }
    
    private var _currentExerciseId: String = ""
    public var currentExerciseId: String{
        get {
            return _currentExerciseId
        }
        set {
            _currentExerciseId = newValue
        }
    }
    
    private var _currentWorkoutId: String = ""
    public var currentWorkoutId: String{
        get {
            return _currentWorkoutId
        }
        set {
            _currentWorkoutId = newValue
        }
    }
    
    var isInEditingMode: Bool = false {
        
        didSet{
            deleteButton.isHidden = !isInEditingMode
            
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
        
        visibleRect.layer.cornerRadius = 7.0
        visibleRect.layer.masksToBounds = true
        layer.cornerRadius = 7.0
        layer.masksToBounds = false
        
    }

}
