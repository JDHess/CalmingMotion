//
//  AppConfig.swift
//  KeyMorse
//
//  Created by Apps4World on 10/14/21.
//

import SwiftUI
import Foundation

/// Generic configurations for the app
class AppConfig {
    
    /// This is the AdMob Interstitial ad id
    /// Test App ID: ca-app-pub-3940256099942544~1458002511
    static let adMobAdId: String = "ca-app-pub-3940256099942544/4411468910"
    
    // MARK: - Text/Morse Configuration
    static let textInputFontSize: CGFloat = 18
    static let textMorsePlaceholder: String = "Type your English text here\n\nThen tap the 'Encode' button below\n\nThe encoded text will be automatically copied to your clipboard"
    static let morseTextPlaceholder: String = "Copy your Morse text and paste it here\n\nTap the 'Decode' button below\n\nThe encoded text will be automatically copied"
    
    
    // MARK: - Morse replacements
    static let morseWordsSpace: String = "/"
    static let morseLettersSpace: String = " "
    
    // MARK: - Keyboard Extension configuration
    static let appGroup: UserDefaults? = UserDefaults(suiteName: "group.com.com.a4w.KeyMorse.shared")
    static let appOpenURL: String = "key-morse://com.com.a4w.KeyMorse"
}

// MARK: - Navigation Tab Bar
enum CustomTabBarItem: String, CaseIterable, Identifiable {
    case convertor = "keyboard"
    case themes = "theatermasks"
    case alphabet = "square.stack.3d.up.badge.a"
    case settings = "gearshape"
    
    var headerTitle: String {
        switch self {
        case .convertor:
            return "Text <-> Morse"
        case .themes:
            return "Keyboard Themes"
        case .alphabet:
            return "Morse Alphabet"
        case .settings:
            return "Settings"
        }
    }
    
    var id: Int { hashValue }
}

// MARK: - Text/Morse Tab Bar
enum TextMorseTabItem: String, Identifiable {
    case textMorse = "Text to Morse"
    case morseText = "Morse to Text"
    
    var placeholder: String {
        if self == .textMorse {
            return AppConfig.textMorsePlaceholder
        }
        return AppConfig.morseTextPlaceholder
    }
    
    var id: Int { hashValue }
}
