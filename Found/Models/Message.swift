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
    var decision: String?
    var title: String?
    var place: String?
    var time: String?
    var date: String?
    
    init(ID: String, dictionary: [String: Any]) {
        
        self.messageID = ID
        self.fromID = dictionary["fromId"] as? String
        self.toID = dictionary["toId"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
        
        // Normal message
        self.text = dictionary["text"] as? String
        
        // Image
        self.imageURL = dictionary["imageUrl"] as? String
        self.imageWidth = dictionary["imageWidth"] as? NSNumber
        self.imageHeight = dictionary["imageHeight"] as? NSNumber
        
        // Video
        self.videoURL = dictionary["videoUrl"] as? String
        
        // Proposal
        self.postID = dictionary["postID"] as? String
        self.decision = dictionary["decision"] as? String
        self.title = dictionary["title"] as? String
        self.place = dictionary["place"] as? String
        self.time = dictionary["time"] as? String
        self.date = dictionary["date"] as? String
    }
    
    func chatPartnerID() -> String? {
        return fromID == FIRAuth.auth()?.currentUser?.uid ? toID : fromID
    }
    
}
