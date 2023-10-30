//
//  SplashViewController.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 10/31/23.
//

import Foundation
import UIKit
import Firebase
import FirebaseCore

class SplashViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.handlingAuthCheckUser()
        })
    }
    
    //MARK: - auth check
    fileprivate func handlingAuthCheckUser() {
            if Auth.auth().currentUser != nil {
                print("이미 로그인 되어있음.")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let mainListViewController = storyboard.instantiateViewController(identifier: "MainListViewController") as? MainListViewController {
                    self.navigationController?.pushViewController(mainListViewController, animated: true)
                }
                
            } else {
                print("로그인 되어있지 않음.")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let loginViewController = storyboard.instantiateViewController(identifier: "FirstViewController") as? FIrstViewController {
                    self.navigationController?.pushViewController(loginViewController, animated: true)
                }
            }
        }
        
}
