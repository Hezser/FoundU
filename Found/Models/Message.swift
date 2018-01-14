//
//  Message.swift
//  FoundU
//

import UIKit
import Firebase

class Message: NSObject {

    var messageID: String!
    var fromID: String!
    var text: String?
    var timestamp: NSNumber!
    var toID: String!
    var imageURL: String?
    var videoURL: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    var postID: String?
    var status: String?
    var title: String?
    var place: String?
    var time: String?
    var date: String?
    
    // Convenience variables, not present at database but setup dinamically to speedup UI
    var userPicture: UIImage?
    var userName: String?
    
    init(withID ID: String, snapshot: FIRDataSnapshot) {
        
        self.messageID = ID
        self.fromID = snapshot.childSnapshot(forPath: "fromId").value as? String
        self.toID = snapshot.childSnapshot(forPath: "toId").value as? String
        self.timestamp = snapshot.childSnapshot(forPath: "timestamp").value as? NSNumber
        
        // Normal message
        self.text = snapshot.childSnapshot(forPath: "text").value as? String
        
        // Image
        self.imageURL = snapshot.childSnapshot(forPath: "imageUrl").value as? String
        self.imageWidth = snapshot.childSnapshot(forPath: "imageWidth").value as? NSNumber
        self.imageHeight = snapshot.childSnapshot(forPath: "imageHeight").value as? NSNumber
        
        // Video
        self.videoURL = snapshot.childSnapshot(forPath: "videoUrl").value as? String
        
        // Proposal
        self.postID = snapshot.childSnapshot(forPath: "postID").value as? String
        self.status = snapshot.childSnapshot(forPath: "status").value as? String
        self.title = snapshot.childSnapshot(forPath: "title").value as? String
        self.place = snapshot.childSnapshot(forPath: "place").value as? String
        self.time = snapshot.childSnapshot(forPath: "time").value as? String
        self.date = snapshot.childSnapshot(forPath: "date").value as? String
    }
    
    func chatPartnerID() -> String? {
        return fromID == FIRAuth.auth()?.currentUser?.uid ? toID : fromID
    }
    
}
