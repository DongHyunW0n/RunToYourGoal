//
//  ReportViewController.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 2023/10/27.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ReportViewController: UIViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

         self.view.endEditing(true)

   }

    @IBOutlet weak var textView: UITextView!
    
    let currentUserUID = Auth.auth().currentUser?.uid

    let ref = Database.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
    }
    

    @IBAction func sendButton(_ sender: UIButton) {
        
        ref.child("건의사항").child("\(currentUserUID ?? "누군지 모르는 uid")").childByAutoId().setValue(textView.text)
        doneAlert()
        
        
        
        
    }
    
    func doneAlert()->() {
        
        let alert = UIAlertController(title: "전송 완료", message: "피드백 감사드립니다!", preferredStyle: .actionSheet)
        let cancelbutton = UIAlertAction(title: "완료", style: .cancel) { UIAlertAction in
            
            self.dismiss(animated: true)
            
        }
        alert.addAction(cancelbutton)
        present(alert, animated: true)
  
    }
}
