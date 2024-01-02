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
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

         self.view.endEditing(true)

   }

    @IBOutlet weak var textView: UITextView!
    
    let currentUserUID = Auth.auth().currentUser?.uid

    let ref = Database.database().reference()
    
    
    override func viewDidLoad() {
           super.viewDidLoad()
        label.text = NSLocalizedString("Send a feedback", comment: "")
        
        
        
       }
    

    @IBAction func sendButton(_ sender: UIButton) {
        
        ref.child("건의사항").child("\(currentUserUID ?? "누군지 모르는 uid")").childByAutoId().setValue(textView.text)
        doneAlert()

        
    }
    
    func doneAlert()->() {
        
        let alert = UIAlertController(title: NSLocalizedString("Done", comment: ""), message: NSLocalizedString("Thanks for your feedback!", comment: ""), preferredStyle: .actionSheet)
        let cancelbutton = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in
            
            self.dismiss(animated: true)
            
        }
        alert.addAction(cancelbutton)
        present(alert, animated: true)
  
    }
    

}
