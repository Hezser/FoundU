//
//  QAView.swift
//  Found
//
//  Created by Sergio Hernandez on 22/09/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
import Firebase

class QAView: UIViewController {
    
    enum Situation {
        case profileCreation
        case postCreation
    }
    
    enum Variable {
        case age
        case place
        case work
        case picture
        case studies
        case shortSelfDescription
        case longSelfDescription
        case title
        case time
        case details
    }
    
    typealias FinishedDownload = () -> ()
    
    // By default, the view is not the last one
    var lastView = false
    var situation: Situation!
    var variable: Variable?
    var nextView: UIViewController!
    var question: String!
    var nextButton: UIButton!
    var newPost: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let margins = view.layoutMarginsGuide
        
        // Create a cancel button (not when creating profile)
        if situation != .profileCreation {
            let cancelButton = UIButton()
            cancelButton.backgroundColor = #colorLiteral(red: 0.9331143498, green: 0.134441793, blue: 0, alpha: 1)
            cancelButton.setTitle("Cancel", for: .normal)
            cancelButton.layer.cornerRadius = 5
            cancelButton.clipsToBounds = true
            cancelButton.translatesAutoresizingMaskIntoConstraints = false
            cancelButton.addTarget(self, action: #selector(self.cancelButtonPressed), for: .touchUpInside)
            self.view.addSubview(cancelButton)
            
            cancelButton.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 1/5).isActive = true
            cancelButton.heightAnchor.constraint(equalTo: cancelButton.widthAnchor, multiplier: 1/1.6).isActive = true
            cancelButton.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 20).isActive = true
            cancelButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20).isActive = true
        }
        // Create question label programatically
        let questionLabel = UILabel()
        questionLabel.textAlignment = .center
        questionLabel.text = question
        questionLabel.numberOfLines = 7
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(questionLabel)
        
        questionLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, constant: -10).isActive = true
        questionLabel.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 1/4).isActive = true
        questionLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 50).isActive = true
        questionLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
     
        // Create next button unless view is introView (cannot figure out how to negate an "is", god damnit)
        if self is QAIntroView { nextButton = nil } else {
            self.nextButton = UIButton()
            self.nextButton.setTitle("Next!", for: .normal)
            self.nextButton.layer.cornerRadius = 5
            nextButton.backgroundColor = #colorLiteral(red: 1, green: 0.6470588446, blue: 0.3098038733, alpha: 1)
            nextButton.clipsToBounds = true
            nextButton.translatesAutoresizingMaskIntoConstraints = false
            nextButton.addTarget(self, action: #selector(self.nextPressed), for: .touchUpInside)
            view.addSubview(self.nextButton)
            
            nextButton.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 2/5).isActive = true
            nextButton.heightAnchor.constraint(equalTo: nextButton.widthAnchor, multiplier: 1/2).isActive = true
            nextButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -75).isActive = true
            nextButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        }
            
    }
    
    @objc func cancelButtonPressed(sender: UIButton!) {
        let menu = MenuController()
        present(menu, animated: true, completion: nil)
    }
    
    // Should use @escaping completion, just in case profile is trying to be retrieved before uploading to Firebase
    func writeProfileInfoToFirebaseDatabase(data: Any) {
        let ref = FIRDatabase.database().reference(fromURL: "https://found-87b59.firebaseio.com/")
        guard let id = FIRAuth.auth()?.currentUser?.uid else {
            print("The user id is not valid in the database")
            return
        }
        let userRef = ref.child("users").child(id)
        let value = createDataForProfile(value: data, type: variable!)
        userRef.updateChildValues(value, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            print("Data was saved succesfully into the Firebase Database")
        })
    }
    
    // Determines the type of data a QAView is providing when creating a profile, and returns the key-value pair which will go in the Firebase Database
    func createDataForProfile(value: Any, type: Variable) -> Dictionary<String, Any> {
        if type == .age {
            return ["age":value]
        }
        if type == .picture {
            return ["pictureURL":value]
        }
        else if type == .place {
            return ["place":value]
        }
        else if type == .work {
            return ["work":value]
        }
        else if type == .studies {
            return ["studies":value]
        }
        else if type == .shortSelfDescription {
            return ["short self description":value]
        }
        else if type == .longSelfDescription {
            return ["long self description":value]
        }
        print("An error has ocurred during the evaluation of the data provided and the database will not be able to be updated")
        return ["":""]
    }
    
    // Determines the type of data a QAView is providing when creating a post, and updates the post with that data
    func addDataToPost(value: Any?, type: Variable) {
        if type == .title {
            newPost.title = value as? String
        }
        else if type == .place {
            if value as? String == "" {
                newPost.place = "Anywhere"
            } else {
                newPost.place = value as? String
            }
        }
        else if type == .time {
            var timeString: String!
            if value == nil {
                newPost.time = "Anytime"
            } else {
                let time = value as! Date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE dd MMM, hh:mm"
                timeString = dateFormatter.string(from: time)
                newPost.time = timeString
            }
        }
        else if type == .details {
            newPost.details = value as? String
        }
    }
    
    func uploadPostToDatabase(post: Post, completion completed: @escaping FinishedDownload) {
        
        let ref = FIRDatabase.database().reference(fromURL: "https://found-87b59.firebaseio.com/")
        
        let newPostRef = ref.child("posts").childByAutoId() // Also returns the autoID given to the new post
        let data = ["userID": post.userID!,
                    "title": post.title!,
                    "place": post.place!,
                    "time": post.time!,
                    "details": post.details!,
                    "userName" : post.userName,
                    "userPictureURL" : post.userPictureURL,
                    "userDescription" : post.userDescription]
        newPostRef.updateChildValues(data as! [String:String], withCompletionBlock: { (err, ref) in
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
        // If this is the last QAView
        if lastView == true {
            if situation == .postCreation {
                uploadPostToDatabase(post: newPost, completion: {
                    self.present(self.nextView, animated: true, completion: nil)
                })
            } else {
                let menu = MenuController()
                present(menu, animated: true, completion: nil)
            }
        }
        // If there is a following QAView
        else {
            let nextQA = nextView as! QAView
            if situation == .postCreation {
                nextQA.newPost = self.newPost
            }
            present(nextQA, animated: true, completion: nil)
        }
    }
}
