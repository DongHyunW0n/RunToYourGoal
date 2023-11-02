//
//  AddViewController.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 11/2/23.
//

import UIKit
import SwiftUI
import RxSwift
import FirebaseDatabase
import FirebaseAuth

class AddViewController: UIViewController {
    
    
    //스냅킷 안쓰고 나름대로 깔끔하게 적은 코드베이스 ui ㅎㅎ 
    let titleLabel = UILabel()
    let goalTextField = UITextField()
    let statusLabel = UILabel()
    let saveButton = UIButton()
    
    
    let backgroundColor = UIColor(
        red: CGFloat(0xF8) / 255.0,
        green: CGFloat(0xF7) / 255.0,
        blue: CGFloat(0xF3) / 255.0,
        alpha: 1.0
    )
    let disposeBag =  DisposeBag()
    let ref = Database.database().reference()
    let currentUID = Auth.auth().currentUser?.uid
    let currentDate = getCurrentTime()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        configureUI()
        
        //목표가 유효한지 먼저 확인
        let goalValid = goalTextField.rx.text.orEmpty.map { $0.count >= 2 && $0.count <= 15}.share(replay: 1)
        
        goalValid.bind(to: statusLabel.rx.isHidden) //goalValid가 true일때 statusLabel 이 hidden. false일때 출력됨.
            .disposed(by: disposeBag)
        
        goalValid.bind(to: saveButton.rx.isEnabled) //goalValidd가 true일때 statusLabel 이 활성화됨. 기본세팅은 비활성화
            .disposed(by: disposeBag)
        
        
    }

    

    func configureUI(){
        setTItleLabel()
        setGoalTextField()
        setStatusLabel()
        setSaveButton()
        
        
        
    }
    
    
    
    func setTItleLabel() {
        titleLabel.text = "추가할 목표를 적어보세요"
        titleLabel.font = UIFont(name: "SOYO Maple Bold", size: 25)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 40) ,

            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            
        ])
    }
    
    func setGoalTextField(){
        
        goalTextField.placeholder = "예시)매일매일 물 2L 마시기"
        goalTextField.font = UIFont(name: "SOYO Maple Regular", size: 20)
        goalTextField.layer.borderWidth = 0.5
        view.addSubview(goalTextField)
        
        
        goalTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            goalTextField.heightAnchor.constraint(equalToConstant: 50),
            goalTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 100),
            goalTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            goalTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            
            
       ])
    }
    
    func setStatusLabel(){
        statusLabel.text = "목표의 길이를 확인해주세요"
        statusLabel.textColor = .red
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont(name: "SOYO Maple Regular", size: 12)
        view.addSubview(statusLabel)
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            

            statusLabel.topAnchor.constraint(equalTo: goalTextField.bottomAnchor, constant: 40),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
       

        
        ])
    }

    
    
    
    func setSaveButton() {
        
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitle("입력 대기중", for: .disabled)
        saveButton.setTitle("추가하기", for: .normal)

        saveButton.titleLabel?.font = UIFont(name: "SOYO Maple Regular", size: 20)
        saveButton.addTarget(self, action: #selector(SaveButtonTabbed), for: .touchUpInside)
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            saveButton.heightAnchor.constraint(equalToConstant: 45),
            saveButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        
        
    }

    func saveDataOnServer(){
        
        let saveREF = ref.child("가입자 리스트").child("\(currentUID ?? "UID")")
        saveREF.child("목표 리스트").childByAutoId().setValue(
            ["목표" : "\(goalTextField.text ?? "목표 입력 오류")" ,
             "시작일" : "\(currentDate)"
            ]
        )
        print("저장 완료")
    }
    
    
    @objc func SaveButtonTabbed(){
        
        alertAfterTabbedSave()
    }
    
    func alertAfterTabbedSave() {
        
        let alertController = UIAlertController(title: "확인", message: "추가 하시겠습니까?", preferredStyle: .alert)
        let save = UIAlertAction(title: "저장", style: .default) { UIAlertAction in
            self.saveDataOnServer()
            self.finalAlert()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(save)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
        
    }
    func finalAlert(){
        
        let alertController = UIAlertController(title: "완료", message: "추가되었습니다", preferredStyle: .actionSheet)
        
        let okbutton = UIAlertAction(title: "확인", style: .cancel) { UIAlertAction in
            
            self.dismiss(animated: true)
        }
        
        alertController.addAction(okbutton)
        present(alertController, animated: true)
    }
    
    
    
}


    

    
 
    
   



// 프리뷰 보려고 스유로 래핑함.

struct AddViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> AddViewController {
        return AddViewController()
    }
    
    func updateUIViewController(_ uiViewController: AddViewController, context: Context) {
        // 뷰 컨트롤러를 업데이트해야 하는 경우 업데이트합니다.
    }
}

struct AddViewControllerWrapp: PreviewProvider {
    static var previews: some View {
        AddViewControllerWrapper()
        
    }
}


