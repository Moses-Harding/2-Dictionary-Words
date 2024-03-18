//
//  GameplayViewController.swift
//  2 Dictionary Words
//
//  Created by Moses Harding on 3/6/24.
//

import Foundation
import UIKit

class GameplayViewController: UIViewController {
    
    let gamePlayView = GamePlayView()
    
    override func viewDidLoad() {
        overrideUserInterfaceStyle = .light
        
        view.constrain(gamePlayView)
        
        GameManager.helper.viewController = self
        gamePlayView.viewController = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        initializeGame()
    }
    
    
    // Button Actions
    func back() {
        self.dismiss(animated: true)
        
        GameManager.helper.endGame()
    }
    
    func instructions() {
        self.presentAlert("Instructions", body: """
        Get from your current word to your goal word as fast (and with the fewest number of steps) as you can using the available words. You can also go back to a previous word you chose. It's that simple!
        """)
    }
    
    func initializeGame() {
        GameManager.helper.initializeGame()
    }

    func endGame() {
        let (isStepRecord, isTimeRecord) = GameManager.helper.endGame()
        
        let timeString = isTimeRecord ? "Time: \(GameManager.helper.timeAsSeconds.asTimeString()) - NEW RECORD!" : "Time: \(GameManager.helper.timeAsSeconds.asTimeString())"
        let stepString = isStepRecord ? "Steps: \(GameManager.helper.stepCount) - NEW RECORD!" : "Steps: \(GameManager.helper.stepCount)"
        
        self.presentAlert("Congratulations!", body: """
        You have won the game!
        \(timeString)
        \(stepString)
        """, okayAction: {
            self.dismiss(animated: true)
        })
    }
    
    func populateGoal(with word: String, definition: String) {
        gamePlayView.goalWordLabel.attributedText = NSMutableAttributedString.join("Goal Word: ".asMutableAttributedString(size: DeviceManager.secondLargestSize),
                                                                              word.asMutableAttributedString(.italic, size: DeviceManager.secondLargestSize)
        )
        gamePlayView.goalWordDefinitionLabel.attributedText = NSMutableAttributedString.join("Definition: ".asMutableAttributedString(size: DeviceManager.regularSize),
                                                                                        definition.asMutableAttributedString(.italic, size: DeviceManager.regularSize))
    }
    
    func populateCurrentWord(with word: String) {
        gamePlayView.currentWordLabel.attributedText = NSMutableAttributedString.join("Current Word: ".asMutableAttributedString(size: DeviceManager.secondLargestSize),
                                                                              word.asMutableAttributedString(.italic, size: DeviceManager.secondLargestSize)
        )
    }
    
    func populate(definitions: [ActionWord]) {
        gamePlayView.populate(.definition, with: definitions)
    }
    
    func populate(similarWords: [ActionWord]) {
        gamePlayView.populate(.similarWords, with: similarWords)
    }
    
    func populate(synonyms: [ActionWord]) {
        gamePlayView.populate(.synonyms, with: synonyms)
    }
    
    func populate(wordHistory: [ActionWord]) {
        gamePlayView.populate(.wordHistory, with: wordHistory)
    }
}

class GamePlayView: UIView {
    
    // VC
    var viewController: GameplayViewController?
    
    // Structure
    var mainStack = UIStackView(.vertical, spacing: 5)
    var bodyView = UIView()
    var bodyStack = ScrollingStack(direction: .vertical, spacing: 15)
    
    var header = UIStackView(.horizontal, spacing: 5)
    var goalArea = UIStackView(.vertical, spacing: 5)
    var currentWordArea = UIStackView(.vertical, spacing: 5)
    var wordHistoryArea = UIStackView(.vertical, spacing: 5)
    var footer = UIView()
    
