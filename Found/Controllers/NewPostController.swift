//
//  NewPostController.swift
//  Found
//
//  Created by Sergio Hernandez on 22/09/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
import Firebase

class NewPostController: UIViewController {
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.veryLightOrange
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        createChainOfQAViews()
    }
    
    func createChainOfQAViews() {

        // Questions in order
        let question1 = "To put it as a title, what would you like to talk about?"
        let question2 = "Which topics will you be addressing? Choose you tags."
        let question3 = "Where would you like to meet? You can leave it blank if you'd meet anywhere."
        let question4 = "Is there any time in particular that suits you best?"
        let question5 = "Why this topic? Is there anything else you want to say?"
        
        // Initializing the QAViews with their questions
        let menu = MenuController()
        menu.itemToDisplay = 3
        let qa5 = QAOneFieldController()
        qa5.situation = .postCreation
        qa5.variable = .details
        qa5.lastView = true
        qa5.question = question5
        qa5.nextView = menu
        let qa4 = QADatePickController()
        qa4.situation = .postCreation
        qa4.variable = .time
        qa4.question = question4
        qa4.nextView = qa5
        let qa3 = QAOneFieldController()
        qa3.situation = .postCreation
        qa3.variable = .place
        qa3.question = question3
        qa3.nextView = qa4
        let qa2 = QATagController()
        qa2.situation = .postCreation
        qa2.variable = .title
        qa2.question = question2
        qa2.nextView = qa3
        let qa1 = QAOneFieldController()
        qa1.situation = .postCreation
        qa1.variable = .title
        qa1.firstView = true
        qa1.question = question1
        qa1.nextView = qa2
        let post = Post()
        post.userID = FIRAuth.auth()?.currentUser?.uid
        qa1.newPost = post
        
        navigationController?.pushViewController(qa1, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
