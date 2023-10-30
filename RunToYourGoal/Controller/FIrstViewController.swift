//
//  FIrstViewController.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 2023/08/27.
//

import UIKit

class FIrstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true


        // Do any additional setup after loading the view.
    }
    

    @IBAction func signUpTabbed(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpView = storyboard.instantiateViewController(identifier: "JoinViewController")
        self.navigationController?.pushViewController(signUpView, animated: true)
        
        
        
    }
    @IBAction func signInTabbed(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInView = storyboard.instantiateViewController(identifier: "LoginViewController")
        self.navigationController?.pushViewController(signInView, animated: true)
        
        
    }
}
