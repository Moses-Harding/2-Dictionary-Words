//
//  ViewController.swift
//  2 Dictionary Words
//
//  Created by Moses Harding on 3/2/24.
//

import Foundation
import UIKit

enum ConstraintType {
    case height, width, centerX, centerY, leading, trailing, top, bottom
}

enum ConstraintMethod {
    case scale, edges
}

extension UIView {
    
    func addGradient(colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addShadow(color: UIColor, opacity: Float, size: CGSize, shadowRadius: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = size
        self.layer.shadowRadius = shadowRadius
    }
    
    //MARK: Constraining subviews
    //The purpose of the  below is to reduce the overhead of programmatically constraining a subview to a view (setting defaults, defining four constraints, and activating them).
    
    /* Constrain: Automatically constrain a child view either by scaling to proportions of parent view or by fitting to edges (with padding). User can specify exceptions. The generated constraints are returned if needed (including exceptions, which are inactive). */
    @discardableResult
    func constrain(_ child: UIView, using constraintMethod: ConstraintMethod = .scale, widthScale: CGFloat = 1, heightScale: CGFloat = 1, padding: CGFloat = 0, except: [ConstraintType] = [], safeAreaLayout: Bool = false, debugName: String = "Unnamed View") -> (NSLayoutConstraint, NSLayoutConstraint, NSLayoutConstraint, NSLayoutConstraint) {
        
        guard (constraintMethod == .edges && widthScale == 1 && heightScale == 1) || (constraintMethod == .scale && padding == 0 ) else {
            fatalError("UIView - Constrain Extension - ConstraintMethod does not match parameters")
        }

        self.addSubview(child)
        child.translatesAutoresizingMaskIntoConstraints = false

        let safeArea: UILayoutGuide? = safeAreaLayout ? self.safeAreaLayoutGuide : nil

        let heightConstraint = child.heightAnchor.constraint(equalTo: safeArea?.heightAnchor ?? self.heightAnchor, multiplier: heightScale)
        let widthConstraint = child.widthAnchor.constraint(equalTo: safeArea?.widthAnchor ?? self.widthAnchor, multiplier: widthScale)
        let centerYConstraint = child.centerYAnchor.constraint(equalTo: safeArea?.centerYAnchor ?? self.centerYAnchor)
        let centerXConstraint = child.centerXAnchor.constraint(equalTo: safeArea?.centerXAnchor ?? self.centerXAnchor)
        let leadingConstraint = child.leadingAnchor.constraint(equalTo: safeArea?.leadingAnchor ?? self.leadingAnchor, constant: padding)
        let trailingConstraint = child.trailingAnchor.constraint(equalTo: safeArea?.trailingAnchor ?? self.trailingAnchor, constant: -padding)
        let topConstraint = child.topAnchor.constraint(equalTo: safeArea?.topAnchor ?? self.topAnchor, constant: padding)
        let bottomConstraint = child.bottomAnchor.constraint(equalTo: safeArea?.bottomAnchor ?? self.bottomAnchor, constant: -padding)
        
        centerXConstraint.identifier = "\(debugName) - Custom Constraint - Center X"
        centerYConstraint.identifier = "\(debugName) - Custom Constraint - Center Y"
        widthConstraint.identifier = "\(debugName) - Custom Constraint - Width"
        heightConstraint.identifier = "\(debugName) - Custom Constraint - Height"
        leadingConstraint.identifier = "\(debugName) - Custom Constraint - Leading"
        trailingConstraint.identifier = "\(debugName) - Custom Constraint - Trailing"
        topConstraint.identifier = "\(debugName) - Custom Constraint - Top"
        bottomConstraint.identifier = "\(debugName) - Custom Constraint - Bottom"
        
        var constraintTuple: (NSLayoutConstraint, NSLayoutConstraint, NSLayoutConstraint, NSLayoutConstraint)
        
        if constraintMethod == .scale {
            NSLayoutConstraint.activate([heightConstraint, widthConstraint, centerYConstraint, centerXConstraint])
        
            constraintTuple = (centerXConstraint: centerXConstraint, centerYConstraint: centerYConstraint, widthConstraint: widthConstraint, heightConstraint: heightConstraint)
        } else {
            NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
            
            constraintTuple = (leadingConstraint: leadingConstraint, trailingConstraint: trailingConstraint, topConstraint: topConstraint, bottomConstraint: bottomConstraint)
        }
        
        except.forEach { exception in
            switch exception {
            case .height:
                heightConstraint.isActive = false
            case .width:
                widthConstraint.isActive = false
            case .centerX:
                centerXConstraint.isActive = false
            case .centerY:
                centerYConstraint.isActive = false
            case .leading:
                leadingConstraint.isActive = false
            case .trailing:
                trailingConstraint.isActive = false
            case .top:
                topConstraint.isActive = false
            case .bottom:
                bottomConstraint.isActive = false
            }
        }
        
        return constraintTuple
    }
    
    func constrainVertically(_ viewsToConstrain: UIView ..., padding: CGFloat = 0) {
        
        for eachViewIndex in 0 ... viewsToConstrain.count - 1 {
            
            let isFirstView = eachViewIndex == 0
            let isLastView = eachViewIndex == viewsToConstrain.count - 1
            
            let currentView = viewsToConstrain[eachViewIndex]
            
            if isFirstView && isLastView {
                print(1)
                self.constrain(currentView)
                
            } else if isFirstView && !isLastView {
                print(2)
                self.constrain(currentView, using: .edges, except: [.bottom])
                
            } else if !isFirstView && !isLastView {
                print(3)
                self.constrain(currentView, using: .edges, except: [.top, .bottom])
                
                let previousView = viewsToConstrain[eachViewIndex - 1]
                previousView.bottomAnchor.constraint(equalTo: currentView.topAnchor, constant: -padding).isActive = true
                
            } else if !isFirstView && isLastView {
                print(4)
                self.constrain(currentView, using: .edges, except: [.top])
                
                let previousView = viewsToConstrain[eachViewIndex - 1]
                currentView.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: padding).isActive = true
            }
        }
    }

