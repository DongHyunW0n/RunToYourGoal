//
//  ArticleDetailViewController.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 12/5/23.
//

import UIKit
import SwiftUI
import FirebaseDatabase
import FirebaseAuth
import UserNotifications



struct CommentEntity {
    var commentDetail: String
    var commentWritter: String
    var commentID: String // 추가: 댓글 ID
}

class ArticleDetailViewController: UIViewController, UIScrollViewDelegate {

    var commentList : [CommentEntity] = []
    
    var titleText : String?
    var habitText : String?
    var detailText : String?
    var writterText : String?
    var articleID : String?
    var mynickName : String?


    let nicknameLabel : UILabel = {
        
        let label = UILabel()
        label.text = "nickname"
        label.font = UIFont(name: "SOYO Maple Regular", size: 15)
        label.textColor = .black
        return label
    }()
    
    
    let titleLabel : UILabel = {
        
        let label  = UILabel()
        label.text = "제목제목"
        label.font = UIFont(name: "SOYO Maple Regular", size: 20)
        label.textColor = .black
        return label
        
    }()
    
    let borderLineView1 : UIView = {
        
        
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let borderLineView2 : UIView = {
        
        
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let habitLabel : UILabel = {
        
        let label = UILabel()
        label.text = "No habit Selected"
        label.font = UIFont(name: "SOYO Maple Bold", size: 17)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let textView : UITextView = {
        
        let textView = UITextView()
        textView.text = "텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트텍스트"
        textView.font = UIFont(name: "SOYO Maple Regular", size: 15)
        textView.textColor = .black
        textView.backgroundColor = UIColor.init(hexCode: "F8F7F3")
        
        return textView
    }()
    
    let commentLabel : UILabel = {
       
        let label = UILabel()
        label.text = "Comment List"
        label.font = UIFont(name: "SOYO Maple Regular", size: 18)
        label.textColor = .black
  
        return label
    }()
    
    
    let commentTableView : UITableView = {
       
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let commentTextField : UITextField = {
        
        let textfield = UITextField()
        textfield.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textfield
        
    }()
    
    let addCommentButton : UIButton = {
        
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .darkGray
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.addTarget(self, action: #selector(tabbedAddcommentButton), for: .touchUpInside)

        return button
        
    }()
    
    let commentStackView : UIStackView = {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        
        return stackView
    }()
    
    let commentWriteStackView : UIStackView = {
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        
        return stackView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(hexCode: "F8F7F3")
        
        setNickNameLabel()
        setTitleLabel()
        setBorderLine()
        setHabitLabel()
        setTextView()
        setBorderLine2()
        setCommentStackView()
        updateUI()
        hideKeyboard()
        
        
        commentTableView.dataSource = self
        commentTableView.delegate = self
        
        commentTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "Cell")
        print("이 글의 ID는 \(articleID ?? "")")
        print("현재 로그인한 닉네임 : \(mynickName ?? "")")

        if commentList.isEmpty {
            
            print("등록된 댓글 없음")
        }else{
            print("등록된 댓글 개수 : \(commentList.count)")
        }
   
        
        let commentRef = ref.child("자유게시판").child(articleID ?? "ERROR").child("댓글")

           commentRef.observe(.value) { dataSnapshot in
               self.commentList = []

               for child in dataSnapshot.children {
                   guard let childSnapshot = child as? DataSnapshot else { return }
                   let value = childSnapshot.value as? NSDictionary
                   let writterName = value?["닉네임"] as? String ?? ""
                   let commentDetail = value?["내용"] as? String ?? ""
                   let commentID = childSnapshot.key // 댓글의 ID

                   let fetchedCommentDetail = CommentEntity(commentDetail: commentDetail, commentWritter: writterName, commentID: commentID)
                   self.commentList.append(fetchedCommentDetail)
               }

               self.commentTableView.reloadData()
           }


            
    }
    
    @objc func tabbedAddcommentButton(){
        
        let commentRef = Database.database().reference().child("자유게시판").child("\(articleID ?? "")").child("댓글")
//
        commentRef.childByAutoId().setValue(["내용" : commentTextField.text,
                                             "닉네임" : mynickName])
        commentTextField.text = ""
//        

        print("댓글 등록 완료")
 
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications()
    }
    
    func setNickNameLabel(){
        
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nicknameLabel)
        NSLayoutConstraint.activate([
        
            nicknameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            nicknameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nicknameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        
        
        
        ])
        
        
    }
    
    
 
  
   
    
    func setTitleLabel(){
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
        
            titleLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
            
        
        ])
        
    }
    
    func setBorderLine(){
        
        borderLineView1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(borderLineView1)
        NSLayoutConstraint.activate([
        
            borderLineView1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            borderLineView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            borderLineView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            borderLineView1.heightAnchor.constraint(equalToConstant: 1)
            
            
        ])
    }
    
    func setHabitLabel(){
        
        
        habitLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(habitLabel)
        NSLayoutConstraint.activate([
        
            habitLabel.topAnchor.constraint(equalTo: borderLineView1.bottomAnchor, constant: 20),
            habitLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitLabel.heightAnchor.constraint(equalToConstant: 30)

        ])
        
    }
    
    func setTextView() {
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        NSLayoutConstraint.activate([
        
            textView.topAnchor.constraint(equalTo: habitLabel.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            textView.heightAnchor.constraint(equalToConstant: 200)
            
        ])
    }

    
    func setBorderLine2(){
        
        borderLineView2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(borderLineView2)
        NSLayoutConstraint.activate([
        
            borderLineView2.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            borderLineView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            borderLineView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            borderLineView2.heightAnchor.constraint(equalToConstant: 1)
            
            
        ])
    }

    func setCommentStackView() {
        
        view.addSubview(commentStackView)
        commentStackView.translatesAutoresizingMaskIntoConstraints = false
        commentWriteStackView.translatesAutoresizingMaskIntoConstraints = false
        commentTableView.translatesAutoresizingMaskIntoConstraints = false
        commentTableView.backgroundColor = UIColor.init(hexCode: "F8F7F3")
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        commentTextField.backgroundColor = .white
        addCommentButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        commentStackView.addArrangedSubview(commentTableView)
        commentStackView.addArrangedSubview(commentWriteStackView)
        
        
        
        commentWriteStackView.addArrangedSubview(commentTextField)
        commentWriteStackView.addArrangedSubview(addCommentButton)
        
        NSLayoutConstraint.activate([
            
        
            commentStackView.topAnchor.constraint(equalTo: borderLineView2.bottomAnchor, constant: 20),
            commentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            commentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            commentStackView.heightAnchor.constraint(equalToConstant: 200),
            commentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            commentWriteStackView.heightAnchor.constraint(equalToConstant: 50)
            
        
        ])
        
        
        
    }
    
    func updateUI(){
        
        if let titleText = titleText {
            
            titleLabel.text = titleText
        }
        
        if let habitText = habitText {
            
            habitLabel.text = habitText
        }
        
        if let detailText = detailText {
            
            textView.text = detailText
        }
        if let writterText = writterText {
            
            nicknameLabel.text = writterText
        }
        
    }
    
    
    func addKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // 노티피케이션을 제거하는 메서드
    func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 키보드가 나타났다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillShow(_ noti: NSNotification){
        // 키보드의 높이만큼 화면을 올려준다.
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y -= keyboardHeight
        }
    }

    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillHide(_ noti: NSNotification){
        // 키보드의 높이만큼 화면을 내려준다.
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y += keyboardHeight
        }
    }
 

    

}

extension ArticleDetailViewController: UITableViewDataSource {
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return commentList.count
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CommentTableViewCell

           let celldata: CommentEntity = commentList[indexPath.row]

           cell.nicknameLabel.text = celldata.commentWritter
           cell.commentDetailLabel.text = celldata.commentDetail // 댓글 내용 사용

           return cell
       }
   }

extension ArticleDetailViewController : UITableViewDelegate {
    
    
    
}









extension UIColor {
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}



// 프리뷰 보려고 스유로 래핑함.



struct ArticleDetailViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ArticleDetailViewController {
        return ArticleDetailViewController()
    }
    
    func updateUIViewController(_ uiViewController: ArticleDetailViewController, context: Context) {
        // 뷰 컨트롤러를 업데이트해야 하는 경우 업데이트합니다.
    }
}

struct ArticleDetailViewController_Preview: PreviewProvider {
    static var previews: some View {
        ArticleDetailViewControllerWrapper()
        
    }
}

