//
//  GoalDetailViewController.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 2023/10/18.
//

import UIKit
import SnapKit
import SwiftUI

class GoalDetailViewController: UIViewController {
    
    let backgroundColor = UIColor(
        red: CGFloat(0xF8) / 255.0,
        green: CGFloat(0xF7) / 255.0,
        blue: CGFloat(0xF3) / 255.0,
        alpha: 1.0
    )


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIView 생성
        let myView = UIView()
        myView.backgroundColor = backgroundColor
        view.addSubview(myView)
        
        // UIView에 SnapKit을 사용하여 제약 조건을 설정합니다.
        myView.snp.makeConstraints { (make) in
           
            make.edges.equalToSuperview()
            
            

        
        }
    
        
        let myLabel = UILabel()
        myLabel.text = "세부 목표"
        myView.addSubview(myLabel)
        
        myLabel.textColor = .black
        myLabel.textAlignment = .center
        myLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        myLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
       
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        myView.addSubview(tableView)
        tableView.backgroundColor = .darkGray
        tableView.snp.makeConstraints { make in
            make.top.equalTo(myLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(myView).inset(20)
            make.bottom.equalToSuperview().inset(200)
            
            
        }
        
        let okButton = UIButton()
        let image = UIImage(named: "nextbutton")
        okButton.setImage(image, for: .normal)
        myView.addSubview(okButton)
        
        okButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(30)
            make.leading.trailing.equalTo(myView).inset(20)
            make.bottom.equalToSuperview().inset(50)
        }
        
        
    
     
    }
    

   
}

struct GoalDetailViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> GoalDetailViewController {
        // 여기에서 GoalDetailViewController를 필요하다면 인스턴스화합니다.
        return GoalDetailViewController()
    }

    func updateUIViewController(_ uiViewController: GoalDetailViewController, context: Context) {
        // 뷰 컨트롤러를 업데이트해야 하는 경우 업데이트합니다.
    }
}

struct GoalDetailViewController_Preview: PreviewProvider {
    static var previews: some View {
        GoalDetailViewControllerWrapper()
    }
}

extension GoalDetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    
}

extension GoalDetailViewController : UITableViewDelegate {
    
    
}
