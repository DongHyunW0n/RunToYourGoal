
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
import FirebaseDatabase
import FirebaseAuth


class CalendarViewController: UIViewController {
    
    var successDict: [String: String] = [:]


    let calendar = FSCalendar()
    let todayTitleLabel = UILabel()
    let checkStackView = UIStackView()
    let didButton = UIButton()
    let didnotButton = UIButton()
    let customTitleView = UIView()
    let titleLabel = UILabel()
    var currentGoalName : String = ""
    let startDay = UILabel()

    var startDate : String = ""
    

   
    
    let dateFormatter: DateFormatter = {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd"
           return dateFormatter
       }()

    let uid = Auth.auth().currentUser?.uid
    
    
    

    
    
    var dateList : [String] = []
    
    let backgroundColor = UIColor(
        red: CGFloat(0xF8) / 255.0,
        green: CGFloat(0xF7) / 255.0,
        blue: CGFloat(0xF3) / 255.0,
        alpha: 1.0
    )
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
      print("현재 페이지의 목표는 : \(currentGoalName)")

        print("시작일 : \(startDate)")
   
//        프리뷰 보려면 여기서부터

        let goalRef = ref.child("가입자 리스트").child(uid ?? "").child("목표 리스트").child(currentGoalName).child("성공 여부")

//         성공 여부 딕셔너리를 읽어오기
        goalRef.observe(.value) { [weak self] (snapshot) in
            if let successDict = snapshot.value as? [String: String] {
             
                self?.successDict = successDict
                self?.calendar.reloadData()
            }
        }
      
        //이거 위에까지 주석처리

    

        

        view.addSubview(customTitleView)
        titleLabel.text = "\(currentGoalName)"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "SOYO Maple Bold", size: 25)
        titleLabel.adjustsFontSizeToFitWidth = true
        

     

        customTitleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(customTitleView)
        }
      
        
        // FSCalendar 설정
        calendar.delegate = self
        calendar.dataSource = self
        calendar.locale = Locale(identifier: NSLocalizedString("en_US", comment: ""))
        calendar.appearance.headerDateFormat = NSLocalizedString("MMM-yyyy", comment: "")
//        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
//        calendar.backgroundColor = UIColor(red: 241/255, green: 249/255, blue: 255/255, alpha: 1)
        calendar.allowsSelection = false
        calendar.appearance.titleWeekendColor = .red
        
        
        if isEvaluationDoneToday() {
               didButton.isEnabled = false
               didnotButton.isEnabled = false
           }
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDateString = dateFormatter.string(from: currentDate)

        func isEvaluationDoneToday() -> Bool {
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let todayDateString = dateFormatter.string(from: currentDate)
            
            if let selectedDate = calendar.selectedDate {
                let selectedDateString = dateFormatter.string(from: selectedDate)
                
                return selectedDateString == todayDateString
            }
            
            return false
        }

      
        
        
        

        
        todayTitleLabel.font = UIFont(name: "SOYO Maple Regular", size: 25)
        todayTitleLabel.textColor = .black
        todayTitleLabel.textAlignment = .center
        todayTitleLabel.text = NSLocalizedString("Did you keep this habit today?", comment: "")
        todayTitleLabel.adjustsFontSizeToFitWidth = true
        
       

        
        
        
        didButton.setImage(UIImage(named: "successbutton"), for: .normal)
        didButton.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)

        didnotButton.setImage(UIImage(named: "failbutton"), for: .normal)
        didnotButton.addTarget(self, action: #selector(didnotButtonTapped), for: .touchUpInside)

        
        
        checkStackView.axis = .horizontal
        checkStackView.distribution = .fillEqually
        
        
        

        
        
        view.backgroundColor = backgroundColor
        view.addSubview(calendar)
        view.addSubview(todayTitleLabel)
        view.addSubview(checkStackView)
        checkStackView.addArrangedSubview(didButton)
        checkStackView.addArrangedSubview(didnotButton)
        
        
        
        
        //Set Constraints
        
        
        customTitleView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
        }


        calendar.snp.makeConstraints { make in
            
            make.top.equalTo(customTitleView.snp.bottom).offset(30)
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
//            make.bottom.equalToSuperview().inset(80)
            
            
        }
        
      

    }
    
    @objc func didButtonTapped() {
        YesAreYouSureAlert()

     }
     
    
    @objc func didnotButtonTapped() {
        NoAreYouSureAlert()
    
    }
    
 

  
    func YesAreYouSureAlert() -> () {
        
        let alert = UIAlertController(title: "", message: NSLocalizedString("Would you like to evaluate? Evaluations can only be edited on the same day", comment: ""), preferredStyle: .alert)
        let okButton = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { UIAlertAction in
            self.setValueOnDatebase()
            self.SuccessdoneAlert()
        }
        let cancelButton = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel)
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        present(alert, animated: true)

    }
    
    func NoAreYouSureAlert() -> () {
        
        let alert = UIAlertController(title: "", message: NSLocalizedString("Would you like to evaluate? Evaluations can only be edited on the same day", comment: ""), preferredStyle: .alert)
        let okButton = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { UIAlertAction in
            self.setValueOnDatebaseNo()
            self.FaildoneAlert()
            
        }
        let cancelButton = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel)
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        present(alert, animated: true)

    }
    
    
    
    func SuccessdoneAlert()->() {
        
        let alert = UIAlertController(title: NSLocalizedString("Done", comment: ""), message: NSLocalizedString("Well done today", comment: ""), preferredStyle: .alert)
        let cancelbutton = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel)
        alert.addAction(cancelbutton)
        present(alert, animated: true)
        calendar.reloadData()
    }
    
    func FaildoneAlert()->() {
        
        let alert = UIAlertController(title: NSLocalizedString("Done", comment: ""), message: NSLocalizedString("Let's achieve it tomorrow!", comment: ""), preferredStyle: .alert)
        let cancelbutton = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel)
        alert.addAction(cancelbutton)
        present(alert, animated: true)
        calendar.reloadData()
    }
    
    func setValueOnDatebase() {
        let currentDate = getCurrentTime()
        let goalRef = ref.child("가입자 리스트").child(uid ?? "UID").child("목표 리스트").child(currentGoalName).child("성공 여부")
        goalRef.updateChildValues([currentDate: "O"])
    }
    
    func setValueOnDatebaseNo() {
        let currentDate = getCurrentTime()
        let goalRef = ref.child("가입자 리스트").child(uid ?? "UID").child("목표 리스트").child(currentGoalName).child("성공 여부")
        goalRef.updateChildValues([currentDate: "X"])
    }
}

extension CalendarViewController : FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    

    
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        if let success = successDict[dateString], success == "O" {
            return NSLocalizedString("O", comment: "")
        } else if let success = successDict[dateString], success == "X" {
            // 실패한 경우
            return NSLocalizedString("X", comment: "")
        }
        
        return nil
        
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        if let success = successDict[dateString], success == "O" {
            // 성공한 경우
            return .green
        } else if let success = successDict[dateString], success == "X" {
            // 실패한 경우
            return .red
        }
        
      
        return nil
    }
    
    func getCheckStatusForDate(_ date: Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        if let success = successDict[dateString], success == "O" {
            return true
        }
        
        return false
    }

    func calendar(_ calendar: FSCalendar, hasEventFor date: Date) -> Bool {
        return getCheckStatusForDate(date)
    }

    
}


// 프리뷰 보려고 스유로 래핑함.

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
