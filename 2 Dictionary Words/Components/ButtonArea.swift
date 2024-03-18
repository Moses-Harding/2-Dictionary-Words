//
//  ButtonArea.swift
//  2 Dictionary Words
//
//  Created by Moses Harding on 3/7/24.
//

import Foundation
import UIKit

class ButtonArea: UIView {
    
    var words = [ActionWord]()
    
    var displayArea = UIStackView(.vertical, spacing: 5, distribution: .fillEqually)
    
    var bottomTextConstraint: NSLayoutConstraint?

    init() {
        
        super.init(frame: .zero)
        
        //self.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        self.constrain(displayArea)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // This function updates the display area with buttons based on an array of words.
    func updateDisplayArea() {
        
        // Remove all existing subviews from the display area
        displayArea.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Create a new horizontal stack view to hold buttons with a spacing of 3 points and equal distribution of space
        let newView = UIStackView(.horizontal, spacing: 3, distribution: .fill)
        
        // Create a spacer view to fill extra space in the stack view
        let spacerView = UIView()
        
        // Initialize arrays to hold subviews and spacer views
        var subViews = [newView]
        var spacerViews = [spacerView]
        
        // Initialize index for the current subview
        var currentSubViewIndex = 0
        
        // Add the initial stack view to the display area
        displayArea.addArrangedSubview(newView)
        
        // Initialize an array to hold buttons
        var buttons = [UIView]()
        
        // Loop through each word in the words array
        for word in words {
                    
            // Get the current subview and spacer view
            let currentSubView = subViews[currentSubViewIndex]
            let currentSpacerView = spacerViews[currentSubViewIndex]
            
            let button = UIButton()
            let label = UILabel()
            
            if word.hasAction {
                
                // Configure the button with the word and its action
                var config = UIButton.Configuration.plain()
                config.titleLineBreakMode = .byTruncatingTail
                config.title = word.word
                config.titlePadding = 0
                config.contentInsets = NSDirectionalEdgeInsets.zero
                button.configuration = config
                button.addAction(UIAction() { _ in word.action() }, for: .touchUpInside)
                
                // Append the button to the buttons array
                buttons.append(button)

                // Add the button to the current subview
                currentSubView.addArrangedSubview(button)
            } else {
                label.text = word.word
                
                // Add the button to the current subview
                currentSubView.addArrangedSubview(label)
            }

            
            // Calculate the width of the current subview and the display area
            let subViewWidth = currentSubView.systemLayoutSizeFitting(CGSize(width: UIView.layoutFittingCompressedSize.width, height: 40), withHorizontalFittingPriority: .sceneSizeStayPut, verticalFittingPriority: .required).width
            let displayAreaWidth = displayArea.frame.width
            // If the width of the subview exceeds the width of the display area
            if subViewWidth >= displayAreaWidth && currentSubView.arrangedSubviews.count > 1 {
                
                if word.hasAction {
                    // Remove the button from the current subview
                    currentSubView.removeArrangedSubview(button)
                } else {
                    currentSubView.removeArrangedSubview(label)
                }
                
                // Create a new horizontal stack view and spacer view
                let newView = UIStackView(.horizontal, spacing: 3, distribution: .fill)
                subViews.append(newView)
                
                let spacerView = UIView()
                spacerViews.append(spacerView)
                
                // Add the button and spacer view to the new stack view
                if word.hasAction {
                    // Remove the button from the current subview
                    newView.addArrangedSubview(button)
                } else {
                    newView.addArrangedSubview(label)
                }
                newView.addArrangedSubview(spacerView)
                
                // Increment the current subview index and add the new stack view to the display area
                currentSubViewIndex += 1
                displayArea.addArrangedSubview(newView)
            } else {
                // If the width of the subview does not exceed the width of the display area, add the spacer view to the current subview
                currentSubView.addArrangedSubview(currentSpacerView)
            }
        }
    }

    
    func loadData(from words: [ActionWord]) {
        self.words = words
        self.updateDisplayArea()
    }
}
