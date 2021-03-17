//
//  ExerciseInfoViewController.swift
//  iSocFit
//
//  Created by makintosh on 15.03.2021.
//

import UIKit

private let reuseIdentifier = "ExerciseInfoCell"

class ExerciseInfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var exerciseCollectionView: UICollectionView!
    @IBOutlet var exerciseName: UILabel!
    @IBOutlet var notesForExercise: UILabel!
    
    override func loadView() {
        super.loadView()
        
        //exerciseCollectionView.dataSource = self
        //exerciseCollectionView.delegate = self
        exerciseCollectionView.register(ExerciseInfoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    //MARK: - Data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)  as! ExerciseInfoCell
        
        return cell
    }
    

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
