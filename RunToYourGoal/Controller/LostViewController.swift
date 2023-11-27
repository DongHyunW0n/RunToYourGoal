//
//  LostViewController.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 11/27/23.
//

import UIKit

class LostViewController: UIViewController {
    
    
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = NSLocalizedString("Please write down your nickname and send it to nexon320@gmail.com . I'll send you the password reset link to your email address in up to 12 hours.", comment: "")
    }
    

}
