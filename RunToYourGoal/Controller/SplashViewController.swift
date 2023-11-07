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
        
        let myNaviController = self.navigationController
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.handlingAuthCheckUser()
        })
    }
    
    //MARK: - auth check
    fileprivate func handlingAuthCheckUser() {
        if GetFirstTimeTF.isFirstTime() {
            print("처음 실행됨.")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let OnBoardingFirstViewController = storyboard.instantiateViewController(identifier: "OnBoardingFirstViewController") as? OnBoardingFirstViewController {
                OnBoardingFirstViewController.modalPresentationStyle = .fullScreen

                
                
                self.navigationController?.pushViewController(OnBoardingFirstViewController, animated: true)
            }
            
            
        } else if Auth.auth().currentUser != nil {
            print("과거에 이미 실행 , 이미 로그인 되어있음.")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let mainListViewController = storyboard.instantiateViewController(identifier: "MainListViewController") as? MainListViewController {

                self.navigationController?.setViewControllers([mainListViewController], animated: true)
            }
        } else {
            print("과거에 이미 실행, 로그인 되어있지 않음.")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let loginViewController = storyboard.instantiateViewController(identifier: "FIrstViewController") as? FIrstViewController {
                self.navigationController?.setViewControllers([loginViewController], animated: true)            }
        }
    }
}
