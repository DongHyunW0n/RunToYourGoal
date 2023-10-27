
//
//  CalendarViewController.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 2023/10/19.
//

import UIKit
import SwiftUI
import SnapKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {

    // FSCalendar 인스턴스 생성
    let calendar = FSCalendar() //FS 캘린더
    let titleLabel = UILabel()
    let todayTitleLabel = UILabel()
    let checkStackView = UIStackView()
    let didButton = UIButton()
    let didnotButton = UIButton()
   




    
    
    let backgroundColor = UIColor(
        red: CGFloat(0xF8) / 255.0,
        green: CGFloat(0xF7) / 255.0,
        blue: CGFloat(0xF3) / 255.0,
        alpha: 1.0
    )
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        

        
      
        
        // FSCalendar 설정
        calendar.delegate = self
        calendar.dataSource = self
        calendar.locale = Locale(identifier: "ko_KR")

        
        
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.text = "일일체크 & 세부사항"
        titleLabel.textAlignment = .center
        
        
        todayTitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        todayTitleLabel.textColor = .black
        todayTitleLabel.textAlignment = .center
        todayTitleLabel.text = "오늘은 목표를 달성했나요?"
        
        
        didButton.setImage(UIImage(named: "successbutton"), for: .normal)
        didButton.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)

        didnotButton.setImage(UIImage(named: "failbutton"), for: .normal)
        didnotButton.addTarget(self, action: #selector(didnotButtonTapped), for: .touchUpInside)

        
        
        checkStackView.axis = .horizontal
        checkStackView.distribution = .fillEqually
        

        
        
        view.backgroundColor = backgroundColor
        view.addSubview(calendar)
        view.addSubview(titleLabel)
        view.addSubview(todayTitleLabel)
        view.addSubview(checkStackView)
        checkStackView.addArrangedSubview(didButton)
        checkStackView.addArrangedSubview(didnotButton)


        titleLabel.snp.makeConstraints { make in
            
            make.top.equalToSuperview().inset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        
            
        }
        calendar.snp.makeConstraints { make in
            
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
        
        
        todayTitleLabel.snp.makeConstraints { make in
            
            make.top.equalTo(calendar.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            
        }
        
        checkStackView.snp.makeConstraints { make in
            
            make.top.equalTo(todayTitleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(50)
            
        }

    }
    
    @objc func didButtonTapped() {
        areYouSureAlert()

     }
     
    
    @objc func didnotButtonTapped() {
        areYouSureAlert()
    
    }
    
    func areYouSureAlert() -> () {
        
        let alert = UIAlertController(title: "확인", message:"정말 평가하시겠습니까? \n 평가는 되돌릴 수 없습니다.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "네", style: .default) { UIAlertAction in
            self.changeButtonStatus()
            self.doneAlert()
        }
        let cancelButton = UIAlertAction(title: "아니요", style: .cancel)
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        
        
        present(alert, animated: true)
        
        
        
        
        
        
    }
    
    
    
    func doneAlert()->() {
        
        let alert = UIAlertController(title: "평가 완료", message: "평가가 완료되었습니다. 내일도 화이팅 !", preferredStyle: .actionSheet)
        let cancelbutton = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(cancelbutton)
        present(alert, animated: true)
  
    }
    
    func changeButtonStatus() {
        
        didButton.isEnabled = false
        didnotButton.isEnabled = false
        
    }
    
    
  
    
  
    
}

struct CalendarViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CalendarViewController {
        return CalendarViewController()
    }

    func updateUIViewController(_ uiViewController: CalendarViewController, context: Context) {
        // 뷰 컨트롤러를 업데이트해야 하는 경우 업데이트합니다.
    }
}

struct CalendarViewController_Preview: PreviewProvider {
    static var previews: some View {
        CalendarViewControllerWrapper()
        
    }
}
