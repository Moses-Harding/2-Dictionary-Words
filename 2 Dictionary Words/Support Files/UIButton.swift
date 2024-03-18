//
//  UIButton.swift
//  2 Dictionary Words
//
//  Created by Moses Harding on 3/2/24.
//

import Foundation
import UIKit

protocol UIMenuButtonDelegate: AnyObject {
    func didTriggerMenuAction(button: UIMenuButton)
}

class UIMenuButton: UIButton {
    weak var delegate: UIMenuButtonDelegate?
    
    convenience init(menu: UIMenu) {
        self.init(type: .custom)
        self.showsMenuAsPrimaryAction = true
        self.menu = menu
    }
    
    override func sendActions(for controlEvents: UIControl.Event) {
        super.sendActions(for: controlEvents)
        if controlEvents.contains(.menuActionTriggered) {
            delegate?.didTriggerMenuAction(button: self)
        }
    }
}


extension UIButton.Configuration {

    public static func delete(title: String = "Delete") -> UIButton.Configuration {
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.baseBackgroundColor = .red.withAlphaComponent(0.5)
        buttonConfig.cornerStyle = .medium
        buttonConfig.baseForegroundColor = .white
        buttonConfig.attributedTitle = title.asAttributedString(with: UIFont.systemFont(ofSize: 16), color: .white)
        
        return buttonConfig
    }
     
    public static func cancel(title: String = "Cancel", color: UIColor? = nil) -> UIButton.Configuration {
        
        var buttonConfig = UIButton.Configuration.bordered()
        buttonConfig.baseBackgroundColor = .white
        buttonConfig.cornerStyle = .medium
        buttonConfig.baseForegroundColor = color ?? .red
        buttonConfig.background.strokeColor = color ?? .red
        buttonConfig.attributedTitle = title.asAttributedString(with: UIFont.systemFont(ofSize: 16), color: color ?? .red)
        
        return buttonConfig
    }
    
    public static func outline(title: String, color: UIColor? = nil) -> UIButton.Configuration {

        // Configure the button
        var buttonConfig = UIButton.Configuration.bordered()
        buttonConfig.baseBackgroundColor = .white
        buttonConfig.cornerStyle = .medium
        buttonConfig.baseForegroundColor = Colors.primaryRed
        buttonConfig.baseBackgroundColor = .white
        buttonConfig.background.strokeColor = .white
        buttonConfig.attributedTitle = title.asAttributedString(with: UIFont.boldSystemFont(ofSize: 16), color: Colors.primaryRed)
        
        return buttonConfig
    }
    
    public static func filled(title: String, color: UIColor? = nil) -> UIButton.Configuration {

        // Configure the button
        var buttonConfig = UIButton.Configuration.bordered()
        buttonConfig.baseBackgroundColor = color ?? Colors.primaryRed
        buttonConfig.cornerStyle = .medium
        buttonConfig.baseForegroundColor = .white
        buttonConfig.attributedTitle = title.asAttributedString(with: UIFont.systemFont(ofSize: 16), color: .white)
        
        return buttonConfig
    }
    
    public static func image(systemName: String, pointSize: CGFloat? = nil, colors: [UIColor]) -> UIButton.Configuration {
        
        let pointSize = pointSize ?? 24

        let imageConfig = UIImage.SymbolConfiguration(pointSize: pointSize).applying(UIImage.SymbolConfiguration(paletteColors: colors))
        let image = UIImage(systemName: systemName, withConfiguration: imageConfig)
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.baseBackgroundColor = .clear
        buttonConfig.cornerStyle = .medium
        buttonConfig.image = image
        
        return buttonConfig
    }
}
