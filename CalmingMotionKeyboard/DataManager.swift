//
//  DataManager.swift
//  KeyMorse
//
//  Created by Apps4World on 10/15/21.
//

import SwiftUI
import Foundation

/// Main data manager for the app
class DataManager: NSObject, ObservableObject {
    
    /// Dynamic properties that the UI will react to
    @Published var textMorseTab: TextMorseTabItem = .textMorse
    @Published var textValue: String = TextMorseTabItem.textMorse.placeholder
    @Published var morseValue: String = TextMorseTabItem.morseText.placeholder
    @Published var alphabet: [String: String] = [String: String]()
    
    /// Dynamic properties that the UI will react to AND store values in UserDefaults
    @AppStorage("isPremiumUser") var isPremiumUser: Bool = false {
        didSet { objectWillChange.send() }
    }
    
    @AppStorage("didShowOnboarding") var didShowOnboarding: Bool = false {
        didSet { objectWillChange.send() }
    }
    
    @AppStorage("enableAutoDecode") var enableAutoDecode: Bool = false {
        didSet { objectWillChange.send() }
    }
    
    @AppStorage("savedKeyboardIndex", store: AppConfig.appGroup) var keyboardIndex: Int = 0 {
        didSet { objectWillChange.send() }
    }

    override init() {
        super.init()
        loadAlphabetJSON()
    }
    
    /// Load morse alphabet JSON
    private func loadAlphabetJSON() {
        if let path = Bundle.main.path(forResource: "Alphabet", ofType: "json") {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
               let result = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: String] {
                alphabet = result
            }
        }
    }
}

// MARK: - Encode & Decode morse text
extension DataManager {
    
    /// Convert English to Morse
    func encodeText(completion: () -> Void) {
        var encodedValue = ""
        textValue.forEach { character in
            var replacement = alphabet["\(character)".lowercased()] ?? "\(character)"
            if "\(character)" == " " { replacement = AppConfig.morseWordsSpace }
            encodedValue += replacement
            encodedValue += AppConfig.morseLettersSpace
        }
        UIPasteboard.general.string = encodedValue
        completion()
    }
    
    /// Convert Morse to English
    func decodeText(completion: () -> Void) {
        var decodedValue = ""
        morseValue.components(separatedBy: " ").forEach { character in
            let swappedAlphabet = alphabet.swapKeyValues()
            var replacement = swappedAlphabet["\(character)".lowercased()] ?? "\(character)"
            if "\(character)" == AppConfig.morseWordsSpace { replacement = " " }
            decodedValue += replacement
        }
        UIPasteboard.general.string = decodedValue
        completion()
    }
}

// MARK: - Swap dictionary key/values
extension Dictionary where Value: Hashable {
    func swapKeyValues() -> [Value : Key] {
        return Dictionary<Value, Key>(uniqueKeysWithValues: lazy.map { ($0.value, $0.key) })
    }
}
