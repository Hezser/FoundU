//
//  QAIntroView.swift
//  Found
//
//  Created by Sergio Hernandez on 28/09/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit

class QAIntroView: QAView {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let goButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 113.26, height: 70.0))
        goButton.center = view.center
        goButton.layer.cornerRadius = 5
        goButton.setTitle("Go!", for: .normal)
        goButton.backgroundColor = #colorLiteral(red: 1, green: 0.6470588446, blue: 0.3098038733, alpha: 1)
        goButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(goButton)
    }
    
    @objc func nextButtonPressed(_ sender: UIButton) {
        goToNextView()
    }
    
}
