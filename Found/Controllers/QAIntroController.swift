//
//  QAIntroView.swift
//  Found
//
//  Created by Sergio Hernandez on 28/09/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit

class QAIntroController: QAController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(handleLogIn))
        navigationItem.leftBarButtonItem = loginButton
    
        nextButton.isHidden = true
        
        let goButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 113.26, height: 70.0))
        goButton.layer.cornerRadius = 5
        goButton.setTitle("Go!", for: .normal)
        goButton.backgroundColor = #colorLiteral(red: 1, green: 0.6470588446, blue: 0.3098038733, alpha: 1)
        goButton.center = view.center
        view.addSubview(goButton)
        goButton.addTarget(self, action: #selector(goButtonPressed), for: .touchUpInside)
        
    }
    
    @objc func handleLogIn(_ sender: UIButton) {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    @objc func goButtonPressed(_ sender: UIButton) {
        goToNextView()
    }
    
}
