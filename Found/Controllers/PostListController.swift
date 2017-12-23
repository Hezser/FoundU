//
//  FeedController.swift
//  Found
//
//  Created by Sergio Hernandez on 16/10/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
import Firebase

class PostListController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    typealias FinishedDownload = () -> ()
        
    private let cellId = "cellId"
    private var timer: Timer?
    private var collectionview: UICollectionView!
    final var type: PostListType!
    private var posts = [Post]()
    private var sizesOfCells = [CGFloat]()
    private var initialLoad = true
    private var refreshControl = UIRefreshControl()
    private var locked = false // Prevents many postControllers to be pushed if several taps are made very quickly
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 700)
                
        collectionview = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        view.addSubview(collectionview)

        view.backgroundColor = .white
        collectionview.backgroundColor = Color.veryLightOrange
        collectionview.alwaysBounceVertical = true
        
        collectionview.register(PostCell.self, forCellWithReuseIdentifier: self.cellId)
        
        if type == .feed {
            listenForNewPosts()
            listenForEditedPosts()
            listenForDeletedPosts()
        } else {
            loadPostsOnce()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        locked = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func loadPostsOnce() {
        
        posts = [] // Because when posts are edited or deleted I call this function again, and it would show posts twice (or more times) otherwise
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            for postData in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let post = Post(postData)
                if post.userID! == uid {
                    post.setUpConvenienceData {
                        self.posts.insert(post, at: 0)
                        let cell = PostCell(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
                        let configuredCell = self.configure(cell, withDataFrom: post)
                        let height = configuredCell.calculateHeight()
                        self.sizesOfCells.insert(height, at: 0)
                        DispatchQueue.main.async(execute: {
                            self.collectionview.reloadData()
                        })
                    }
                }
            }
        })
        
    }
    
    func listenForNewPosts() {
        
        // Add listener to watch out for new posts, incuding the initial ones displayed when first loaded
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
            if snapshot.childSnapshot(forPath: "userID").value as? String != uid {
                let post = Post(snapshot)
                post.setUpConvenienceData {
                    self.posts.insert(post, at: 0)
                    let cell = PostCell(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
                    let configuredCell = self.configure(cell, withDataFrom: post)
                    let height = configuredCell.calculateHeight()
                    self.sizesOfCells.insert(height, at: 0)
                    if self.initialLoad {
                        DispatchQueue.main.async(execute: {
                            self.collectionview.reloadData()
                        })
                    }
                }
            }
        })
        
        // Stop automatically reloading the data after 3 seconds (make sure everybody's internet connectivity is good enough such that this happens; however, they can always refresh after 3 seconds)
        let delay = Int(3 * Double(1000))
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay), execute: {
            print("\nStopped automatically reloading data on PostList\n")
            
            // Stop initial load of posts
            self.initialLoad = false
            
            // Add refresher
            self.refreshControl.tintColor = .white
            self.refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
            if #available(iOS 10.0, *) {
                self.collectionview.refreshControl = self.refreshControl
            } else {
                self.collectionview.addSubview(self.refreshControl)
            }
        })
        
    }
    
    func listenForDeletedPosts() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("posts").observe(.childRemoved, with: { (snapshot) in
            if snapshot.childSnapshot(forPath: "userID").value as? String != uid {
                for post in self.posts {
                    if post.id == snapshot.key {
                        let index = self.posts.index(of: post)
                        self.posts.remove(at: index!)
                        self.sizesOfCells.remove(at: index!)
                    }
                }
            }
        })
        
    }
    
    func listenForEditedPosts() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("posts").observe(.childChanged, with: { (snapshot) in
            if snapshot.childSnapshot(forPath: "userID").value as? String != uid {
                for post in self.posts {
                    if post.id == snapshot.key {
                        let index = self.posts.index(of: post)
                        self.posts.remove(at: index!)
                        self.sizesOfCells.remove(at: index!)
                        let editedPost = Post(snapshot)
                        editedPost.setUpConvenienceData {
                            self.posts.insert(editedPost, at: index!)
                            let cell = PostCell()
                            let configuredCell = self.configure(cell, withDataFrom: post)
                            self.sizesOfCells.insert(configuredCell.calculateHeight(), at: 0)
                        }
                    }
                }
            }
        })
        
    }
    
    @objc func refreshData() {
        DispatchQueue.main.async(execute: {
            self.collectionview.reloadData()
        })
        refreshControl.endRefreshing()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! PostCell
        let configuredCell = configure(cell, withDataFrom: posts[indexPath.row])
        return configuredCell
    }
    
    func shortenDateFormat(for string: String) -> String {
        
        let longFormatter = DateFormatter()
        let shortFormatter2 = DateFormatter()
        longFormatter.dateFormat = "EEE dd LLLL, HH:mm"
        shortFormatter2.dateFormat = "EEE dd LLL, HH:mm"
        let date = longFormatter.date(from: string)
        return shortFormatter2.string(from: date!)
        
    }
    
    fileprivate func configure(_ cell: PostCell, withDataFrom post: Post) -> PostCell {

        cell.titleTextView.text = post.title
        cell.placeTextView.text = post.place
        cell.userImageView.image = post.userPicture
        cell.nameTextView.text = post.userName
        
        // Basing us on the format of the date and time, we can divide the string into two
        // If date is "Anytime" we use the Anytime Exceptional Label and leave the time and date labels empty (invisible)
        let datetime = post.time!
        if datetime == "Anytime" {
            cell.anytimeExceptionalLabel.text = "Anytime"
            cell.dateLabel.text = ""
            cell.timeLabel.text = ""
        } else {
            cell.anytimeExceptionalLabel.text = ""
            let shortenedDateTime = shortenDateFormat(for: datetime)
            let commaIndex = shortenedDateTime.indexDistance(of: ",") // We use a shorter format for cells (eg: "Sep" instead of "September")
            cell.dateLabel.text = shortenedDateTime[0...commaIndex!-1]
            cell.timeLabel.text = shortenedDateTime[commaIndex!+2...shortenedDateTime.count-1]
        }
        
        cell.setUpUI()

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: sizesOfCells[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !locked {
            self.locked = true
            let post = posts[indexPath.row]
            
            let postController = PostController()
            postController.user = User(id: post.userID, completion: { () -> () in
                postController.post = post
                postController.hidesBottomBarWhenPushed = true
                postController.configure()
                self.navigationController?.pushViewController(postController, animated: true)
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
