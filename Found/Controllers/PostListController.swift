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
        cell.nameLabel.text = posts[indexPath.row].userName
        cell.placeLabel.text = posts[indexPath.row].place
        cell.userImageView.image = posts[indexPath.row].userPicture
        
        // Basing us on the format of the date and time, we can divide the string into two
        // If date is "Anytime" we use the Anytime Exceptional Label and leave the time and date labels empty (invisible)
        let datetime = posts[indexPath.row].time
        if datetime == "Anytime" {
            cell.anytimeExceptionalLabel.text = "Anytime"
        } else {
            let date = datetime![0...9]
            let time = datetime![12...16]
            cell.dateLabel.text = date
            cell.timeLabel.text = time
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 175)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let post = posts[indexPath.row]
        
        let postController = PostController()
        postController.user = User(id: post.userID, completion: { () -> () in
            postController.post = post
            postController.view.backgroundColor = .white // Setting background color is needed, otherwise I get a completely black screen (???)
            postController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(postController, animated: true)
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}

extension String {
    
    subscript (r: CountableClosedRange<Int>) -> String? {
        get {
            guard r.lowerBound >= 0, let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound, limitedBy: self.endIndex),
                let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound, limitedBy: self.endIndex) else { return nil }
            return String(self[startIndex...endIndex])
        }
    }
}
