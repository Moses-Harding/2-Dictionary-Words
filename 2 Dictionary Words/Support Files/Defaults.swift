//
//  Defaults.swift
//  2 Dictionary Words
//
//  Created by Moses Harding on 3/2/24.
//

import Foundation
import UIKit

typealias Action = (()->())

struct Colors {
    static var primaryRed = UIColor(red: 0.96, green: 0.26, blue: 0.21, alpha: 1.00)
    static var primaryGray = UIColor.init(white: 0.2, alpha: 1)
    static var secondaryGray = UIColor.init(white: 0.5, alpha: 1)
}

struct Fonts {
    static var title = UIFont.systemFont(ofSize: DeviceManager.largestSize)
    static var italicTitle = UIFont.italicSystemFont(ofSize: DeviceManager.largestSize)
    static var sectionTitle = UIFont.systemFont(ofSize: DeviceManager.secondLargestSize)
    //static var secondaryTitle = UIFont.systemFont(ofSize: 20)
    static var main = UIFont.systemFont(ofSize: DeviceManager.regularSize)
    static var sub = UIFont.systemFont(ofSize: DeviceManager.smallSize)
}
