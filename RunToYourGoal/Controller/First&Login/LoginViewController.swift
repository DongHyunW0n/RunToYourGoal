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
private let minimalPasswordLength = 6






class LoginViewController: UIViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

         self.view.endEditing(true)

   }
    
    
    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    
    @IBOutlet weak var usernameOutlet: UITextField!
//    @IBOutlet weak var usernameValidOutlet: UILabel!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidOutlet: UILabel!
    
    @IBOutlet weak var doSomethingOutlet: UIButton!
    
    let disposeBag = DisposeBag() //디스포스백을 사용하기 위해 디스포스백 선언
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signInLabel.text = NSLocalizedString("Sign In", comment: "")
        welcomeLabel.text = NSLocalizedString("Welcome!", comment: "")

//        usernameValidOutlet.text = "이메일 주소를 올바르게 입력해주세요"
        passwordValidOutlet.text = NSLocalizedString("Please enter a password of at least 6 characters", comment: "")
        
        let usernameValid = usernameOutlet.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
            .share(replay: 1)
        
        let passwordValid = passwordOutlet.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
            .share(replay: 1)
        
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)
        usernameValid
            .bind(to: passwordOutlet.rx.isEnabled)
            .disposed(by: disposeBag)
        
//        usernameValid
//            .bind(to: usernameValidOutlet.rx.isHidden)
//            .disposed(by: disposeBag)
        
        passwordValid
            .bind(to: passwordValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)
        
        everythingValid
            .bind(to: doSomethingOutlet.rx.isEnabled)
            .disposed(by: disposeBag)
        doSomethingOutlet.titleLabel?.text = NSLocalizedString("Sign In", comment: "")
        doSomethingOutlet.isExclusiveTouch = true
        
        doSomethingOutlet.rx.tap
            .subscribe(onNext: { self.loginUser(email: self.usernameOutlet.text!, password: self.passwordOutlet.text!)})
            .disposed(by: disposeBag)
    }
    

    
    func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if authResult != nil {
                print("로그인 성공")
                self.moveToMainView(uid: authResult?.user.uid ?? "UID")
            } else {
                let errorCode = (error! as NSError).code
                switch errorCode {
                case 17010:
                    self.showAlert(detail: "비밀번호 오류 횟수 초과로 계정이 잠겼습니다. nexon320@gmail.com 으로 계정을 적어서 보내주세요.")
                case 17999:
                    self.showAlert(detail: "아이디나 비밀번호를 확인해주세요.")
                default:
                    print("다른 로그인 오류 코드: \(errorCode)")
                }
            }
        }
    }
    
    func showAlert(detail: String) {
        let alertController = UIAlertController(title: "에러", message: detail, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .cancel)
        alertController.addAction(okButton)
        present(alertController, animated: true)
    }
    
    func moveToMainView(uid: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let TabBarController = storyboard.instantiateViewController(identifier: "TabBarController") as? TabBarController {

            self.present(TabBarController, animated: true)
        }
        print("메인 화면으로 이동합니다.")
    }
}
