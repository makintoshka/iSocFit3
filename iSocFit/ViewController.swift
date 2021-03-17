//
//  ViewController.swift
//  iSocFit
//
//  Created by makintosh on 18.02.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    
    @IBAction func actionLogin(){
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func loadView() {
        super.loadView()
        
        
        
        //let loginController = UIViewController()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

