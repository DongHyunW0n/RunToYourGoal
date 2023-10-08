//
//  LoginViewController.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 2023/08/28.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

private let minimalUsernameLength = 5
private let minimalPasswordLength = 8






class LoginViewController: UIViewController {
    
    
    
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var usernameValidOutlet: UILabel!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidOutlet: UILabel!
    
    @IBOutlet weak var doSomethingOutlet: UIButton!
    
    let disposeBag = DisposeBag() //디스포스백을 사용하기 위해 디스포스백 선언
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        usernameValidOutlet.text = "이메일 주소를 올바르게 입력해주세요"
        passwordValidOutlet.text = "비밀번호는 8자 이상 입력해주세요"
        
        let usernameValid = usernameOutlet.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
            .share(replay: 1) // without this map would be executed once for each binding, rx is stateless by default
        
        let passwordValid = passwordOutlet.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
            .share(replay: 1)
        
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)
        usernameValid
            .bind(to: passwordOutlet.rx.isEnabled)
            .disposed(by: disposeBag)
        
        usernameValid
            .bind(to: usernameValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)
        
        passwordValid
            .bind(to: passwordValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)
        
        everythingValid
            .bind(to: doSomethingOutlet.rx.isEnabled)
            .disposed(by: disposeBag)
        
        doSomethingOutlet.rx.tap
            .subscribe(onNext: { self.login(self.usernameOutlet.text!, self.passwordOutlet.text!)})
            .disposed(by: disposeBag)
    }
    
    
    
    func login(_ email : String ,  _ password : String ){
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                
                let code = (error as NSError).code
                
                
                switch code  {
                    
                case 17009 : //비밀번호 틀림
                    
                    self.showAlert(detail: "비밀번호가 틀렸습니다 !")
                    
                    
                default :
                    
                    self.showAlert(detail: "\(error.localizedDescription)")
                }
                
                print("사용자 생성 오류: \(error.localizedDescription)")
            } else if let authResult = authResult {
                // 사용자 생성이 성공한 경우
                let user = authResult.user
                print("로그인 완료 ! UID는 : \(user.uid)")
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                
                guard let mainVC = storyboard.instantiateViewController(identifier: "MainListViewController") as? MainListViewController else{return}
                mainVC.userID = user.uid
                
                
                
                self.navigationController?.show(mainVC, sender: nil)
                
                
                
                
                
            }
        }
        
        
    }
    
    func showAlert( detail : String) {
        
        
        let alertController = UIAlertController(title: "에러", message: detail , preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "확인", style: .cancel)
        alertController.addAction(okButton)
        present(alertController, animated: true)
        
    }
    
    
    
}

