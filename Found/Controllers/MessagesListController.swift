//
//  ViewController.swift
//  FoundU
//

import UIKit
import Firebase

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class MessagesListController: UITableViewController {
    
    typealias FinishedDownload = () -> ()

    let cellId = "cellId"
    var timer: Timer?
    private var locked = false // Prevents many postControllers to be pushed if several taps are made very quickly

    var messages = [Message]()
    var messagesDictionary = [String : Message]() // Used to group messages by partner, so we can select which message to show
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = Color.veryLightOrange
        
        tableView.register(ConversationCell.self, forCellReuseIdentifier: cellId)
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
        // For security reasons
        messages.removeAll()
        messagesDictionary.removeAll()
        
        // Set up listeners
        listenForNewMessages() // Including new conversations
        listenForDeletedConversations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        locked = false
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // To delete conversations
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let message = self.messages[indexPath.row]
        if let chatPartnerID = message.chatPartnerID() {
            // Remove user-messages part of the current user
            FIRDatabase.database().reference().child("user-messages").child(uid).child(chatPartnerID).removeValue(completionBlock: { (error, ref) in
                
                if error != nil {
                    print("Failed to delete message:", error!)
                    return
                }
                
                self.messagesDictionary.removeValue(forKey: chatPartnerID)
                // This will crash because of background thread, so lets call this on dispatch_async main thread
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            })
            
            // Remove user-messages part of the partner user
            FIRDatabase.database().reference().child("user-messages").child(chatPartnerID).child(uid).removeValue(completionBlock: { (error, ref) in
                
                if error != nil {
                    print("Failed to delete message:", error!)
                    return
                }
            })
            
            // Remove each message involving both users
            FIRDatabase.database().reference().child("messages").observeSingleEvent(of: .value, with: { (snapshot) in
                if let messages = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for message in messages {
                        let fromID = message.childSnapshot(forPath: "fromId").value as! String
                        let toID = message.childSnapshot(forPath: "toId").value as! String
                        if (fromID == uid && toID == chatPartnerID) || (fromID == chatPartnerID && toID == uid) {
                            FIRDatabase.database().reference().child("messages").child(message.key).removeValue()
                        }
                    }
                }
            })
        }
    }
    
    func downloadPicture(withURL url: String, toMessage message: Message, completion completed: @escaping FinishedDownload) {
        
        // Otherwise fire off a new download
        let url = URL(string: url)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            // Download hit an error so lets return out
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: url as AnyObject)
                    message.userPicture = downloadedImage
                    completed()
                }
            })
            
        }).resume()
    }
    
    func listenForNewMessages() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("user-messages").child(uid).observe(.childAdded, with: { (snapshot) in
            let partnerID = snapshot.key
            FIRDatabase.database().reference().child("user-messages").child(uid).child(partnerID).observe(.childAdded, with: { (snapshot) in
                let messageID = snapshot.key
                FIRDatabase.database().reference().child("messages").child(messageID).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let newMessage = Message(withID: messageID, snapshot: snapshot)
                    let oldMessage = self.messagesDictionary[partnerID]
                    if newMessage.timestamp?.int32Value > oldMessage?.timestamp?.int32Value {
                        
                        let ref = FIRDatabase.database().reference().child("users").child(partnerID)
                        ref.observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            if let dictionary = snapshot.value as? [String: AnyObject] {
                                newMessage.userName = dictionary["name"] as? String
                                
                                if let profileImageURL = dictionary["pictureURL"] as? String {
                                    self.downloadPicture(withURL: profileImageURL, toMessage: newMessage, completion: {
                                        self.messagesDictionary[partnerID] = newMessage
                                        self.messages = Array(self.messagesDictionary.values)
                                        // This will crash because of background thread, so lets call this on dispatch_async main thread
                                        DispatchQueue.main.async(execute: {
                                            self.tableView.reloadData()
                                        })
                                    })
                                }
                            }
                            
                        })
                    }
                })
            })
        })
        
    }
    
    func listenForDeletedConversations() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("user-messages").child(uid).observe(.childRemoved, with: { (snapshot) in
            self.messagesDictionary.removeValue(forKey: snapshot.key)
            self.messages = Array(self.messagesDictionary.values)
            // This will crash because of background thread, so lets call this on dispatch_async main thread
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        })
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ConversationCell
        
        let message = messages[indexPath.row]
        cell.message = message
        cell.setUpContent()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !locked {
            self.locked = true
            let message = messages[indexPath.row]
            
            guard let chatPartnerId = message.chatPartnerID() else {
                return
            }
            
            let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
            chatController.user = User(id: chatPartnerId, completion: {
                self.navigationController?.pushViewController(chatController, animated: true)
            })
        }
    }
    
    func sendProposal(to user: User, post: Post, title: String, place: String, date: String, time: String) {
        let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.user = user
        chatController.post = post
        chatController.sendProposal(forPost: post, time: time, date: date, place: place)
        navigationController?.pushViewController(chatController, animated: true)
    }

}

