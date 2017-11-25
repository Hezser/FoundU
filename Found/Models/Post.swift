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
    
    typealias FinishedDownload = () -> ()
    
    var id: String!
    var userID: String!
    var title: String!
    var place: String!
    var time: String!
    var details: String!
    // Convenience variables, only set in postListController
    var userDescription: String?
    var userName: String?
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
        
    }
    
    func setUpConvenienceData(completed: @escaping FinishedDownload) {
        FIRDatabase.database().reference().child("users").child(self.userID).observeSingleEvent(of: .value, with: { (snapshot) in
            self.userName = (snapshot.childSnapshot(forPath: "name").value as! String)
            self.userDescription = (snapshot.childSnapshot(forPath: "short self description").value as! String)
            let url = (snapshot.childSnapshot(forPath: "pictureURL").value as! String)
            self.transformURLIntoImage(urlString: url, completion: {
                completed()
            })
        })
    }
    
    func transformURLIntoImage(urlString: String, completion completed: @escaping FinishedDownload) {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.userPicture = UIImage(data: data!)
                completed()
            }
            
        }).resume()
    }
}
