//
//  User.swift
//  Found
//
//  Created by Sergio Hernandez on 02/10/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
import Firebase

class User: NSObject {
    
    typealias FinishedDownload = () -> ()
    
    private static var currentUser: User?
    
    var id: String?
    var email: String?
    var password: String?
    var name: String?
    var age: Int?
    var dateOfBirth: String?
    var place: String?
    var profileImageURL: String?
    var bio: String?
    var tags = [String]()
    var upvotedTags = [String:[String]]()
    var work: [String]?
    var studies: [String]?
    
    public static func getCurrentUser() -> User? {
        return currentUser
    }
    public static func setCurrentUser(forID id: String) {
        User.currentUser = User(id: id, completion: nil)
    }
    public static func dismissCurrentUser() {
        User.currentUser = nil
    }
    
    public func firstName() -> String {
        
        if let name = self.name {
            var firstName = ""
            for char in name {
                if char == " " {
                    return firstName
                } else {
                    firstName.append(char)
                }
            }
        }
        return "Someone"
        
    }
    
    required override init() {
        super.init()
    }
    
    init(id: String, completion completed: FinishedDownload?) {
        super.init()

        self.id = id
    
        FIRDatabase.database().reference(fromURL: "https://found-87b59.firebaseio.com/").child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.email = value?["email"] as? String
            self.password = value?["password"] as? String
            self.name = value?["name"] as? String
            self.age = Int((value?["age"] as? String)!)
            self.dateOfBirth = value?["date of birth"] as? String
            self.place = value?["place"] as? String
            self.profileImageURL = value?["pictureURL"] as? String
            self.bio = value?["bio"] as? String
            for child in snapshot.childSnapshot(forPath: "tags").children {
                self.tags.append((child as! FIRDataSnapshot).key)
            }
            for child in snapshot.childSnapshot(forPath: "upvoted tags").children {
                var tagList = [String]()
                for tag in (child as! FIRDataSnapshot).children {
                    tagList.append((tag as! FIRDataSnapshot).key)
                }
                self.upvotedTags[(child as! FIRDataSnapshot).key] = tagList
            }
            self.work = value?["work"] as? [String]
            self.studies = value?["studies"] as? [String]
            
            print("\nUser was successfully loaded\n")
            if completed != nil {
                completed!()
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }

}

