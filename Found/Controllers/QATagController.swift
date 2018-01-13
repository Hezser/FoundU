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
            addDataToProfile(data: tagCreationController.getTags())
        }
        else if situation == .postCreation {
            addDataToPost(data: tagCreationController.getTags())
        }
        goToNextView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tagCreationController.activateSearchBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        tagCreationController.deactivateSearchBar()
    }
    
    override func setUpUI() {
        super.setUpUI()
        
        addChildViewController(tagCreationController)
        view.addSubview(tagCreationController.view)
        
        view.layoutIfNeeded()
        tagCreationController.setDistanceFromTop(to: questionTextView.frame.size.height - 30) // -30 of distance with top
        
        // Tag Creation Controller Constraints
        tagCreationController.view.topAnchor.constraint(equalTo: questionTextView.bottomAnchor, constant: 30).isActive = true
        tagCreationController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tagCreationController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tagCreationController.view.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -15).isActive = true
        
        tagCreationController.configureTagField()
        
    }
}
