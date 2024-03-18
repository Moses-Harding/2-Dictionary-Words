//
//  TestingManager.swift
//  2 Dictionary Words
//
//  Created by Moses Harding on 3/6/24.
//

import Foundation

struct TestingManager {
    static let helper = TestingManager()
    
    func getGoalWord() -> (String, String) {
        return ("destestable", "deserving intense dislike")
    }
    
    func getCurrentWord() -> (String, [ActionWord], [ActionWord], [ActionWord]) {
        return ("unsung",
                [ActionWord(word: "having", action: { print("having") }),
                 ActionWord(word: "value", action: { print("value") }),
                 ActionWord(word: "that", action: { print("that") }),
                 ActionWord(word: "is", action: { print("is") }),
                 ActionWord(word: "not", action: { print("not") }),
                 ActionWord(word: "not", action: { print("not") }),
                 ActionWord(word: "not", action: { print("not") }),
                 ActionWord(word: "not", action: { print("not") }),
                 ActionWord(word: "not", action: { print("not") }),
                 ActionWord(word: "acknowledged", action: { print("acknowledged") }),
                ],
                [ActionWord(word: "unstrung", action: { print("unstrung") })],
                [ActionWord(word: "unappreciated", action: { print("unappreciated") })])
    }
}
