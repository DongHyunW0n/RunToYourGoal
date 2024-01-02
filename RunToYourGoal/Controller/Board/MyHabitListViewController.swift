//
//  MyHabitListViewController.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 12/5/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import RxSwift

protocol sendUpdateDelegate {
    
    func sendUpdate(habit : String)
}


class MyHabitListViewController: UIViewController {
    
    var goalList: [String] = []
    var delegate: sendUpdateDelegate?
 
    private var disposebag = DisposeBag()

    

    let ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    
    var selectedHabitName : String?
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchFirebaseGoalData()

        tableView.dataSource = self
        tableView.delegate = self
        
        print("goalListCount : \(goalList.count)")
        print("UID is \(userID)")
 
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
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
    
    @IBAction func selectedButtonTabbed(_ sender: Any) {
        
        if let habit = selectedHabitName{
            delegate?.sendUpdate(habit: habit)
            print("선택된 습관은 :\(habit)")
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

extension MyHabitListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return goalList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MyHabitListCell else{
            return UITableViewCell()
            
            
        }
        
        if goalList.isEmpty {
            cell.habitLabel.text = "Please save your habit."
        }else{
            cell.habitLabel.text = goalList[indexPath.row]
        }
        
        
        return cell
        
    }
    
    
}

extension MyHabitListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedHabitName = goalList[indexPath.row]
       
    }
}

