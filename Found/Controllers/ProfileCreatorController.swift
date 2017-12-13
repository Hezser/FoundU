//
//  ProfileCreatorController.swift
//  Found
//
//  Created by Sergio Hernandez on 25/11/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
import Firebase

class ProfileCreatorController: UIViewController {
    
    typealias FinishedDownload = () -> ()
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstName = getFirstName(of: user.name!)
        
        let intro = "Hey \(firstName)! It is very nice to have you here. I will ask you some questions, and once you answer them you'll be all set up! Keep in mind you can change any of this at any time later in your profile. Ready?"
        let question1 = "I think we should start by getting to know each other better. I guess a good first step would be to be able to see each other's faces."
        let question2 = "Nice! I was born a bit over a year ago, when were you born?"
        let question3 = "Well, that is quite an age difference, but I think we'll get along well anyway. I would also love to hear a short description of yourself, something other people will see at first glance when you use me. Keep it at tweet-length!"
        let question4 = "That'll get you attention! Now, where are you from?"
        let question5 = "Home sweet home. Would you like to tell me a bit about your education? You can tell me a maximum of three places you've studied at. This is an optional one, so you can skip it by simply going forward."
        let question6 = "What about your working life? You can tell me a maximum of three places you've worked at. This is also an optional one, so you can skip it by simply going forward."
        
        let qa6 = QAThreeFieldsController()
        qa6.situation = .profileCreation
        qa6.variable = .work
        qa6.lastView = true
        qa6.profileCreatorController = self
        qa6.question = question6
        qa6.title = "6/6"
        qa6.nextView = nil
        let qa5 = QAThreeFieldsController()
        qa5.situation = .profileCreation
        qa5.variable = .studies
        qa5.profileCreatorController = self
        qa5.question = question5
        qa5.title = "5/6"
        qa5.nextView = qa6
        let qa4 = QAOneFieldController()
        qa4.situation = .profileCreation
        qa4.variable = .place
        qa4.profileCreatorController = self
        qa4.question = question4
        qa4.title = "4/6"
        qa4.nextView = qa5
        let qa3 = QAOneFieldController()
        qa3.situation = .profileCreation
        qa3.variable = .bio
        qa3.profileCreatorController = self
        qa3.question = question3
        qa3.title = "3/6"
        qa3.nextView = qa4
        let qa2 = QADatePickController()
        qa2.situation = .profileCreation
        qa2.variable = .age
        qa2.profileCreatorController = self
        qa2.question = question2
        qa2.title = "2/6"
        qa2.nextView = qa3
        let qa1 = QAImageController()
        qa1.situation = .profileCreation
        qa1.variable = .picture
        qa1.profileCreatorController = self
        qa1.question = question1
        qa1.title = "1/6"
        qa1.nextView = qa2
        let introController = QAIntroController()
        introController.situation = .profileCreation
        introController.profileCreatorController = self
        introController.question = intro
        introController.nextView = qa1
        
        navigationController?.pushViewController(introController, animated: true)
        
    }
    
    fileprivate func getFirstName(of name: String) -> String {
        var firstName = ""
        for char in name {
            if char == " " {
                return firstName
            }
            firstName.append(char)
        }
        return firstName
    }
    
    func createUser() {
        
        registerUser(completion: {
            guard let id = FIRAuth.auth()?.currentUser?.uid else {
                print("The user id is not valid in the database")
                return
            }
            let data = ["name" : self.user.name!, "age" : String(self.user.age!), "date of birth" : self.user.dateOfBirth!, "email" : self.user.email!, "password" : self.user.password!, "bio" : self.user.bio!, "place" : self.user.place!, "pictureURL" : self.user.profileImageURL!, "work" : self.user.work!, "studies" : self.user.studies!] as [String : Any]
            FIRDatabase.database().reference(fromURL: "https://found-87b59.firebaseio.com/").child("users").child(id).updateChildValues(data, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
                print("Data was saved succesfully into the Firebase Database")
                let menu = MenuController()
                menu.itemToDisplay = 0
                menu.user = self.user
                self.present(menu, animated: true, completion: nil)
            })
        })
        
    }
    
    fileprivate func registerUser(completion completed: @escaping FinishedDownload) {
        
        FIRAuth.auth()?.createUser(withEmail: user.email!, password: user.password!, completion: { (user: FIRUser?, error) in
            if error != nil {
                print(error!)
                completed()
                return
            }
            
            // Register user in Firebase Database
            guard let id = user?.uid else {
                print("The user id is not valid in the database")
                completed()
                return
            }
            
            let values = ["name": self.user.name!, "email": self.user.email!, "password": self.user.password!]
            FIRDatabase.database().reference(fromURL: "https://found-87b59.firebaseio.com/").child("users").child(id).updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err!)
                    completed()
                    return
                }
                print("User was saved succesfully into the Firebase Database")
                completed()
            })
        })
    }
}
