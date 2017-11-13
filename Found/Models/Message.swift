//
//  Message.swift
//  FoundU
//

import UIKit
import Firebase

class Message: NSObject {

    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    var imageUrl: String?
    var videoUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    var decision: String?
    var title: String?
    var place: String?
    var time: String?
    var date: String?
    
    init(dictionary: [String: Any]) {
        self.fromId = dictionary["fromId"] as? String
        self.toId = dictionary["toId"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
        
        // Normal message
        self.text = dictionary["text"] as? String
        
        // Image
        self.imageUrl = dictionary["imageUrl"] as? String
        self.imageWidth = dictionary["imageWidth"] as? NSNumber
        self.imageHeight = dictionary["imageHeight"] as? NSNumber
        
        // Video
        self.videoUrl = dictionary["videoUrl"] as? String
        
        // Proposal
        self.decision = dictionary["decision"] as? String
        self.title = dictionary["title"] as? String
        self.place = dictionary["place"] as? String
        self.time = dictionary["time"] as? String
        self.date = dictionary["date"] as? String
    }
    
    func chatPartnerId() -> String? {
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
    }
    
}
