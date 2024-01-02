//
//  OnBoardingFinalViewController.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 11/6/23.
//

import UIKit

class OnBoardingFinalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToFirstPage(_ sender: UIButton) {
        
        print("gotoFirstButtonTabbed")
        
        let myNaviController = self.navigationController
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let firstViewController = storyboard.instantiateViewController(withIdentifier: "FIrstViewController") as? FIrstViewController {
            print("퍼스트뷰컨있음")

            self.navigationController?.setViewControllers([firstViewController], animated: true)
            
        }
        
        
        
    }


}
