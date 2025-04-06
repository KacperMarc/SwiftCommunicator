//
//  SideMenuView.swift
//  Communicator
//
//  Created by Kacper Marciszewski on 05/04/2025.
//

import UIKit

class SideMenuView: UIViewController {
    
    lazy var toggleButton: UISwitch = {
                let button = UISwitch()
                button.isOn = AppSettings.isDarkmode
                button.addTarget(self, action: #selector(turnDarkModeOn), for: .touchUpInside)
                return button
    }()
            
    lazy var labelek: UILabel = {
                let label = UILabel()
                label.text = AppSettings.isDarkmode ? "Turn on darkmode" : "Turn off darkmode"
                label.font = UIFont.systemFont(ofSize: 20, weight: .light)
                label.textAlignment = .center
                return label
    }()
            
    lazy var stack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ toggleButton, labelek])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    override func viewDidLoad() {
            super.viewDidLoad()
            
            setupUI()
    }
    private func setupUI(){
        view.addSubview(stack)
        view.backgroundColor = .systemGray5
        NSLayoutConstraint.activate([
                    stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    stack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
        ])
    }
    @objc func turnDarkModeOn() {
        print("Dark mode on")
        AppSettings.isDarkmode.toggle()
        
    }
    
}
