//
//  MainListViewController.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 2023/09/13.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import RxSwift






class MainListViewController: UIViewController {
        
    

    let ref = Database.database().reference()


    var userID = Auth.auth().currentUser?.uid

    @IBOutlet weak var tableView: UITableView!
    
    var numbersOfGoals : Int?
    
  

    var goalList: [String] = []
    var dateList: [String] = []

  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFirebaseDateData()
        fetchFirebaseGoalData()

//        self.title = NSLocalizedString("Daily habit list", comment: "")
        self.navigationItem.hidesBackButton = true
        self.showDefaultInformation()
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: "MainListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        let originalImage = UIImage(named: "person")
        let prosonFillImage = originalImage?.withRenderingMode(.alwaysOriginal)
     
        let rightBarButton = UIBarButtonItem(image: prosonFillImage, style: .plain, target: self, action: #selector(rightBarButtonTapped))
        rightBarButton.image?.withRenderingMode(.alwaysTemplate) // 이미지 렌더링 모드 변경
        self.navigationItem.rightBarButtonItem = rightBarButton
       
        
    }
    

    @IBAction func addButton(_ sender: UIButton) {
        
        let viewcontroller = AddViewController()
        self.present(viewcontroller, animated: true)
    
        
        
    }
    
    @objc func rightBarButtonTapped() {
        
        let myPageView = MyPageViewController()
        self.navigationController?.pushViewController(myPageView, animated: true)
        print("우측 버튼 탭")
    
    }
    
    func showDefaultInformation() {
        
        print("메인리스트 화면")
        print("UID Is \(userID ?? "")")
        print("Server time is \(getCurrentTime())")
        
    }
    
    func fetchFirebaseGoalData() {
        let goalRef = ref.child("가입자 리스트").child("\(userID ?? "UID")").child("목표 리스트")
        goalRef.observe(.childAdded) { snapshot in
            if let goalData = snapshot.value as? [String: Any] {
                if let goal = goalData["목표"] as? String {
                    self.goalList.append(goal)
                    print("목표명: \(goal)")
                    
                    DispatchQueue.main.async {
                        self.tableView?.reloadData()
                    }
                }
            }
        }
    }
    
    func fetchFirebaseDateData() {
        let goalRef = ref.child("가입자 리스트").child("\(userID ?? "UID")").child("목표 리스트")
        goalRef.observe(.childAdded) { snapshot in
            if let goalData = snapshot.value as? [String: Any] {
                if let goal = goalData["시작일"] as? String {
                    self.dateList.append(goal)
                    print("목표 설정일: \(goal)")
                    
                    DispatchQueue.main.async {
                        self.tableView?.reloadData()
                    }
                }
            }
        }
    }

    

}

extension MainListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return goalList.count

        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? MainListCell else {
            return UITableViewCell()
        }

        if goalList.isEmpty {
            cell.goalLabel.text = "목표가 아직 없어요"
            cell.dateLabel.text = "오늘부터 시작 !"
        } else {
            cell.goalLabel.text = goalList[indexPath.row]
//            cell.dateLabel.text = "\(dateList[indexPath.row])"+"\(NSLocalizedString(" start", comment: ""))"
        }

        cell.selectionStyle = .none
//        cell.backgroundColor = UIColor.clear

        return cell
        
    }
 
    
}

extension MainListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let targetView = CalendarViewController()
        if goalList.isEmpty {
            print("저장된 목표 아직 없음.")
            return
        }else{
            targetView.currentGoalName = goalList[indexPath.row]
            targetView.startDate = dateList[indexPath.row]

            self.navigationController?.pushViewController(targetView, animated: true)
        }
            
        
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "", message: NSLocalizedString("Are you sure you want to delete this goal? Deleted goals cannot be recovered.", comment: ""), preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive) { [weak self] _ in
                self?.deleteGoalFromFirebase(at: indexPath)
            }
            let cancelAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel)
            
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
        }
    }

    func deleteGoalFromFirebase(at indexPath: IndexPath) {
        let goalRef = ref.child("가입자 리스트").child("\(userID ?? "UID")").child("목표 리스트")
        let goalToDelete = goalList[indexPath.row] // 삭제할 목표
        
        goalRef.queryOrdered(byChild: "목표").queryEqual(toValue: goalToDelete).observeSingleEvent(of: .childAdded) { snapshot in
            snapshot.ref.removeValue { [weak self] error, _ in
                if let error = error {
                    print("데이터 삭제 중 오류 발생: \(error)")
                } else {
                    print("데이터가 성공적으로 삭제되었습니다.")
                    self?.goalList.remove(at: indexPath.row)
                    self?.dateList.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
}
