//
//  GetCurrentTIme.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 2023/10/23.
//

import Foundation


func getCurrentTime() -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let currentDate = dateFormatter.string(from: Date())
    
    return currentDate

    
}
