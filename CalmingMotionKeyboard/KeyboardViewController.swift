//
//  KeyboardViewController.swift
//  CalmingMotionKeyboard
//
//  Created by Julie Hess on 3/29/23.
//

import UIKit
import SwiftUI

/// Custom keyboard controller
class KeyboardViewController: UIInputViewController {
    
    /// Keep track of keyboard view being setup, so it can happen only once
    private var didSetupKeyboardView: Bool = false
    private var dataManager: DataManager = DataManager()
    private var characters: [String] = [String]()
    
    /// Listen to any key touches from the `KeyboardView`
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "addTextEntry"), object: nil, queue: nil) { notification in
            /// Observer for text input from custom keyboard
            if let text = notification.object as? String {
                switch text.lowercased() {
                case "delete":
                    if let documentText = self.textDocumentProxy.documentContextBeforeInput,
                       let lastCharacter = documentText.components(separatedBy: AppConfig.morseLettersSpace).last,
                        lastCharacter.count > 0 {
                        for _ in 0..<lastCharacter.count {
                            self.textDocumentProxy.deleteBackward()
                        }
                    } else {
                        self.textDocumentProxy.deleteBackward()
                    }
                case "space":
                    self.textDocumentProxy.insertText("\(AppConfig.morseWordsSpace)\(AppConfig.morseLettersSpace)")
                case "return":
                    self.textDocumentProxy.insertText("\n")
                case "globe":
                    self.advanceToNextInputMode()
                case "translate":
                    self.openApp()
                default:
                    if let morseKey = self.dataManager.alphabet[text.lowercased()] {
                        self.textDocumentProxy.insertText("\(morseKey)\(AppConfig.morseLettersSpace)")
                    } else {
                        self.textDocumentProxy.insertText(text)
                    }
                    self.characters.append(text)
                }
            }
        }
    }
    
    /// Setup the keyboard view
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupKeyboardView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "orientation"),
                                        object: view.bounds.width)
    }
    
    // MARK: - Add the `MainKeyboardView` as a subview
    private func setupKeyboardView() {
        if didSetupKeyboardView { return }
        let keyboardView = KeyboardView(showSwitchKeyboardButton: needsInputModeSwitchKey)
        view.addModalSubview(UIHostingController(rootView: keyboardView).view)
        didSetupKeyboardView = true
    }
    
    // MARK: - Generic function to open the app from keyboard
    func openApp() {
        var responder: UIResponder? = self as UIResponder
        let selector = #selector(openURL(_:))
        while responder != nil {
            if responder!.responds(to: selector) && responder != self {
                responder!.perform(selector, with: URL(string: AppConfig.appOpenURL)!)
                return
            }
            responder = responder?.next
        }
    }
        
    @objc func openURL(_ url: URL) {
        return
    }
}

// MARK: - Add a view as subview
extension UIView {
    func addModalSubview(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        NSLayoutConstraint.activate([
            subview.leftAnchor.constraint(equalTo: leftAnchor),
            subview.rightAnchor.constraint(equalTo: rightAnchor),
            subview.topAnchor.constraint(equalTo: topAnchor),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - Delete backwards
extension String {
    func replacingLastOccurrenceOfString(_ searchString: String,
                                         with replacementString: String, caseInsensitive: Bool = true) -> String {
        let options: String.CompareOptions
        if caseInsensitive {
            options = [.backwards, .caseInsensitive]
        } else {
            options = [.backwards]
        }
        
        if let range = self.range(of: searchString, options: options, range: nil, locale: nil) {
            return self.replacingCharacters(in: range, with: replacementString)
        }
        return self
    }
}
