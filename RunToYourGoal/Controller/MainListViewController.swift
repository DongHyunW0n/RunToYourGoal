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
        
    
    let dataPath = ref.child("회원가입 유저")
    


    var userID : String = "UID"

    @IBOutlet weak var tableView: UITableView!
    
    var numbersOfGoals : Int?
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
      
        self.navigationItem.hidesBackButton = true
        
        self.showDefaultInformation()
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    

    @IBAction func addButton(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = storyboard.instantiateViewController(withIdentifier: "AddGoalModalViewController")
        self.present(viewcontroller, animated: true)
    
        
        
    }
    
    func showDefaultInformation() {
        
        print("UID Is \(userID)")
        print("Server time is \(getCurrentTime())")
        
    }

    

}

extension MainListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell") as! MainListCell
            
        
        
        cell.numberLabel.text = "1"
        cell.goalLabel.text = "다이어트"
        cell.selectionStyle = .none
                    
        
        return cell
        
        
    }
    
    
}

extension MainListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let targetView = CalendarViewController()
        

        self.navigationController?.pushViewController(targetView, animated: true)
    }
    
    
    
    
}
