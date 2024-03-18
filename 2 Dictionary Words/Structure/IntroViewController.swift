//
//  IntroView.swift
//  2 Dictionary Words
//
//  Created by Moses Harding on 3/2/24.
//

import Foundation
import UIKit
import StringMetric

class IntroView: UIView {
    
    var viewController: ViewController?
    
    // Structure
    let mainStack = UIStackView(.vertical)
    var topArea = UIView()
    var topStack = UIStackView(.vertical, spacing: 5)
    var midArea = UIView()
    var midStack = UIStackView(.vertical, spacing: 5)
    var bottomArea = UIView()
    var bottomStack = UIStackView(.vertical)
    
    // Top Area
    let buttonArea = UIView()
    
    let mainTitle: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = Fonts.title
        label.textColor = .white
        label.textAlignment = .center
        return label
    } ()
    let subNote: UILabel = {
        let label = UILabel()
        label.numberOfLines = -1
        label.font = Fonts.sub
        label.textColor = .white
        return label
    } ()
    
    lazy var button: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.outline(title: "Play the game")
        button.configuration = config
        button.addAction(UIAction() { _ in self.viewController?.startGame() }, for: .touchUpInside)
        return button
    } ()
    
    //  MidArea
    
    let aboutSection = UIStackView(.vertical)
    
    let aboutTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = -1
        label.font = Fonts.sectionTitle
        label.textColor = .black
        return label
    } ()
    let aboutSectionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = -1
        label.font = Fonts.main
        label.textColor = .black
        return label
    } ()
    
    let rocketImage = UIImageView()
    
    // BottomArea
    let timGunnQuote: UILabel = {
        let label = UILabel()
        label.numberOfLines = -1
        label.font = Fonts.main
        label.textColor = .white
        return label
    } ()
    
    init() {
        super.init(frame: .zero)
        
        setUpViews()
        setUpUI()
        setUpContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        
        // Mainstack
        self.constrain(mainStack)
        mainStack.add([topArea, midArea, bottomArea])
        
        // TopArea
        topArea.constrain(topStack, using: .edges, padding: 20)
        topStack.add([mainTitle, Spacer(10, .vertical), buttonArea, Spacer(20, .vertical), subNote])
        buttonArea.constrain(button, using: .scale, except: [.width])
        
        // MidArea
        midArea.constrain(midStack, using: .edges, padding: 20)
        midStack.add([aboutTitle, aboutSection, UIView()])
        aboutSection.add([aboutSectionLabel, rocketImage])
        
        // Bottom Area
        bottomArea.constrain(bottomStack, using: .edges, padding: 20)
        bottomStack.add([timGunnQuote])
    }
    
    func setUpUI() {
        
        topArea.backgroundColor = Colors.primaryRed
        bottomArea.backgroundColor = Colors.primaryRed
    }
    
    func setUpContent() {
        mainTitle.text = "2 Dictionary Words"
        subNote.attributedText =
        "play - [pleɪ] - verb - Engage in activity for enjoyment and recreation rather than a serious or practical purpose.".asMutableAttributedString(.italic, size: 12, color: .white)
        aboutTitle.text = "About"
        aboutSectionLabel.text =
        """
        Find a path from your given dictionary word to a new dictionary word as fast as you can and learn new words along the way!
        """
        timGunnQuote.text = "\"Few activities are as delightful as learning new vocabulary\" —Tim Gunn"
        
        rocketImage.image = UIImage(named: "Rocket") ?? UIImage(systemName: "airplane.departure")
        rocketImage.contentMode = .scaleAspectFit
        rocketImage.heightAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
    }
}
