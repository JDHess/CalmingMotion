//
//  KeyboardView.swift
//  KeyMorse
//
//  Created by Apps4World on 10/15/21.
//

import SwiftUI

/// Generic keyboard view
struct KeyboardView: View {
    
    @ObservedObject private var manager = DataManager()
    @State private var screenWidth: CGFloat = UIScreen.main.bounds.width
    @State private var isDefaultKeyboard: Bool = true
    @State var showSwitchKeyboardButton: Bool = false
    
    /// Includes the rows for the default keyboard
    let defaultKeyboard: [[String]] = [
        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
        ["Caps Lock", "Z", "X", "C", "V", "B", "N", "M", "DELETE"],
        ["123", "globe", "space", "return"]
    ]
    
    /// Includes the rows for the numeric keyboard
    let numericKeyboard: [[String]] = [
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
        ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""],
        ["[", "]", "#", ".", ",", "?", "!", "'", "DELETE"],
        ["ABC", "globe", "space", "return"]
    ]
    
    // MARK: - Main rendering function
    var body: some View {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "orientation"),
                                               object: nil, queue: nil) { notification in
            screenWidth = notification.object as? CGFloat ?? UIScreen.main.bounds.width
        }
        let height = screenWidth > 600 ? 170 : 210
        return KeyboardKeys()
            .frame(height: CGFloat(height))
            .frame(width: screenWidth)
            
    }
    
    /// Keyboard keys
    private func KeyboardKeys(withPopupShape: Bool = false) -> some View {
        return VStack(spacing: 12) {
            ForEach(0..<keyboard.count, id: \.self) { row in
                HStack(spacing: 6) {
                    ForEach(0..<keyboard[row].count, id: \.self) { column in
                        let key = keyboard[row][column]
                        Button {
                            if key.count > 1 {
                                handleComplexAction(forKey: key)
                            } else {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addTextEntry"), object: key)
                            }
                        } label: {
                            KeyboardKey(row: row, column: column)
                        }
                    }
                }
            }
        }
    }
    
    /// Handle complex key interaction
    private func handleComplexAction(forKey key: String) {
        if key == "123" || key == "ABC" {
            isDefaultKeyboard.toggle()
        } else {
            NotificationCenter.default
                .post(name: NSNotification.Name(rawValue: "addTextEntry"), object: key)
        }
    }
    
    /// Build keyboard key
    private func KeyboardKey(row: Int, column: Int, withPopupShape: Bool = false) -> some View {
        let key = keyboard[row][column]
        
        /// Key width
        var width = screenWidth/CGFloat(defaultKeyboard[0].count) - 6.5
        var height = screenWidth > 600 ? 30.0 : 43.0

        switch key {
        case "space":
            width = screenWidth - (width * 6) - 25
            if height == 30 {
                height = height * 1.2
            }
        case "Caps Lock", "DELETE":
            width = width * 1.39
        case "return":
            width = width * 3
            if height == 30 {
                height = height * 1.2
            }
        case "123", "ABC", "globe":
            width = width * (!showSwitchKeyboardButton ? 3.1 : 1.44)
            if height == 30 {
                height = height * 1.2
            }
        default: break
        }

        /// Build the key button
        return ZStack {
            if key == "Caps Lock" {
                Image(systemName: "cube.transparent").font(.system(size: 20))
            } else if key == "DELETE" {
                Image(systemName: "delete.left").font(.system(size: 22))
            } else if key == "globe" {
                Image(systemName: "globe").font(.system(size: 20))
            } else {
                Text(key.lowercased())
            }
        }
        .frame(width: width, height: CGFloat(height))
        .minimumScaleFactor(0.5)
        .font(.system(size: key.count == 1 ? 22 : 16))
    }
    
    /// Current keyboard characters
    var keyboard: [[String]] {
        var currentKeyboard = isDefaultKeyboard ? defaultKeyboard : numericKeyboard
        if showSwitchKeyboardButton == false {
            currentKeyboard[3].remove(at: 1)
        }
        return currentKeyboard
    }
}

// MARK: - Preview UI
