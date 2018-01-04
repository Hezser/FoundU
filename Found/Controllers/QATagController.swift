//
//  QATagController.swift
//  Found
//
//  Created by Sergio Hernandez on 03/01/2018.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit

class QATagController: QAController {
    
    var tagCreationController: TagCreationController = {
        let controller = TagCreationController()
        return controller
    }()
    
    override func nextPressed(sender: UIButton!) {
        if situation == .profileCreation {
            //
        }
        else if situation == .postCreation {
            //
        }
        goToNextView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUpUI() {
        super.setUpUI()
        
        addChildViewController(tagCreationController)
        view.addSubview(tagCreationController.view)
        
        // Tag Creation Controller Constraints
        tagCreationController.view.topAnchor.constraint(equalTo: questionLabel.bottomAnchor).isActive = true
        tagCreationController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tagCreationController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tagCreationController.view.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -15).isActive = true
        
        tagCreationController.configureTagField()
        
    }
}
