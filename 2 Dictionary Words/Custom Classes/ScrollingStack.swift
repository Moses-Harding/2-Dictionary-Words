//
//  ScrollingStack.swift
//  2 Dictionary Words
//
//  Created by Moses Harding on 3/9/24.
//

import Foundation
import UIKit

class ScrollingStack: UIView {
    
    var scrollView: UIScrollView
    var stackView: UIStackView

    var lastContentOffset = CGPoint.zero
    
    var keyboardSpacer: UIView?
    
    init(direction: NSLayoutConstraint.Axis, spacing: CGFloat) {
        
        scrollView = UIScrollView()
        stackView = UIStackView(direction)
        
        super.init(frame: .zero)
        
        self.constrain(scrollView, using: .scale)
        
        scrollView.constrain(stackView, using: .edges)
        
        stackView.axis = direction
        stackView.spacing = spacing
        scrollView.isDirectionalLockEnabled = true
        
        if direction == .vertical {
            scrollView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        } else {
            scrollView.heightAnchor.constraint(equalTo: stackView.heightAnchor).isActive = true
        }
    }
    
    func add(children: [(UIView, CGFloat?)]) {
        self.stackView.add(children: children)
    }
    
    func add(_ children: [UIView]) {
        self.stackView.add(children)
    }
    
    func showKeyboard(keyboardHeight: CGFloat, viewToScrollTo view: UIView) {
        self.lastContentOffset = scrollView.contentOffset

        keyboardSpacer = Spacer(keyboardHeight, .vertical)
        stackView.addArrangedSubview(keyboardSpacer!)
        
        let activeFrame = view.convert(view.bounds, to: scrollView)
        
        let distanceToBottom = self.scrollView.frame.size.height - activeFrame.maxY
        let collapseSpace = keyboardHeight - distanceToBottom
        
        if collapseSpace < 0 { return }
        
        let newContentOffsetY = activeFrame.maxY - scrollView.frame.height + keyboardHeight

        scrollView.setContentOffset(CGPoint(x: 0, y: newContentOffsetY), animated: true)
    }
    
    func hideKeyboard() {

        scrollView.setContentOffset(lastContentOffset, animated: true)
        //scrollView.scrollRectToVisible(CGRect(origin: lastContentOffset, size: CGSize(width: 100, height: 100)), animated: true)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            if let keyboardSpacer = self.keyboardSpacer {
                self.stackView.removeArrangedSubview(keyboardSpacer)
            }
            
            self.keyboardSpacer?.removeFromSuperview()
            self.keyboardSpacer = nil
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

