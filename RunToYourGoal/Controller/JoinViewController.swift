//
//  JoinViewController.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 2023/08/27.
//

//
//  JoinViewController.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 2023/08/27.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseDatabase


private let minimalUsernameLength = 5
private let minimalPasswordLength = 8


let ref = Database.database().reference()



let minimumPWLength : Int = 5
class JoinViewController: UIViewController {

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
            .subscribe(onNext: { self.createUser(self.usernameOutlet.text!, self.passwordOutlet.text!)})
            .disposed(by: disposeBag)
    }
    

    
    func createUser(_ email : String ,  _ password : String ){
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
               
                let code = (error as NSError).code
                
                switch code  {
                    
                case 17007 : //이메일 이미 존재하는 경우
                    
                    self.showAlert(detail: "이미 존재하는 아이디입니다.\n 로그인 화면으로 이동합니다 !")
                    
                    
                default :
                    
                    self.showAlert(detail: "\(error.localizedDescription)")
                }
                
                print("사용자 생성 오류: \(error.localizedDescription)")
            } else if let authResult = authResult {
                // 사용자 생성이 성공한 경우
                let user = authResult.user
                
                let emailKey = user.email?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "defaultKey"

                
                
                print("계정 생성 완료 ! UID는 : \(user.uid)")
                
                ref.child("가입자 목록").child("\(user.uid)").child("일일 목표 리스트").setValue("아직 추가된 목표 없음")
                print("리얼타임 데이터베이스에 가입자 목록 추가 완료")
                
                
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                
                guard let mainVC = storyboard.instantiateViewController(identifier: "MainListViewController") as? MainListViewController else{return}
                mainVC.userID = user.uid
                
                
        
                self.navigationController?.pushViewController(mainVC, animated: true)

                
                
                
                
            }
        }

        
    }
    
    func showAlert( detail : String) {
        
        
        let alertController = UIAlertController(title: "에러", message: detail , preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "확인", style: .cancel) { _ in
            
            self.moveToLoginViewController()
        }
        alertController.addAction(okButton)
        present(alertController, animated: true)
        
    }

    func moveToLoginViewController() {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
        self.navigationController?.pushViewController(loginViewController, animated: true)
        print("로그인뷰컨트롤러로 이동 함수 블럭 실행!")
    
        
    }
    

}
