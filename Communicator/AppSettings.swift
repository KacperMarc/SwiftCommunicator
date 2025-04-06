//
//  AppSettings.swift
//  Communicator
//
//  Created by Kacper Marciszewski on 06/04/2025.
//

import Foundation

class AppSettings {
    static var isDarkmode: Bool {
            get {
                return UserDefaults.standard.bool(forKey: Keys.isDarkmode)
            }
            set {
                UserDefaults.standard.set(newValue, forKey: Keys.isDarkmode)
                NotificationCenter.default.post(name: .darkModeChanged, object: nil)
            }
        }
}
