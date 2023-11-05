//
//  GetFirstTimeTF.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 11/5/23.
//

import Foundation


//앱이 설치되고 첫번째 실행인지
public class GetFirstTimeTF {
    static func isFirstTime() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "isFirstTime") == nil {
            defaults.set("No", forKey:"isFirstTime")
            return true
        } else {
            return false
        }
        
    }
}
