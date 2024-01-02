//
//  BoardMainListViewController.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 11/29/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

struct ArticleEntity {
    
    var refid : String
    var title : String
    var writter : String
    var goal : String
    var detail : String
    var uid : String

}




class BoardMainListViewController: UIViewController {
    
    let ref = Database.database().reference()
    
    var articleList : [ArticleEntity] = []
    
    var myNickname1 : String?

    @IBOutlet weak var WriteButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    //해야할것들
    // 1. 리얼타임 디비에 게시판필드에 연결
    // 2. 셀 디자인 뭐 간단하게라도
    // 3.
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        
        let boardRef = ref.child("자유게시판")
        
        boardRef.observe(.value) { DataSnapshot in
            
            self.articleList = []
            
            for child in DataSnapshot.children {
                
                guard let childSnapShot = child as? DataSnapshot else{return}
                let value = childSnapShot.value as? NSDictionary
                let title = value?["제목"] as? String ?? ""
                let writter = value?["닉네임"] as? String ?? ""
                let goal = value?["목표"] as? String ?? "No Habit Selected"
                let detail = value?["내용"] as? String ?? ""
                let uid = value?["uid"] as? String ?? ""
                
                let fetchedArticle = ArticleEntity(refid: childSnapShot.key, title: title, writter: writter, goal: goal, detail: detail, uid: uid)
                self.articleList.append(fetchedArticle)
                
            }
            
            self.tableView.reloadData()

                    
        }
        
        let commentRef = boardRef.child("댓글")
        
        commentRef.observe(.value) { DataSnapshot in
            
            commentRef.observeSingleEvent(of: .value) { DataSnapshot in
                
                let commentCount = DataSnapshot.childrenCount
                
                print("댓글 개수: \(commentCount)")
                
                
            }
            self.tableView.reloadData()
            
            
            
        }
        
        
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getNickNameFromServer()
        

    }
    
    
    private func fetchCommentCount(for articleID: String, completion: @escaping (Int) -> Void) {
         let commentRef = ref.child(articleID).child("댓글")
         
         commentRef.observeSingleEvent(of: .value) { snapshot in
             let commentCount = Int(snapshot.childrenCount)
             completion(commentCount)
         }
     }

    func getNickNameFromServer() {
        
        let uid = Auth.auth().currentUser?.uid
        let userRef = ref.child("가입자 리스트").child("\(uid ?? "UID")")
        
        userRef.observeSingleEvent(of: .value) { snapshot in
            if let value = snapshot.value as? [String: Any] {
                let nickName = value["닉네임"] as? String ?? "닉네임"
                self.myNickname1 = nickName
            }
        }
        
    }

}


extension BoardMainListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? BoardMainListCell else{return UITableViewCell()}
        
        print("저장된 글의 개수: \(articleList.count)")
        if articleList.isEmpty {
              // articleList가 비어 있는 경우, 기본값을 설정
              cell.titleLabel.text = "기본 제목"
              cell.writterLabel.text = "기본 작성자"
              cell.commentCountLabel.text = "0" // 댓글 수를 0으로 설정하거나 원하는 기본값으로 설정
          } else {
              // articleList에 데이터가 있는 경우, 정상적으로 값을 설정
              let celldata: ArticleEntity = articleList[indexPath.row]
              cell.titleLabel.text = celldata.title
              cell.writterLabel.text = celldata.writter
              fetchCommentCount(for: celldata.refid) { commentCount in
                  // 댓글 수 업데이트
                  cell.commentCountLabel.text = "\(commentCount)"
              }
          }

        cell.selectionStyle = .none
        
        
        
        
        return cell
        
    }
    
    
    
    
}

extension BoardMainListViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let celldata : ArticleEntity = articleList[indexPath.row]
        
        let detailVC = ArticleDetailViewController()
        
        detailVC.titleText = celldata.title
        detailVC.habitText = celldata.goal
        detailVC.writterText = celldata.writter
        detailVC.detailText = celldata.detail
        detailVC.articleID = celldata.refid
        detailVC.mynickName = myNickname1
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        

    }
    
    
    
    
}
