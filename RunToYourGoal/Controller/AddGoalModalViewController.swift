//
//  AddGoalModalViewController.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 2023/10/11.
//

import UIKit
import RxSwift
import RxCocoa


class AddGoalModalViewController: UIViewController {

    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var descriptLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        descriptLabel.text = "목표가 너무 짧아요 !"
        descriptLabel.textColor = .red
        
        let goalValid = goalTextField.rx.text.orEmpty.map { $0.count >= 5 }.share(replay: 1)
        
        goalValid
            .map { $0 }
            .bind(to: descriptLabel.rx
                .isHidden)
            .disposed(by: disposeBag)
            
        }
        
    
        
        
        
        
   

    

}
