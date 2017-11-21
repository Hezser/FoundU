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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 700)
        
        retrievePosts {
        
            self.setUpConvenienceDataForPosts {
                
                self.collectionview = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
                self.collectionview.dataSource = self
                self.collectionview.delegate = self
                self.view.addSubview(self.collectionview)

                self.view.backgroundColor = .white
                self.collectionview.backgroundColor = .white
                self.collectionview.alwaysBounceVertical = true

                self.collectionview.register(PostCell.self, forCellWithReuseIdentifier: self.cellId)
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // Posts will need to be retrieved using pagination when the scope of the app scalates. If not, the time needed to download all the posts will be too large
    func retrievePosts(completed: @escaping FinishedDownload) {
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        let ref = FIRDatabase.database().reference().child("posts")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            for post in snapshot.children.allObjects as! [FIRDataSnapshot] {
                if self.type == .user && post.childSnapshot(forPath: "userID").value as? String == uid {
                    self.posts.append(Post(post))
                } else if self.type == .feed && post.childSnapshot(forPath: "userID").value as? String != uid {
                    self.posts.append(Post(post))
                }
            }
            completed()
        })
    }

    func setUpConvenienceDataForPosts(completed: @escaping FinishedDownload) {
        for post in posts {
            FIRDatabase.database().reference().child("users").child(post.userID).observeSingleEvent(of: .value, with: { (snapshot) in
                post.userName = (snapshot.childSnapshot(forPath: "name").value as! String)
                post.userDescription = (snapshot.childSnapshot(forPath: "short self description").value as! String)
                let url = (snapshot.childSnapshot(forPath: "pictureURL").value as! String)
                self.transformURLIntoImage(urlString: url, post: post, completion: {
                    completed()
                })
            })
        }
    }
    
    func transformURLIntoImage(urlString: String, post: Post, completion completed: @escaping FinishedDownload) {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                post.userPicture = UIImage(data: data!)
                completed()
            }
            
        }).resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! PostCell

        cell.titleLabel.text = posts[indexPath.row].title
        cell.placeLabel.text = posts[indexPath.row].place
        cell.userImageView.image = posts[indexPath.row].userPicture
        cell.nameLabel.text = posts[indexPath.row].userName
        
        // Basing us on the format of the date and time, we can divide the string into two
        // If date is "Anytime" we use the Anytime Exceptional Label and leave the time and date labels empty (invisible)
        let datetime = posts[indexPath.row].time!
        if datetime == "Anytime" {
            cell.anytimeExceptionalLabel.text = "Anytime"
        } else {
            cell.anytimeExceptionalLabel.text = ""
            let shortenedDateTime = shortenDateFormat(for: datetime)
            let commaIndex = shortenedDateTime.indexDistance(of: ",") // We use a shorter format for cells (eg: "Sep" instead of "September")
            cell.dateLabel.text = shortenedDateTime[0...commaIndex!-1]
            cell.timeLabel.text = shortenedDateTime[commaIndex!+2...shortenedDateTime.count-1]
        }
        
        return cell
    }
    
    func shortenDateFormat(for string: String) -> String {
        
        let longFormatter = DateFormatter()
        let shortFormatter2 = DateFormatter()
        longFormatter.dateFormat = "EEE dd LLLL, HH:mm"
        shortFormatter2.dateFormat = "EEE dd LLL, HH:mm"
        let date = longFormatter.date(from: string)
        return shortFormatter2.string(from: date!)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 175)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let post = posts[indexPath.row]
        
        let postController = PostController()
        postController.user = User(id: post.userID, completion: { () -> () in
            postController.post = post
            postController.view.backgroundColor = .white
            postController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(postController, animated: true)
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    fileprivate func attemptReloadOfTable() {
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    @objc func handleReloadTable() {
        
        // This will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async(execute: {
            self.collectionview.reloadData()
        })
    }
    
}