    /**
    Create and return a single constraint (specified by "constraintType"). Options to add padding and in the case of width/height constraints, scale with a multiplier. Can add as a child if needed.
     - Parameters:
       - child: UIView: The child view to which the constraint is applied
       - constraintType: ConstraintType: The type of constraint to apply
       - addAsChild: Bool: A flag to indicate if the child view should be added as a subview
       - multiplier: CGFloat: A multiplier to scale the constraint (only applicable to width/height constraints)
       - constant: CGFloat: The constant value to be added to the constraint
     - Returns: NSLayoutConstraint
    */
    @discardableResult
    func setConstraint(for child: UIView, _ constraintType: ConstraintType, addAsChild: Bool = false, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
        
        if addAsChild {
            self.addSubview(child)
            child.translatesAutoresizingMaskIntoConstraints = false
        }
        
        if constraintType != .height && constraintType != .width && multiplier != 1 {
            print("Warning - multiplier has no effect")
        }
        
        var constraint: NSLayoutConstraint
        
        switch constraintType {
        case .top:
            constraint = child.topAnchor.constraint(equalTo: self.topAnchor, constant: constant)
        case .bottom:
            constraint = child.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: constant)
        case .leading:
            constraint = child.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: constant)
        case .trailing:
            constraint = child.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: constant)
        case .centerX:
            constraint = child.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: constant)
        case .centerY:
            constraint = child.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: constant)
        case .height:
            constraint = child.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: multiplier, constant: constant)
        case .width:
            constraint = child.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: multiplier, constant: constant)
        }
        
        constraint.isActive = true
        constraint.identifier = "Custom Constraint - \(constraintType)"
        
        return constraint
    }

      func recognizeTaps(tapNumber: Int, target: UIView, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
      }
    
    func shake() {
      let animation = CABasicAnimation(keyPath: "position")
      animation.duration = 0.4
      animation.repeatCount = .infinity
      animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPointMake(self.center.x - 3, self.center.y))
        animation.toValue = NSValue(cgPoint: CGPointMake(self.center.x + 3, self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    
    func rotate() {
        
        let rotateFrame: ((CGFloat, CGFloat) -> ()) = { (startTime: CGFloat, angle: CGFloat) in
            UIView.addKeyframe(withRelativeStartTime: 0.25 * startTime, relativeDuration: 1) {
                //let angle = CGFloat.pi * CGFloat(1)
                self.transform = CGAffineTransform(rotationAngle: angle) }
        }
        

        
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [.autoreverse, .repeat]) {
            rotateFrame(0, 0)
            rotateFrame(1, -0.005)
            rotateFrame(2, 0)
            rotateFrame(3, 0.005)
        }
    }
    
    func focus(at point: CGPoint) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 1
        animation.fromValue = NSValue(cgPoint: CGPointMake(self.center.x, self.center.y))
        animation.toValue = NSValue(cgPoint: point)
        self.layer.add(animation, forKey: "position")
    }
}

extension UIStackView {
    
    /* This convenience init is simply to facilitate the more common usages of UIStackView */
    convenience init(_ axis: NSLayoutConstraint.Axis, spacing: CGFloat? = nil, isLayoutMarginsRelativeArrangement: Bool = true, distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill) {
        self.init(frame: CGRect.zero)
        
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        
        if let spacing = spacing {
            self.spacing = spacing
        }
        
        self.isLayoutMarginsRelativeArrangement = isLayoutMarginsRelativeArrangement
    }
    
    /* Add: Add a list of views to a stackview and optionally provide percentages to scale each of the children. By default, if the percentages exceed 100, an error will be thrown. */
    func add(children: [(UIView, CGFloat?)], overrideErrorCheck: Bool = false) {
        
        var count: CGFloat = 0
        
        var constraintType: ConstraintType
        
        if self.axis == .horizontal {
            constraintType = .width
        } else {
            constraintType = .height
        }
        
        for (child, multiplier) in children {
            self.addArrangedSubview(child)
            if let multiplier = multiplier {
                self.setConstraint(for: child, constraintType, multiplier: (multiplier - 0.01))
                count += multiplier
            }
        }
        
        guard count <= 1 || overrideErrorCheck == true else {
            fatalError("Stack constraints exceed 100%")
        }
    }
    
    func add(_ children: [UIView]) {
        for child in children {
            self.addArrangedSubview(child)
        }
    }
    
    func colorSections() {
        let colors: [UIColor] = [.red, .orange, .yellow, .green, .blue, .cyan, .purple]
        
        var i = 0
        for subview in self.arrangedSubviews {
            subview.backgroundColor = colors[i % colors.count]
            i += 1
        }
    }
}

extension UITextView {
     
    func layoutWith(paths: [UIBezierPath]) {
        let title = self.text
        
        self.textContainer.exclusionPaths = paths
        
        self.text = ""
        self.text = title
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
