//
//  WriteArticleViewController.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 12/5/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class WriteArticleViewController: UIViewController, sendUpdateDelegate {
    func sendUpdate(habit: String) {
       
       
            habitLabel.text = habit
        selectedHabit = habit
            print("업데이트함수 실행")

    }
    
    let ref = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    var selectedHabit : String?
    
    
    struct Article {
        
        var title : String
        var detail : String
        var writter : String
        var uid : String
        
        
    }
   
    var myNickname : String?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var attachHabitButton: UIButton!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var habitLabel: UILabel!
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNickNameFromServer()
    }
    

    
    func getNickNameFromServer() {
        
        let userRef = ref.child("가입자 리스트").child("\(uid ?? "UID")")
        
        userRef.observeSingleEvent(of: .value) { snapshot in
            if let value = snapshot.value as? [String: Any] {
                let nickName = value["닉네임"] as? String ?? "닉네임"
                self.myNickname = nickName
                print("nickname is \(nickName)")
            }
        }
        
    }
   
    
//    func saveDataOnServer(){
//        
//        let saveREF = ref.child("가입자 리스트").child("\(currentUID ?? "UID")")
//        saveREF.child("목표 리스트").childByAutoId().setValue(
//            ["목표" : "\(goalTextField.text ?? "목표 입력 오류")" ,
//             "시작일" : "\(currentDate)"
//            ]
//        )
//        print("저장 완료")
//    }

    @IBAction func attachButotnTabbed(_ sender: Any) {
        
        guard let listVC = self.storyboard?.instantiateViewController(withIdentifier: "ListVC") as? MyHabitListViewController else{return}
        listVC.delegate = self
        self.navigationController?.pushViewController(listVC, animated: true)
      
    }
    @IBAction func uploadButton(_ sender: Any) {
        
        let ShareBoardRef = ref.child("자유게시판")
        ShareBoardRef.childByAutoId().setValue(
        
            ["제목" : "\(titleTextField.text ?? "No title")" ,
             "닉네임" : "\(myNickname ?? "No nickname")" ,
             "uid" : "\(uid ?? " UID ERROR")" ,
             "목표" : "\(selectedHabit ?? "No habit selected")" ,
             "내용" : "\(detailTextView.text ?? "No detail text")"
 
            ]
        )
        print("글 저장 완료")
        self.navigationController?.popViewController(animated: true)
    
    }
}
