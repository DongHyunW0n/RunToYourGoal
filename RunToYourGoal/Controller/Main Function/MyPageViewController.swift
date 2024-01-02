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
        
        let versionLabel : UILabel = {
            
            let label = UILabel()
            label.text =  "ver 1.0"
            label.font = UIFont(name: "SOYO Maple regular", size: 15)
            label.textColor = UIColor.black
            label.textAlignment = .center
            
            
            
            return label
        }()
        
        
        let nickNameLabel : UILabel = {
            
            let label = UILabel()
            label.text = ""
            label.font = UIFont(name: "SOYO Maple Regular", size: 25)
            label.textColor = UIColor.black
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true // 텍스트 크기를 조절하도록 설정
            label.minimumScaleFactor = 0.5 // 텍스트 크기의 최소 축소 비율 설정
            
            
            return label
            
            
        }()
        
        view.backgroundColor = backgroundColor
        
        navigationController?.navigationBar.tintColor = .black
        
        
        let reportButton : UIButton = {
            
            let button = UIButton()
            
            let buttonTitle = NSLocalizedString("Send a feedback", comment: "")
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.titleLabel?.textColor = UIColor.black
            button.addTarget(self, action: #selector(reportButtonTab), for : .touchUpInside)
            button.backgroundColor = .green
            button.layer.cornerRadius = 5
            
            
            return button
        }()
        
        
        let logoutButton : UIButton = {
            
            let button = UIButton()
            button.setTitle(NSLocalizedString("Log out", comment: ""), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.titleLabel?.textColor = UIColor.black
            button.addTarget(self, action: #selector(logoutButtontab), for : .touchUpInside)
            button.backgroundColor = .blue
            button.layer.cornerRadius = 5
            
            
            return button
        }()
        
        let outButton : UIButton = {
            
            let button = UIButton()
            button.setTitle(NSLocalizedString("Delete Account", comment: ""), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.titleLabel?.textColor = UIColor.black
            button.addTarget(self, action: #selector(deletebuttonTabbed), for : .touchUpInside)
            button.backgroundColor = .red
            button.layer.cornerRadius = 5
            
            
            return button
        }()
        
        //        topStackView.addArrangedSubview(nickNameTitle)
        //        topStackView.addArrangedSubview(nickNameLabel)
        
        view.addSubview(nickNameLabel)
        view.addSubview(logoutButton)
        view.addSubview(reportButton)
        view.addSubview(versionLabel)
        view.addSubview(outButton)
        
        
        
        
        nickNameLabel.snp.makeConstraints { make in
            
            make.top.equalToSuperview().offset(120)
            make.leading.trailing.equalToSuperview().inset(20)
            
        }
        
        logoutButton.snp.makeConstraints { make in
            
            make.top.equalTo(nickNameLabel.snp.bottom).offset(120)
            
            make.leading.trailing.equalToSuperview().inset(120)
            
            
        }
        
        reportButton.snp.makeConstraints { make in
            
            make.top.equalTo(logoutButton.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(120)
            
        }
        outButton.snp.makeConstraints { make in
            
            make.top.equalTo(reportButton.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(120)
        }
        versionLabel.snp.makeConstraints { make in
            
            make.bottom.equalTo(view.snp.bottom).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        
        
        print("uid is \(Auth.auth().currentUser?.uid ?? "UID")")
        
        
        let currentUID = Auth.auth().currentUser?.uid
        let userRef = ref.child("가입자 리스트").child("\(currentUID ?? "UID")")
        
        userRef.observeSingleEvent(of: .value) { snapshot in
            if let value = snapshot.value as? [String: Any] {
                let nickName = value["닉네임"] as? String ?? "닉네임"
                print("nickname is \(nickName)")
                nickNameLabel.text = "\(nickName)"
            }
        }
        
        
        
        
        
        
        
    }
    
    @objc func logoutButtontab(){
        
        print("logout Button Tabbed") // 디버깅 메시지
        
        let firebaseAuth = Auth.auth()
        
        
        do{
            try firebaseAuth.signOut()
            print("로그아웃 성공")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let firstVC = storyboard.instantiateViewController(identifier: "SplashViewController")
            
            // 탐색 컨트롤러 초기화 및 루트 뷰 컨트롤러 설정
            let navController = UINavigationController(rootViewController: firstVC)
            
            // 애니메이션 효과 없이 Fullscreen으로 표시
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: false, completion: nil)
            
            
        }catch let sighOutError as NSError{
            
            print("ERROR : SIGNOUT \(sighOutError.localizedDescription)")
            
        }
        
        
    }
    
    @objc func reportButtonTab() {
        
        
        
        noticeAlert()
        
        
        
        
        
        
        
    }
    
    @objc func deletebuttonTabbed() {
        
        let user = Auth.auth().currentUser
        
        if let user = user {
            
            let alert = UIAlertController(title: NSLocalizedString("WARNING", comment: ""), message: NSLocalizedString("Are you sure?", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive, handler: { UIAlertAction in
                
                
                user.delete {error in
                    
                    if let error = error {
                        
                        print("계정 삭제 실패: \(error.localizedDescription)")
                        self.showFailAlert(message: error.localizedDescription)

                    }else{
                        
                        print("계정 삭제 성공")
                        self.backToFirstPage()
                    }
                    
                    
                    
                }
            }))
            self.present(alert, animated: true, completion: nil)

        }
    }
    
    
    func showFailAlert( message : String ){
        let alert = UIAlertController(title: NSLocalizedString("Fail", comment: ""), message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .cancel) { UIAlertAction in
            
        }
    
        alert.addAction(ok)
        
        self.present(alert, animated: true)
        
        
    }
    
    
    
    func backToFirstPage() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let firstVC = storyboard.instantiateViewController(identifier: "SplashViewController")
        
        // 탐색 컨트롤러 초기화 및 루트 뷰 컨트롤러 설정
        let navController = UINavigationController(rootViewController: firstVC)
        
        // 애니메이션 효과 없이 Fullscreen으로 표시
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: false, completion: nil)
        
        
    }
    func noticeAlert() {
        
        let alert = UIAlertController(title: "", message: NSLocalizedString("Please provide your email address to receive a response.", comment: ""), preferredStyle: .alert)
        let okbutton = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel) { UIAlertAction in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let reportView = storyboard.instantiateViewController(identifier: "ReportViewController")
            self.present(reportView, animated: true)
            
        }
        alert.addAction(okbutton)
        self.present(alert, animated: true)
        
    }
    
    
}
    


























struct MyPageViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MyPageViewController {
        return MyPageViewController()
    }

    func updateUIViewController(_ uiViewController: MyPageViewController, context: Context) {
    }
}

struct MyPageViewController_Preview: PreviewProvider {
    static var previews: some View {
        MyPageViewControllerWrapper()
        
    }
}
