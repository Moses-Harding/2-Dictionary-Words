//
//  GameManager.swift
//  2 Dictionary Words
//
//  Created by Moses Harding on 3/6/24.
//

import Foundation

class GameManager {
    
    static var helper = GameManager()
    
    var goalWord: String = ""
    
    var viewController: GameplayViewController?
    
    var wordHistory: [ActionWord] = []
    
    var timer: Timer?
    var stepCount: Int = 0
    var timeAsSeconds: Int = 0
    
    enum GameType { case classic, daily }
    func initializeGame() {
        
        timeAsSeconds = 0
        stepCount = 0

        /*
        let wordDetail = DataLoader.helper.dictionary.randomElement()!
         
         goalWord = wordDetail.key
        
        viewController?.populateGoal(with: wordDetail.key, definition: wordDetail.value.meanings?.first?.def ?? "No definition found")
        
        self.getData(for: DataLoader.helper.dictionary.randomElement()?.key ?? "Unsung")
         */
        
        goalWord = "one"

        viewController?.populateGoal(with: "one", definition: DataLoader.helper.dictionary["one"]?.meanings?.first?.def ?? "No definition found")
        
        self.getData(for: "two" ?? "Unsung")
        
        updateTimer()
    }
    
    func endGame() -> (Bool, Bool) {
        
        self.wordHistory = []
        timer?.invalidate()
        
        var isStepRecord = false
        var isTimeRecord = false
        
        if Saved.data.stepRecord > stepCount {
            Saved.data.stepRecord = stepCount
            isStepRecord = true
        }
        
        if Saved.data.timeRecord > timeAsSeconds {
            Saved.data.timeRecord = timeAsSeconds
            isTimeRecord = true
        }
        
        return (isStepRecord, isTimeRecord)
    }
    
    func getData(for word: String) {
        
        guard word != goalWord else {
            viewController?.endGame()
            return
        }
        
        viewController?.populateCurrentWord(with: word)
        
        getDefinitionWords(for: word)
        getSimilarWords(for: word)
        getSynonymWords(for: word)
        getWordHistory(for: word)
    }
    
    func updateTimer() {

        var timerText = "0:00"
        self.viewController?.gamePlayView.timer.text = timerText
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.viewController?.gamePlayView.timer.text = self.timeAsSeconds.asTimeString()
            self.timeAsSeconds += 1
        }
    }
    
    func getDefinitionWords(for word: String) {
        
        var actionWords = [ActionWord]()
        
        let definition = DataLoader.helper.dictionary[word]?.meanings?.first?.def ?? "No definition found"
        let resultWords = definition.split(separator: " ").map { String($0)}
        
        for word in resultWords {
            actionWords.append(ActionWord(word: word, action: { self.getData(for: word) }, hasAction: DataLoader.helper.dictionary[word]?.meanings?.first?.def != nil))
        }
        
        viewController?.populate(definitions: actionWords)
    }
    
    func getSimilarWords(for word: String) {
        
        var actionWords = [ActionWord]()
        
        let resultWords = DataLoader.helper.getSimilarWord(to: word)
        
        for word in resultWords {
            actionWords.append(ActionWord(word: word, action: { self.getData(for: word) }))
        }
        
        viewController?.populate(similarWords: actionWords)
    }
    
    func getSynonymWords(for word: String) {
        
        var actionWords = [ActionWord]()
        
        let resultWords = DataLoader.helper.dictionary[word]?.meanings?.first?.synonyms ?? []
        
        for word in resultWords {
            actionWords.append(ActionWord(word: word, action: { self.getData(for: word) }))
        }
        
        viewController?.populate(synonyms: actionWords)
    }
    
    func getWordHistory(for word: String) {
        
        var actionWords = [ActionWord]()
        
        self.wordHistory.append(ActionWord(word: word + "→", action: { self.getData(for: word) }, hasAction: true))
        
        /*
        if wordHistory.count > 10 {
            wordHistory.removeFirst()
        }
         */
        
        stepCount += 1
        
        viewController?.populate(wordHistory: self.wordHistory)
    }
}
