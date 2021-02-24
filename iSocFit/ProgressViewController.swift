//
//  ProgressViewController.swift
//  iSocFit
//
//  Created by makintosh on 18.02.2021.
//

import UIKit

class ProgressViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Timer.scheduledTimer(timeInterval: 1, target: self, selector: "updateProgressView", userInfo: nil, repeats: true)
        
        progressView.setProgress(0, animated: true)
    }
    
    func updateProgressView(){
        
        
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
