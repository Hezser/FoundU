//
//  QAView.swift
//  Found
//
//  Created by Sergio Hernandez on 22/09/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
import Firebase

class QAController: UIViewController {
    
    typealias FinishedDownload = () -> ()
    
    var profileCreatorController: ProfileCreatorController!
    
    var lastView = false
    var firstView = false
    var situation: Situation!
    var variable: Variable?
    var newPost: Post!
    var nextView: UIViewController!
    var question: String!
    
    var questionTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 18)
        textView.isSelectable = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.setTitle("Next!", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = Color.lightOrange
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.veryLightOrange
        
        setUpUI()
        setUpButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if situation != .profileCreation {
            navigationItem.largeTitleDisplayMode = .never
            tabBarController?.tabBar.isHidden = true
            if firstView {
                let nilButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
                navigationItem.leftBarButtonItem = nilButton
            }
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelButtonPressed))
            navigationItem.rightBarButtonItem = cancelButton
        }
    }
    
    func setUpButtons() {
        nextButton.addTarget(self, action: #selector(self.nextPressed), for: .touchUpInside)
    }
    
    func setUpUI() {
        
        questionTextView.text = question
        view.addSubview(questionTextView)
        view.addSubview(nextButton)
        
        let margins = view.layoutMarginsGuide
        
        // Question Label Constraints
        questionTextView.widthAnchor.constraint(equalTo: margins.widthAnchor, constant: -20).isActive = true
        questionTextView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 30).isActive = true
        questionTextView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true

        // Next Button Constraints
        nextButton.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 2/5).isActive = true
        nextButton.heightAnchor.constraint(equalTo: nextButton.widthAnchor, multiplier: 1/2).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -30).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        
    }
    
    @objc func cancelButtonPressed(sender: UIButton!) {
        let menu = MenuController()
        menu.itemToDisplay = 0
        present(menu, animated: true, completion: nil)
    }
    
    // Determines the type of data a QAView is providing when creating a profile, and returns the key-value pair which will go in the Firebase Database
    func addDataToProfile(data: Any) {

        if variable == .age {
            profileCreatorController.user.age = Int((data as? String)!)
        }
        else if variable == .dateOfBirth {
            profileCreatorController.user.dateOfBirth = data as? String
        }
        else if variable == .picture {
            profileCreatorController.user.profileImageURL = data as? String
        }
        else if variable == .place {
            profileCreatorController.user.place = data as? String
        }
        else if variable == .tags {
            profileCreatorController.user.tags = data as! [String]
        }
        else if variable == .work {
            profileCreatorController.user.work = data as? [String]
        }
        else if variable == .studies {
            profileCreatorController.user.studies = data as? [String]
        }
        else if variable == .bio {
            profileCreatorController.user.bio = data as? String
        }

        else {
            print("An error has ocurred during the evaluation of the data provided and the database will not be able to be updated")
        }
        
    }
    
    // Determines the type of data a QAView is providing when creating a post, and updates the post with that data
    func addDataToPost(data: Any?) {
        
        if variable == .title {
            newPost.title = data as? String
        }
        else if variable == .tags {
            newPost.tags = data as? [String]
        }
        else if variable == .place {
            if data as? String == "" {
                newPost.place = "Anywhere"
            } else {
                newPost.place = data as? String
            }
        }
        else if variable == .time {
            var timeString: String!
            if data == nil {
                newPost.time = "Anytime"
            } else {
                let time = data as! Date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE dd LLLL, HH:mm"
                timeString = dateFormatter.string(from: time)
                newPost.time = timeString
            }
        }
        else if variable == .details {
            newPost.details = data as? String
        }
    }
    
    func uploadPostToDatabase(post: Post, completion completed: @escaping FinishedDownload) {
        
        let ref = FIRDatabase.database().reference(fromURL: "https://found-87b59.firebaseio.com/")
        
        let newPostRef = ref.child("posts").childByAutoId() // Also returns the autoID given to the new post
        let data = ["userID": post.userID!,
                    "title": post.title!,
                    "tags" : post.tags!,
                    "place": post.place!,
                    "time": post.time!,
                    "details": post.details!] as [String : Any]
        newPostRef.updateChildValues(data, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            print("Post was saved succesfully into the Firebase Database -- Posts Section")
            completed()
        })
    }
    
    @objc func nextPressed(sender: UIButton!) {
        // Functionality will depend on the type of data the specific QAView is dealing with (maps, text fields...)
    }
    
    func goToNextView() {
        // If this is the last QAView. Next view will be the menu
        if lastView == true {
            if situation == .postCreation {
                uploadPostToDatabase(post: newPost, completion: {
                    self.present(self.nextView, animated: true, completion: nil)
                })
            } else {
                profileCreatorController.createUser()
            }
        }
        // If there is a following QAView
        else {
            let nextQA = nextView as! QAController
            if situation == .postCreation {
                nextQA.newPost = self.newPost
                navigationController?.pushViewController(nextQA, animated: true)
            } else {
                navigationController?.pushViewController(nextQA, animated: true)
            }
        }
    }
}
