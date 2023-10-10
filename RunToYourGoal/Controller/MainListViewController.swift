//
//  MainListViewController.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 2023/09/13.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth





class MainListViewController: UIViewController {
    
    var ref = Database.database().reference()

    var userID : String = "UID"

    @IBOutlet weak var tableView: UITableView!
    
    
    var numbersOfGoals : Int?
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("UID Is \(userID)")

        self.navigationItem.hidesBackButton = true
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    

    @IBAction func addButton(_ sender: UIButton) {
        
        
        
        
        
        
        
        
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
    
    
    
}
