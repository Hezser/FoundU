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
        
    private let cellId = "cellId"
    private var timer: Timer?
    private var collectionview: UICollectionView!
    var posts: [Post]!
    
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
        collectionview.backgroundColor = .white
        collectionview.alwaysBounceVertical = true

        collectionview.register(PostCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! PostCell

        cell.titleLabel.text = posts[indexPath.row].title
        cell.placeLabel.text = posts[indexPath.row].place
        cell.userImageView.image = posts[indexPath.row].userPicture
        
    FIRDatabase.database().reference().child("users").child(posts[indexPath.row].userID).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            cell.nameLabel.text = (snapshot.value as! String)
        })
        
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
