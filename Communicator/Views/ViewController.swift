//
//  ViewController.swift
//  Communicator
//
//  Created by Kacper Marciszewski on 05/04/2025.
//

import UIKit





class ViewController: UIViewController {
    
    var isMenuOpen = false
    lazy var sideInMenuPadding: CGFloat = self.view.frame.width * 0.7
    lazy var settingsButton = UIBarButtonItem(image: UIImage(systemName: "sidebar.leading") , style: .done, target: self, action: #selector (toggleMenu))
   
    
    // MARK: - MenuViewController

    lazy var menuViewController: SideMenuView = {
            let menuVC = SideMenuView()
            addChild(menuVC)
            view.addSubview(menuVC.view)
            menuVC.didMove(toParent: self)
            return menuVC
    }()
    // MARK: - ChatViewController
    lazy var chatViewController: ChatViewController = {
            let chatVC = ChatViewController()
            addChild(chatVC)
            view.addSubview(chatVC.view)
            chatVC.didMove(toParent: self)
            return chatVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAppModeSetting()
        NotificationCenter.default.addObserver(self, selector: #selector(updateStyle), name: .darkModeChanged, object: nil)

        view.addSubview(chatViewController.view)
        view.addSubview(menuViewController.view)
        setupLayout()
        navigationItem.setLeftBarButton(settingsButton, animated: true)
        
        title = "Byczek"
      //  checkAppModeSetting()
        
    }
    private func setupLayout() {
        menuViewController.view.frame = CGRect(x: -sideInMenuPadding, y: 0, width: sideInMenuPadding, height: view.frame.height)
            chatViewController.view.frame = view.bounds
        }
        
    @objc func toggleMenu() {
            
        let isOpening = !isMenuOpen
        let newX = isOpening ? 0 : -sideInMenuPadding

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.menuViewController.view.frame.origin.x = newX
            } completion: { _ in
                self.isMenuOpen.toggle()
            }
            
            
    }

    
}






