//
//  MenuController.swift
//  Found
//
//  Created by Sergio Hernandez on 27/09/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
import Firebase

class MenuController: UITabBarController {
    
    var user: User!
    var itemToDisplay: Int!
    
    typealias FinishedDownload = () -> ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.veryLightOrange
        tabBar.barTintColor = Color.veryLightOrange
        tabBar.tintColor = Color.lightOrange
        tabBar.unselectedItemTintColor = .gray
        
        checkIfUserIsLoggedIn()
    }
    
    func addControllers() {
        
        let feed = PostListController()
        let feedNavigationController = UINavigationController(rootViewController: feed)
        feedNavigationController.navigationBar.barTintColor = Color.lightOrange
        feedNavigationController.navigationBar.tintColor = .white
        feedNavigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        feedNavigationController.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        feed.title = "Feed"
        feed.type = .feed
        feed.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Feed"), tag: 0)
        feed.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        let messages = MessagesListController()
        let messagesNavigationController = UINavigationController(rootViewController: messages)
        messagesNavigationController.navigationBar.barTintColor = Color.lightOrange
        messagesNavigationController.navigationBar.tintColor = .white
        messagesNavigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        messagesNavigationController.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        messages.title = "Messages"
        messages.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Message"), tag: 1)
        messages.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        let newPost = NewPostController()
        let newPostNavigationController = UINavigationController(rootViewController: newPost)
        newPostNavigationController.navigationBar.barTintColor = Color.lightOrange
        newPostNavigationController.navigationBar.tintColor = .white
        newPostNavigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        newPostNavigationController.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        newPost.user = user
        newPost.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Add"), tag: 2)
        newPost.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        let userPosts = PostListController()
        let userPostsNavigationController = UINavigationController(rootViewController: userPosts)
        userPostsNavigationController.navigationBar.barTintColor = Color.lightOrange
        userPostsNavigationController.navigationBar.tintColor = .white
        userPostsNavigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        userPostsNavigationController.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        userPosts.title = "Your Posts"
        userPosts.type = .user
        userPosts.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "UserPosts"), tag: 3)
        userPosts.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        let profile = ProfileController()
        let profileNavigationController = UINavigationController(rootViewController: profile)
        profileNavigationController.navigationBar.barTintColor = Color.lightOrange
        profileNavigationController.navigationBar.tintColor = .white
        profileNavigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        profileNavigationController.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        profile.user = user
        profile.mainProfile = true
        profile.title = "You"
        profile.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "User"), tag: 4)
        profile.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
            
        viewControllers = [ feedNavigationController, messagesNavigationController, newPostNavigationController, userPostsNavigationController, profileNavigationController ]
        
        selectedIndex = itemToDisplay
    }
    
    // This function prevents the app from crashing in low internet speeds if the pictures are retrieved faster than they are downloaded
//    func downloadPictures(completed: @escaping FinishedDownload) {
//
//        var processesCompleted = 0
//        var postsUpdated = 0
//        var userPicture: UIImage!
//
//        // User Posts
//        FIRDatabase.database().reference().child("users").child(user.id!).child("pictureURL").observeSingleEvent(of: .value, with: { (snapshot) in
//            let url = URL(string: snapshot.value as! String)
//            let data = try? Data(contentsOf: url!)
//            userPicture = UIImage(data: data!)
//            for post in self.userPosts {
//                post.userPicture = userPicture
//            }
//            processesCompleted += 1
//            if processesCompleted == 2 {
//                completed()
//            }
//        })
//
//        // Feed Posts
//        for post in feedPosts {
//            FIRDatabase.database().reference().child("users").child(post.userID).child("pictureURL").observeSingleEvent(of: .value, with: { (snapshot) in
//                let url = URL(string: snapshot.value as! String)
//                let data = try? Data(contentsOf: url!)
//                post.userPicture = UIImage(data: data!)
//
//                postsUpdated += 1
//                if postsUpdated == self.numberOfFeedPosts {
//                    processesCompleted += 1
//                    if processesCompleted == 2 {
//                        completed()
//                    }
//                }
//            })
//        }
//    }
    
//    // Posts will need to be retrieved using pagination when the scope of the app scalates. If not, the time needed to download all the posts will be too large
//    func retrievePosts(completed: @escaping FinishedDownload) {
//        
//        let ref = FIRDatabase.database().reference().child("posts")
//        ref.observeSingleEvent(of: .value, with: { snapshot in
//            for post in snapshot.children.allObjects as! [FIRDataSnapshot] {
//                if post.childSnapshot(forPath: "userID").value as? String != self.user.id {
//                    self.feedPosts.append(Post(post))
//                    self.numberOfFeedPosts += 1
//                } else {
//                    self.userPosts.append(Post(post))
//                    self.numberOfUserPosts += 1
//                }
//            }
//            completed()
//        })
//    }
    
//    func getNumberOfPosts(completed: @escaping FinishedDownload) {
//
//        // Get the number of total posts and then get the number of current user's posts and subtract it to the first one, because we do not want to show the user's posts in the feed
//        let userID = FIRAuth.auth()?.currentUser?.uid
//        var n: Int!
//
//        let ref1 = FIRDatabase.database().reference(fromURL: "https://found-87b59.firebaseio.com/").child("posts")
//        let ref2 = FIRDatabase.database().reference(fromURL: "https://found-87b59.firebaseio.com/").child("users").child(userID!).child("posts")
//
//        ref1.observe(.value, with: { (snapshot: FIRDataSnapshot!) in
//            n = Int(snapshot.childrenCount)
//            ref2.observe(.value, with: { (snapshot: FIRDataSnapshot!) in
//                self.numberOfUserPosts = Int(snapshot.childrenCount)
//                self.numberOfFeedPosts = n - self.numberOfUserPosts
//                print("\nI finished calculating number of feed posts. \(self.numberOfFeedPosts!) posts were found\n")
//                completed()
//            })
//        })
//    }
    
    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            print("\nUser is not logged in\n")
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            print("\nUser is successfully logged in\n")
            User.setCurrentUser(forID: (FIRAuth.auth()?.currentUser?.uid)!)
            user = User(id: (FIRAuth.auth()?.currentUser?.uid)!, completion: {
                self.addControllers()
            })
        }
    }
    
    @objc func handleLogout() {
        // Sign Out
        logOut()
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    fileprivate func logOut() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
    }
}
