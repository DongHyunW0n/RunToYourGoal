//
//  FIrstViewController.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 2023/08/27.
//

import UIKit

class FIrstViewController: UIViewController {

    @IBOutlet weak var simpleLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        simpleLabel.text = NSLocalizedString("the simplest", comment: "")
        titleLabel.text = NSLocalizedString("Daily habit check", comment: "")
        
        

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signUpTabbed(_ sender: UIButton) {
        
        print("가입버튼 눌러짐")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpView = storyboard.instantiateViewController(identifier: "JoinViewController")
        self.navigationController?.pushViewController(signUpView, animated: true)
        
        
        
    }
    @IBAction func signInTabbed(_ sender: UIButton) {
        
        print("로그인버튼 눌러짐")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInView = storyboard.instantiateViewController(identifier: "LoginViewController")
        self.navigationController?.pushViewController(signInView, animated: true)
        
        
    }
}