    // Header
    lazy var backButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .white
        config.title = "Back"
        button.configuration = config
        button.addAction(UIAction() { _ in self.viewController?.back() }, for: .touchUpInside)
        return button
    } ()
    lazy var instructionsButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .white
        config.title = "Instructions"
        button.configuration = config
        button.addAction(UIAction() { _ in self.viewController?.instructions() }, for: .touchUpInside)
        return button
    } ()
    
    // Goal Area
    let goalWordLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.title
        label.numberOfLines = -1
        label.adjustsFontSizeToFitWidth = true
        return label
    } ()
    let goalWordDefinitionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.main
        label.numberOfLines = -1
        label.adjustsFontSizeToFitWidth = true
        return label
    } ()
    var timer :UILabel = {
        let label = UILabel()
        label.font = Fonts.title
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .black
        return label
    } ()
    
    // Current Area
    let currentWordLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.title
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = -1
        return label
    } ()
    let currentWordDefinitionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.main
        label.adjustsFontSizeToFitWidth = true
        return label
    } ()
    let currentWordSimilarWordsLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.main
        label.adjustsFontSizeToFitWidth = true
        return label
    } ()
    let currentWordSynonymsLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.main
        label.adjustsFontSizeToFitWidth = true
        return label
    } ()
    
    let definitionsButtonView = ButtonArea()
    let similarWordsButtonView = ButtonArea()
    let synonymsButtonView = ButtonArea()
    
    // Word History Area
    let wordHistoryLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.title
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = -1
        return label
    } ()
    let wordHistoryButtonView = ButtonArea()
    
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
        self.constrain(mainStack)
        
        mainStack.add([header, bodyView, footer])
        
        let hSpacer1 = UIView()
        let hSpacer2 = UIView()
        let vSpacer1 = UIView()
        let vSpacer2 = UIView()
        let vSpacer3 = UIView()
        
        header.add([backButton, hSpacer1, hSpacer2, instructionsButton])
        
        let grayLine1 = Spacer(1, .vertical, color: Colors.primaryGray)
        let grayLine2 = Spacer(1, .vertical, color: Colors.primaryGray)
        bodyView.constrain(bodyStack, using: .edges, padding: 20)
        bodyStack.add([goalArea, grayLine1, currentWordArea, grayLine2, wordHistoryArea])
        
        goalArea.add([goalWordLabel, 
                      goalWordDefinitionLabel,
                      timer,
                      vSpacer1])
        
        currentWordArea.add([currentWordLabel, 
                             currentWordDefinitionLabel,
                             definitionsButtonView,
                             currentWordSimilarWordsLabel,
                             similarWordsButtonView,
                             currentWordSynonymsLabel,
                             synonymsButtonView,
                             vSpacer2])
        
        wordHistoryArea.add([wordHistoryLabel,
                             wordHistoryButtonView,
                             vSpacer3])
        
        hSpacer1.widthAnchor.constraint(equalTo: hSpacer2.widthAnchor).isActive = true
        vSpacer1.heightAnchor.constraint(equalTo: vSpacer2.heightAnchor).isActive = true
        vSpacer2.heightAnchor.constraint(equalTo: vSpacer3.heightAnchor).isActive = true
        footer.heightAnchor.constraint(equalTo: header.heightAnchor).isActive = true
    }
    
    func setUpUI() {
        header.backgroundColor = Colors.primaryRed
        goalArea.backgroundColor = .white
        currentWordArea.backgroundColor = .white
        footer.backgroundColor = Colors.primaryRed
        
        self.backgroundColor = .white
    }
    
    func setUpContent() {
        currentWordDefinitionLabel.attributedText = "Definition: ".asMutableAttributedString(weight: .semibold)
        currentWordSimilarWordsLabel.attributedText = "Similar Words: ".asMutableAttributedString(weight: .semibold)
        currentWordSynonymsLabel.attributedText = "Synonyms: ".asMutableAttributedString(weight: .semibold)
        wordHistoryLabel.attributedText = "History: ".asMutableAttributedString(weight: .semibold)
    }
}

// Actions
extension GamePlayView {
    
    enum FieldType { case definition, similarWords, synonyms, wordHistory }
    func populate(_ field: FieldType, with words: [ActionWord]) {
        
        switch field {
        case .definition:
            definitionsButtonView.loadData(from: words)
        case .similarWords:
            similarWordsButtonView.loadData(from: words)
        case .synonyms:
            synonymsButtonView.loadData(from: words)
        case .wordHistory:
            wordHistoryButtonView.loadData(from: words)
        }
    }
}
