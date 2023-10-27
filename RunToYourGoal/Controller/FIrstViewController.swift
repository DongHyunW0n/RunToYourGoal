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

        // Do any additional setup after loading the view.
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
