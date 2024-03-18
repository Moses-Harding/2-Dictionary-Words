//
//  String.swift
//  2 Dictionary Words
//
//  Created by Moses Harding on 3/2/24.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
    static func &+ (left: NSMutableAttributedString, right: NSMutableAttributedString) -> NSMutableAttributedString {
        left.append(right)
        return left
    }
    
    static func join(_ strings: NSMutableAttributedString ... ) -> NSMutableAttributedString {
        
        let result = NSMutableAttributedString()
        
        strings.forEach { result.append($0) }
        
        return result
    }
}

extension String {
    
    enum TextAttributes { case plain, italic }
    
    func asCGFloat() -> CGFloat? {
        
        if let newFloat = NumberFormatter().number(from: self) {
            let float = CGFloat(truncating: newFloat)
            return float
        }
        return nil
    }
    
    func asInt() -> Int? {
        if let newInt = NumberFormatter().number(from: self) {
            let int = Int(truncating: newInt)
            return int
        }
        return nil
    }
    
    func asMutableAttributedString(_ type: TextAttributes = .plain, weight: UIFont.Weight = .regular, size: CGFloat = 16, color: UIColor = .black) -> NSMutableAttributedString {
        
        var attributes: [NSAttributedString.Key: Any]
        
        let font = UIFont.systemFont(ofSize: size, weight: weight)

        switch type {
        case .plain:
            attributes = [.font: font, .foregroundColor: color]
        case .italic:
            let italicFontDescriptor = font.fontDescriptor.withSymbolicTraits(.traitItalic)
            
            attributes = [.font: UIFont(descriptor: italicFontDescriptor!, size: size), .foregroundColor: color]
        }
        
        let newString = NSMutableAttributedString(string: self, attributes: attributes)
        
        return newString
    }
    
    func asAttributedString(with font: UIFont?, color: UIColor) -> AttributedString {
        var attributes: [NSAttributedString.Key: Any]

        
        attributes = [.font: font ?? UIFont.systemFont(ofSize: 16), .foregroundColor: color]
        

        let newString = AttributedString(self, attributes: AttributeContainer(attributes))
        
        return newString
    }

    func vulgarFractionToDecimal() -> CGFloat? {
        switch self {
        case "½": return 0.5
        case "⅓": return 1.0 / 3.0
        case "⅔": return 2.0 / 3.0
        case "¼": return 0.25
        case "¾": return 0.75
        case "⅕": return 0.2
        case "⅖": return 0.4
        case "⅗": return 0.6
        case "⅘": return 0.8
        case "⅙": return 1.0 / 6.0
        case "⅚": return 5.0 / 6.0
        case "⅐": return 1.0 / 7.0
        case "⅛": return 1.0 / 8.0
        case "⅜": return 3.0 / 8.0
        case "⅝": return 5.0 / 8.0
        case "⅞": return 7.0 / 8.0
        default: return nil
        }
    }
    
    func regularFractionToDecimal() -> CGFloat? {
        var components = self.components(separatedBy: "/")
        if let quantityString = components.first, let newFloat = NumberFormatter().number(from: quantityString) {
            var first = CGFloat(truncating: newFloat)
            components.removeFirst()
            if let secondQuantityString = components.first, let secondFloat = NumberFormatter().number(from: secondQuantityString) {
                var second = CGFloat(truncating: secondFloat)
                
                return first / second
            }
        }
        return nil
    }
    
    func startsWithNumber() -> CGFloat? {
        var components = self.components(separatedBy: .whitespaces)
        if let quantityString = components.first, let newFloat = NumberFormatter().number(from: quantityString) {
            return CGFloat(truncating: newFloat)
        } else if let quantityString = components.first, let quantity = quantityString.vulgarFractionToDecimal() {
            return quantity
        } else if let quantityString = components.first, let quantity = quantityString.regularFractionToDecimal() {
            return quantity
        }
        
        return nil
    }
    
    func removeNonAlphanumericCharacters() -> String {
        // Use regular expression to remove non-alphanumeric characters
        let regex = try! NSRegularExpression(pattern: "[^a-zA-Z0-9]", options: .caseInsensitive)
        let range = NSRange(location: 0, length: self.utf16.count)
        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
    }
    
    func removeNonAlphanumericCharactersExceptWhitespace() -> String {
        // Use regular expression to remove non-alphanumeric characters
        let regex = try! NSRegularExpression(pattern: "[^a-zA-Z0-9\\s\\u00BC-\\u00BE\\u2150-\\u215E]", options: .caseInsensitive)
        let range = NSRange(location: 0, length: self.utf16.count)
        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
    }
    
    func removeNonAlphanumericPrefix() -> String {
        var resultString = self
        
        if let firstCharacter = resultString.first, !firstCharacter.isLetter && !firstCharacter.isNumber {
            resultString.removeFirst()
        }
        
        return resultString
    }
    
    func asBulletPoint(color: UIColor, size: CGFloat, indentSize: CGFloat = 30, indentedTab: Bool = false) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = indentSize
        paragraphStyle.minimumLineHeight = 18
        paragraphStyle.maximumLineHeight = 18
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: indentSize)]

        let stringAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: size),
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]

        let string = indentedTab ? "\t•  \(self)" : "•\t\(self)"

        return NSAttributedString(string: string,
                                  attributes: stringAttributes)
    }
}

extension NSMutableAttributedString {
    
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
    
        return ceil(boundingBox.height)
    }
}
