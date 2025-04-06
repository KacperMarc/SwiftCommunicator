//
//  ViewController+.swift
//  Communicator
//
//  Created by Kacper Marciszewski on 06/04/2025.
//

import UIKit

extension ViewController {
    
    @objc func updateStyle() {
        UIView.animate(withDuration: 0.3) {
            let isDark = AppSettings.isDarkmode
            let textColor: UIColor = isDark ? .white : .black
            let navBarColor: UIColor = isDark ? .black : .white
            
            self.navigationController?.navigationBar.barTintColor = navBarColor
            self.view.backgroundColor = isDark ? .black : .white
            
            self.chatViewController.view.backgroundColor = isDark ? .black : .white
            self.menuViewController.view.backgroundColor = isDark ? .gray : .systemGray5
            
            self.changeTextColor(in: self.menuViewController.view, to: textColor)
            
            self.navigationController?.navigationBar.tintColor = textColor
            self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: textColor]
        }
    }

    func changeTextColor(in view: UIView, to color: UIColor) {
        for subview in view.subviews {
            if let label = subview as? UILabel {
                label.textColor = color
            } else {
                changeTextColor(in: subview, to: color)
            }
        }
    }
    func checkAppModeSetting() {
        let appModeSetting = AppSettings.isDarkmode
            if appModeSetting {
                AppSettings.isDarkmode = true
                updateStyle()
            }
        }
}
