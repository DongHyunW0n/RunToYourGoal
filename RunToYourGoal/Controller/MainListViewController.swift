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
  
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFirebaseData()
        
     

        self.title = "일일 목표 리스트"
        let originalImage = UIImage(systemName: "person.fill")
        let prosonFillImage = originalImage?.withRenderingMode(.alwaysOriginal)
        let rightBarButton = UIBarButtonItem(image: prosonFillImage  ,style: .plain, target: self, action: #selector(rightBarButtonTapped))
        
     
      
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = rightBarButton

        
        
        self.showDefaultInformation()
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    

    @IBAction func addButton(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = storyboard.instantiateViewController(withIdentifier: "AddGoalModalViewController")
        self.present(viewcontroller, animated: true)
    
        
        
    }
    
    @objc func rightBarButtonTapped() {
        
        let myPageView = MyPageViewController()
        self.navigationController?.pushViewController(myPageView, animated: true)
        print("우측 버튼 탭")
    
    }
    
    func showDefaultInformation() {
        
        print("UID Is \(userID)")
        print("Server time is \(getCurrentTime())")
        
    }
    
    func fetchFirebaseData() {
        let goalRef = ref.child("가입자 리스트").child("\(userID ?? "UID")").child("목표 리스트")
        goalRef.observe(.childAdded) { snapshot in
            if let goalData = snapshot.value as? [String: Any] {
                if let goal = goalData["목표"] as? String {
                    self.goalList.append(goal)
                    print("목표: \(goal)")
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    

}

extension MainListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if goalList.isEmpty {
            return 1
        }else{
            return goalList.count
        }

        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell") as! MainListCell
        
        if goalList.isEmpty {
            cell.goalLabel.text = "목표가 아직 없어요"
            cell.dateLabel.text = "오늘부터 시작 !"
        }else{
            cell.goalLabel.text = goalList[indexPath.row]

        }
        

        
        return cell
        
    }
 
    
}

extension MainListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let targetView = CalendarViewController()
        
        self.navigationController?.pushViewController(targetView, animated: true)
    }
    
    
    
    
}
