import Foundation
import UIKit
import StringMetric

// Top-level dictionary, mapping from word to its details
struct DictionaryEntry: Decodable {
    let entries: [String: WordDetail]
}

// Details for each word, including wordset ID, meanings, and optionally editors and contributors
struct WordDetail: Decodable {
    let meanings: [Meaning]?
}

// Representation of each meaning of a word, including definition, example (optional), part of speech, and optionally synonyms
struct Meaning: Decodable {
    let def: String
    var synonyms: [String]?

    enum CodingKeys: String, CodingKey {
        case def, synonyms
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        def = try container.decode(String.self, forKey: .def)
        
        // Custom decoding for the synonyms array to filter out null values
        if var synonymsUnkeyedContainer = try? container.nestedUnkeyedContainer(forKey: .synonyms) {
            var synonyms: [String] = []
            while !synonymsUnkeyedContainer.isAtEnd {
                if let synonym = try? synonymsUnkeyedContainer.decode(String.self) {
                    synonyms.append(synonym)
                } else {
                    _ = try? synonymsUnkeyedContainer.decodeNil() // Advance the container's cursor past the null value
                }
            }
            self.synonyms = synonyms.isEmpty ? nil : synonyms
        } else {
            self.synonyms = nil // No synonyms array present or it's null
        }
    }
}

class DataLoader {
    
    static var helper = DataLoader()
    var dictionary = [String:WordDetail]()
    
    func loadJsonData() -> [String: WordDetail] {
        if let url = Bundle.main.url(forResource: "allWords", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([String: WordDetail].self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return [:]
    }
    
    func initialize() {
        self.dictionary = self.loadJsonData()
    }
    
    func getSimilarWord(to word: String) -> [String] {
        
        var words = [String]()
        /*
        for eachWord in dictionary.keys where eachWord.distance(between: word) > 0.9 {
            words.append(eachWord)
        }
        */
        return words
    }
}
