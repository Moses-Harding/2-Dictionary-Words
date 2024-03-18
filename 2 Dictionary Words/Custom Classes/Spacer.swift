//
//  Spacer.swift
//  2 Dictionary Words
//
//  Created by Moses Harding on 3/6/24.
//

import Foundation
import UIKit

class Spacer: UIView {
    
    enum SpacerAxis { case vertical, horizontal }
    init(_ size: CGFloat, _ axis: SpacerAxis, color: UIColor? = nil) {
        super.init(frame: .zero)
        
        switch axis {
        case .horizontal:
            self.widthAnchor.constraint(equalToConstant: size).isActive = true
        case .vertical:
            self.heightAnchor.constraint(equalToConstant: size).isActive = true
        }
        
        if let color = color {
            self.backgroundColor = color
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

