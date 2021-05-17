//
//  ExerciseInfoVariableCell.swift
//  iSocFit
//
//  Created by makintosh on 09.05.2021.
//

import UIKit

protocol ExerciseVariableCellDelegate {
    func didIncreaseValue(newValue: Any, forParameter: String, workoutId: String, exerciseId: String)
    func didDecreaseValue(newValue: Any, forParameter: String, workoutId: String, exerciseId: String)
    func didChangeValue(newValue: Any, forParameter: String, workoutId: String, exerciseId: String)
}

class ExerciseInfoVariableCell: UICollectionViewCell, UITextFieldDelegate {

    var units: String = ""
    var name: String = ""
    var value: Any = "" {
        didSet{
            
        }
    };
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
    
    
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var parameterName: UILabel!
    @IBOutlet var valueForParam: UILabel!
    @IBOutlet var unitsForParam: UILabel!
    @IBOutlet var valueForParamTextField: UITextField!
    @IBOutlet var increaseButton: UIButton!
    @IBOutlet var decreaseButton: UIButton!
    var delegate: ExerciseVariableCellDelegate!
    
    @IBAction func increaseValue(_ sender: Any) {
        
        if parameterName.text == "Weight" {
            let newValue = Double(valueForParam.text!)! + 1.0
            valueForParam.text = "\(newValue)"
            valueForParamTextField.text = valueForParam.text
            self.delegate = ExerciseInfoViewController()
            self.delegate.didIncreaseValue(newValue: valueForParam.text ?? "", forParameter: parameterName.text ?? "", workoutId: currentWorkoutId, exerciseId: currentExerciseId)
        } else {
            let newValue = Int(valueForParam.text!)! + 1
            valueForParam.text = "\(newValue)"
            valueForParamTextField.text = valueForParam.text
            self.delegate = ExerciseInfoViewController()
            self.delegate.didIncreaseValue(newValue: valueForParam.text ?? "", forParameter: parameterName.text ?? "", workoutId: currentWorkoutId, exerciseId: currentExerciseId)
            
        }
    }
    @IBAction func decreaseValue(_ sender: Any) {
        
        if parameterName.text == "Weight" {
            let newValue = Double(valueForParam.text!)! - 1.0
            valueForParam.text = "\(newValue)"
            valueForParamTextField.text = valueForParam.text
            self.delegate = ExerciseInfoViewController()
            self.delegate.didIncreaseValue(newValue: valueForParam.text ?? "", forParameter: parameterName.text ?? "", workoutId: currentWorkoutId, exerciseId: currentExerciseId)
        } else {
            let newValue = Int(valueForParam.text!)! - 1
            valueForParam.text = "\(newValue)"
            valueForParamTextField.text = valueForParam.text
            self.delegate = ExerciseInfoViewController()
            self.delegate.didIncreaseValue(newValue: valueForParam.text ?? "", forParameter: parameterName.text ?? "", workoutId: currentWorkoutId, exerciseId: currentExerciseId)
        }
    }
    
    var isInEditingMode: Bool = false {
        
        didSet{
            increaseButton.isHidden = !isInEditingMode
            decreaseButton.isHidden = !isInEditingMode
            valueForParamTextField.isHidden = !isInEditingMode
            valueForParam.isHidden = isInEditingMode
            valueForParamTextField.text = self.valueForParam.text
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        valueForParamTextField.isHidden = !isInEditingMode
        valueForParam.isHidden = isInEditingMode
        valueForParam.text = valueForParamTextField.text
        self.delegate = ExerciseInfoViewController()
        self.delegate.didChangeValue(newValue: valueForParam.text ?? "", forParameter: parameterName.text ?? "", workoutId: currentWorkoutId, exerciseId: currentExerciseId)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
       
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        increaseButton.isHidden = !self.isInEditingMode
        decreaseButton.isHidden = !self.isInEditingMode
        valueForParamTextField.isHidden = !self.isInEditingMode
        
        valueForParam.text = "\(value)"
        print("________________value____________")
        print(value)
        
        contentView.layer.cornerRadius = 5.0
        contentView.layer.masksToBounds = true
        layer.cornerRadius = 5.0
        layer.masksToBounds = false
        
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.1
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        
        iconImage.image = UIImage(named: "weight.png")
    }
}



