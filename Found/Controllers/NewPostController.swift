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
        
        createChainOfQAViews()
    }
    
    func createChainOfQAViews() {

        // Questions in order
        let question1 = "So, to put it as a title, what would you like to talk about?"
        let question2 = "Where would you like to meet? You can leave it blank if you'd meet anywhere."
        let question3 = "Is there any time in particular that suits you best?"
        let question4 = "Is there anything else you want to say? You could tell me more about the specifics of the matter, your experience in this topic... Up to you!"
        
        // Initializing the QAViews with their questions
        let menu = MenuController()
        let qa4 = QARegularView()
        qa4.situation = .postCreation
        qa4.variable = .details
        qa4.answerSize = 150
        qa4.lastView = true
        qa4.question = question4
        qa4.nextView = menu
        let qa3 = QADatePickView()
        qa3.situation = .postCreation
        qa3.variable = .time
        qa3.question = question3
        qa3.nextView = qa4
        let qa2 = QARegularView()
        qa2.situation = .postCreation
        qa2.variable = .place
        qa2.question = question2
        qa2.nextView = qa3
        let qa1 = QARegularView()
        qa1.situation = .postCreation
        qa1.variable = .title
        qa1.question = question1
        qa1.nextView = qa2
        let post = Post()
        post.userID = FIRAuth.auth()?.currentUser?.uid
        post.userName = user.name
        post.userPictureURL = user.profileImageURL
        post.userDescription = user.shortDescription
        qa1.newPost = post
        
        present(qa1, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
