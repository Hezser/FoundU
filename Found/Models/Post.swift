//
//  Post.swift
//  Found
//
//  Created by Sergio Hernandez on 02/10/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import Foundation
import Firebase

class Post: NSObject {
    
    var id: String!
    var userID: String!
    var title: String!
    var place: String!
    var time: String!
    var details: String!
    var userName: String!
    var userPictureURL: String!
    var userDescription: String!
    var userPicture: UIImage?
    
    required override init() {
        super.init()
    }
    
    // May need to create a completion handler as in the User class' init
    init(_ post: FIRDataSnapshot) {
        super.init()
        
        id = post.key
        userID = post.childSnapshot(forPath: "userID").value as? String
        title = post.childSnapshot(forPath: "title").value as? String
        place = post.childSnapshot(forPath: "place").value as? String
        time = post.childSnapshot(forPath: "time").value as? String
        details = post.childSnapshot(forPath: "details").value as? String
        userName = post.childSnapshot(forPath: "userName").value as? String
        userPictureURL = post.childSnapshot(forPath: "userPictureURL").value as? String
        userDescription = post.childSnapshot(forPath: "userDescription").value as? String
        
    }
}
