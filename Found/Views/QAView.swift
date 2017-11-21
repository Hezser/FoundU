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
    
    typealias FinishedDownload = () -> ()
    
    var lastView = false
    var firstView = false
    var situation: Situation!
    var variable: Variable?
    var newPost: Post!
    var nextView: UIViewController!
    var question: String!
    
    var questionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 7
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next!", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = #colorLiteral(red: 1, green: 0.6470588446, blue: 0.3098038733, alpha: 1)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
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
        
        questionLabel.text = question
        view.addSubview(questionLabel)
        view.addSubview(nextButton)
        
        let margins = view.layoutMarginsGuide
        
        // Question Label Constraints
        questionLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, constant: -10).isActive = true
        questionLabel.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 1/4).isActive = true
        questionLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 50).isActive = true
        questionLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true

        // Next Button Constraints
        nextButton.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 2/5).isActive = true
        nextButton.heightAnchor.constraint(equalTo: nextButton.widthAnchor, multiplier: 1/2).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -75).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        
    }
    
    @objc func cancelButtonPressed(sender: UIButton!) {
        let menu = MenuController()
        present(menu, animated: true, completion: nil)
    }
    
    // Should use @escaping completion, just in case profile is trying to be retrieved before uploading to Firebase
    func writeProfileInfoToFirebaseDatabase(data: Any, completion completed: FinishedDownload?) {
        
        let ref = FIRDatabase.database().reference(fromURL: "https://found-87b59.firebaseio.com/")
        guard let id = FIRAuth.auth()?.currentUser?.uid else {
            print("The user id is not valid in the database")
            completed?()
            return
        }
        let userRef = ref.child("users").child(id)
        let value = createDataForProfile(value: data, type: variable!)
        userRef.updateChildValues(value, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                completed?()
                return
            }
            completed?()
            print("Data was saved succesfully into the Firebase Database")
        })
    }
    
    // Determines the type of data a QAView is providing when creating a profile, and returns the key-value pair which will go in the Firebase Database
    func createDataForProfile(value: Any, type: Variable) -> Dictionary<String, Any> {
        
        if type == .age {
            return ["age":value]
        }
        else if type == .dateOfBirth {
            return ["date of birth":value]
        }
        else if type == .picture {
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
                dateFormatter.dateFormat = "EEE dd LLLL, HH:mm"
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
                    "details": post.details!]
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
                self.present(self.nextView, animated: true, completion: nil)
            }
        }
        // If there is a following QAView
        else {
            let nextQA = nextView as! QAView
            if situation == .postCreation {
                nextQA.newPost = self.newPost
                navigationController?.pushViewController(nextQA, animated: true)
            } else {
                present(nextQA, animated: true, completion: nil)
            }
        }
    }
}
