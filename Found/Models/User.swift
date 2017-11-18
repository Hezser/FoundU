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
    
    var id: String?
    var email: String?
    var password: String?
    var name: String?
    var age: Int?
    var place: String?
    var profileImageURL: String?
    var shortDescription: String?
    var longDescription: String?
    var work: [String]?
    var studies: [String]?
    
    required override init() {
        super.init()
    }
    
    init(id: String, completion completed: FinishedDownload?) {
        super.init()
        
        self.id = id
        
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            self.email = value?["email"] as? String
            self.password = value?["password"] as? String
            self.name = value?["name"] as? String ?? "nameless"
            self.age = Int(value?["age"] as? String ?? "-1")
            self.place = value?["place"] as? String ?? "homeless"
            self.profileImageURL = value?["pictureURL"] as? String ?? ""
            self.shortDescription = value?["short self description"] as? String ?? "shortdescriptionless"
            self.longDescription = value?["long self description"] as? String ?? "longdescriptionless"
            //            self.work = value?["work"] as? [String] ?? ["pennyless"]
            //            self.studies = value?["studies"] as? [String] ?? ["brainless"]
            
            print("\nUser was successfully loaded\n")
            if completed != nil {
                completed!()
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }

}

