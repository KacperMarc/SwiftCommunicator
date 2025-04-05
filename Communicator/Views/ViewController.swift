//
//  ViewController.swift
//  Communicator
//
//  Created by Kacper Marciszewski on 05/04/2025.
//

import UIKit

class ViewController: UIViewController {
     
    
    
    
    let userDefaults = UserDefaults.standard
    var isDarkmode = false
    var isMenuOpen = false
    lazy var sideInMenuPadding: CGFloat = self.view.frame.width * 0.3
    
    struct Keys {
        static let isDarkmode = "isDarkmode"
    }
    
    
    lazy var settingsButton = UIBarButtonItem(image: UIImage(systemName: "sidebar.leading") , style: .done, target: self, action: #selector (openSideMenu))
   
    
    // MARK: - MenuView

    lazy var menuView: UIView = {
        
        lazy var toggleButton: UISwitch = {
            let button = UISwitch()
            button.addTarget(self, action: #selector(turnDarkModeOn), for: .touchUpInside)
            return button
        }()
        
        lazy var labelek: UILabel = {
            let label = UILabel()
            label.text = "Turn on dark mode"
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
        
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
        ])
        
        return view
    }()
    // MARK: - ContainerView
    let labelek: UILabel = {
        let label = UILabel()
        label.text = "Eelooooo byczek"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let messageField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Twoje wypociny"
        textField.borderStyle = .roundedRect
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    lazy var containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.addSubview(labelek)
        view.addSubview(messageField)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAppModeSetting()
        
        
        
    
        navigationItem.setLeftBarButton(settingsButton, animated: true)
        
        title = "Byczek"
        
        menuView.pinMenuTo(view, with: sideInMenuPadding)
        containerView.edgeTo(view)
        
        NSLayoutConstraint.activate([
                   containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                   containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                   containerView.widthAnchor.constraint(equalToConstant: 200),
                   containerView.heightAnchor.constraint(equalToConstant: 100)
               ])

             
        NSLayoutConstraint.activate([
                   labelek.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                   labelek.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                   
        ])
        NSLayoutConstraint.activate([
                messageField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),  // Odstęp od lewej krawędzi
                messageField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),  // Odstęp od prawej krawędzi
                messageField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),  // Przypięcie do dolnej krawędzi ekranu
                messageField.heightAnchor.constraint(equalToConstant: 50)  // Wysokość pola tekstowego
            ])
    }


}

extension ViewController{
    
    
    
    func updateStyle() {
            UIView.animate(withDuration: 0.3) {
                let textColor: UIColor = self.isDarkmode ? .white : .black
                let navBarColor: UIColor = self.isDarkmode ? .white : .black
                self.navigationController?.navigationBar.barTintColor = navBarColor
                
                self.containerView.backgroundColor = self.isDarkmode ? .black : .white
                self.menuView.backgroundColor = self.isDarkmode ? .gray : .systemGray5
                
                self.labelek.textColor = textColor
                
                self.changeTextColor(in: self.menuView, to: textColor)
                
                
               
                self.navigationController?.navigationBar.tintColor = textColor
                self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: textColor]
            }
    }

        
    private func changeTextColor(in view: UIView, to color: UIColor) {
            for subview in view.subviews {
                if let label = subview as? UILabel {
                    label.textColor = color
                } else {
                    changeTextColor(in: subview, to: color)
                }
        }
    }
    
    @objc func openSideMenu() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.containerView.frame.origin.x = self.isMenuOpen ? 0 : self.containerView.frame.width - self.sideInMenuPadding
        } completion: { (finished) in
            print("Done\(finished)")
            self.isMenuOpen.toggle()
        }
    }
    @objc func turnDarkModeOn() {
        print("Dark mode on")
        self.isDarkmode.toggle()
        saveAppModeSetting()
        updateStyle()
    }
    
    func saveAppModeSetting() {
        userDefaults.set(isDarkmode, forKey: Keys.isDarkmode)
    }
    
    func checkAppModeSetting() {
        let appModeSetting = userDefaults.bool(forKey: Keys.isDarkmode)
        if appModeSetting {
            isDarkmode = true
            updateStyle()
        }
    }
    
}

public extension UIView {
    func edgeTo(_ view: UIView){
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    func pinMenuTo(_ view: UIView, with constant: CGFloat) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant).isActive = true
    }
}

