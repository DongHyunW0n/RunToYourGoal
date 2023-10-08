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
    
    
    var userID : String = "UID"

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("UID Is \(userID)")

        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }
    

    @IBAction func addButton(_ sender: UIButton) {
        
        
        
        
        
        
        
        
    }
    

}
