//
//  OnBoardingFirstViewController.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 11/5/23.
//

import UIKit

class OnBoardingFirstViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        titleLabel.text = NSLocalizedString( "Welcome to the simplest daily habit check", comment: "")
        label.text = NSLocalizedString("Let me explain the simple usage", comment: "")

        // Do any additional setup after loading the view.
    }
    

 

}
