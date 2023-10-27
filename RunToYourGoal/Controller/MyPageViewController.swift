//
//  MyPageViewController.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 2023/10/27.
//
import SwiftUI
import UIKit
import SnapKit
import FirebaseAuth
import FirebaseDatabase




class MyPageViewController : UIViewController{
    
    let backgroundColor = UIColor(
        red: CGFloat(0xF8) / 255.0,
        green: CGFloat(0xF7) / 255.0,
        blue: CGFloat(0xF3) / 255.0,
        alpha: 1.0
    )
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        let nickNameLabel : UILabel = {
            
            let label = UILabel()
            label.text = "닉네임입니다"
            label.font = UIFont.systemFont(ofSize: 20)
            label.textColor = UIColor.black
            label.adjustsFontSizeToFitWidth = true // 텍스트 크기를 조절하도록 설정
            label.minimumScaleFactor = 0.5 // 텍스트 크기의 최소 축소 비율 설정
            
            
            return label
            
            
        }()
        
        view.backgroundColor = backgroundColor

        navigationController?.navigationBar.tintColor = .black
        
        let topStackView : UIStackView = {
            
            let view = UIStackView()
            view.axis = .horizontal
            view.spacing = 0
            view.distribution = .fill
            view.alignment = .center
            
            return view
            
        }()
        
        
        
        
        let nickNameTitle : UILabel = {
            
            let label = UILabel()
            label.text = "닉네임 :"
            label.font = UIFont.systemFont(ofSize: 20)
            label.textColor = UIColor.black
            label.textAlignment = .center
            return label

        }()
        
    
        
        let reportButton : UIButton = {
            
            let button = UIButton()
            button.setTitle("개발자에게 건의하기", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.titleLabel?.textColor = UIColor.black
            button.addTarget(self, action: #selector(reportButtonTab), for : .touchUpInside)
            button.backgroundColor = .red
            button.layer.cornerRadius = 5
            
            
            return button
        }()
        
        
        let logoutButton : UIButton = {
            
            let button = UIButton()
            button.setTitle("로그아웃", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.titleLabel?.textColor = UIColor.black
            button.addTarget(self, action: #selector(logoutButtontab), for : .touchUpInside)
            button.backgroundColor = .green
            button.layer.cornerRadius = 5
            
            
            return button
        }()
        
        topStackView.addArrangedSubview(nickNameTitle)
        topStackView.addArrangedSubview(nickNameLabel)
        
        view.addSubview(topStackView)
        view.addSubview(logoutButton)
        view.addSubview(reportButton)

        
        
        

        topStackView.snp.makeConstraints { make in

            make.top.equalToSuperview().offset(80)
            make.leading.trailing.equalToSuperview().inset(100)
        }
        
        logoutButton.snp.makeConstraints { make in
            
            make.top.equalTo(topStackView.snp.bottom).offset(120)
            
            make.leading.trailing.equalToSuperview().inset(120)
            

        }
        
        reportButton.snp.makeConstraints { make in
            
            make.top.equalTo(logoutButton.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(120)
            
        }
        
        self.title = "내 정보"
        print("uid is \(Auth.auth().currentUser?.uid ?? "UID")")

        
        let currentUID = Auth.auth().currentUser?.uid
        let userRef = ref.child("가입자 리스트").child("\(currentUID ?? "UID")")
        
        userRef.observeSingleEvent(of: .value) { snapshot in
            if let value = snapshot.value as? [String: Any] {
                let nickName = value["닉네임"] as? String ?? "닉네임"
                print("nickname is \(nickName)")
                nickNameLabel.text = nickName
            }
        }
        
        
        

        
    }
    
    @objc func logoutButtontab(){
        
        print("logout Button Tabbed") // 디버깅 메시지
        
        let firebaseAuth = Auth.auth()
        
        
        do{
            try firebaseAuth.signOut()
            print("로그아웃 성공")
            self.navigationController?.popToRootViewController(animated: true)

            
        }catch let sighOutError as NSError{
            
            print("ERROR : SIGNOUT \(sighOutError.localizedDescription)")
            
        }
        

    }
    
    @objc func reportButtonTab() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let reportView = storyboard.instantiateViewController(identifier: "ReportViewController")
        self.present(reportView, animated: true)
        
        
        
    }

    
    
}


























struct MyPageViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MyPageViewController {
        return MyPageViewController()
    }

    func updateUIViewController(_ uiViewController: MyPageViewController, context: Context) {
        // 뷰 컨트롤러를 업데이트해야 하는 경우 업데이트합니다.
    }
}

struct MyPageViewController_Preview: PreviewProvider {
    static var previews: some View {
        MyPageViewControllerWrapper()
        
    }
}
