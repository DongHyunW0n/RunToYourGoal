//
//  AddGoalModalViewController.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 2023/10/11.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseDatabase
import FirebaseAuth


class AddGoalModalViewController: UIViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

         self.view.endEditing(true)

   }

    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var descriptLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    let disposeBag = DisposeBag()
    
    let ref = Database.database().reference()
    
    let currentUID = Auth.auth().currentUser?.uid
    
    let currentDate = getCurrentTime()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        
        
        
        descriptLabel.text = "목표가 너무 짧아요 !"
        descriptLabel.textColor = .red
        
        let goalValid = goalTextField.rx.text.orEmpty.map { $0.count >= 2 }.share(replay: 1)
        
        goalValid
            .map { $0 }
            .bind(to: descriptLabel.rx
                .isHidden)
            .disposed(by: disposeBag)
        
        goalValid
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)

            
        }

    
    
//    @objc func keyboardWillShow(notification: Notification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: Notification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 0 {
//                self.view.frame.origin.y += keyboardSize.height
//            }
//        }
//    }
    
    @IBAction func saveButtonTabbed(_ sender: UIButton) {
        
        let saveREF = ref.child("가입자 리스트").child("\(currentUID ?? "UID")")
        saveREF.child("목표 리스트").childByAutoId().setValue(
            ["목표" : "\(goalTextField.text ?? "목표 입력 오류")" ,
             "시작일" : "\(currentDate)"
            ]
        
        
        )

        let alert = UIAlertController(title: "완료", message: "목표 추가 완료!", preferredStyle: .actionSheet)
        let cancelbutton = UIAlertAction(title: "닫기", style: .cancel) { UIAlertAction in
            
            self.dismiss(animated: true)
            
        }
        alert.addAction(cancelbutton)
        present(alert, animated: true)
        
    }
}
