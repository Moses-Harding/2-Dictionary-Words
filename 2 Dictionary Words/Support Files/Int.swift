//
//  Int.swift
//  2 Dictionary Words
//
//  Created by Moses Harding on 3/8/24.
//

import Foundation

extension Int {
    
    func asTimeString() -> String {
        
        let minutes = self / 60
        let seconds = self % 60
        let secondsString = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        let minutesString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        
        
        return "\(minutes):\(secondsString)"
    }
}
