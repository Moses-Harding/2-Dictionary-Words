//
//  Saved Data.swift
//  2 Dictionary Words
//
//  Created by Moses Harding on 3/8/24.
//

import Foundation

@propertyWrapper
struct Cache<T: Codable> {
    let key: String
    let defaultValue: T
    
    private var fileURL: URL {
        // Construct the URL for the file in the document directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("\(key).json")
    }
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            // Attempt to read the data from the file
            guard let data = try? Data(contentsOf: fileURL) else {
                return defaultValue
            }
            
            // Attempt to decode the data into the specified type
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            // Attempt to encode the new value to data
            guard let data = try? JSONEncoder().encode(newValue) else {
                return
            }
            
            // Attempt to write the data to the file
            try? data.write(to: fileURL, options: [.atomicWrite])
        }
    }
}

class Saved {
    static var data = Saved()
    
    var clearData: Bool = true
    
    @Cache(key: "Time Record", defaultValue: 1000000000000) var timeRecord: Int
    @Cache(key: "Step Record", defaultValue: 1000000000000) var stepRecord: Int
    
    init() {
        if clearData {
            self.timeRecord = 1000000000000
            self.stepRecord = 1000000000000
        }
    }
}
