//
//  ExistingTagSearchController.swift
//  Found
//
//  Created by Sergio Hernandez on 09/01/2018.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit
import Firebase

class ExistingTagSearchController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate, TagFieldHandler {
    
    typealias FinishedDownload = () -> ()
    
    private var searchController: UISearchController!
    internal var tagField: TagField!
    private var user: User!
    private var isMainProfile: Bool!
    
    public func setUser(to user: User) {
        self.user = user
    }
    public func isMainProfile(_ value: Bool) {
        isMainProfile = value
    }
    
    var upvotePopup: UIImageView = {
        let view = UIImageView()
        view.alpha = 0
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "upvoteImage")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = Color.strongOrange
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var tags = [String]()
    private var filteredTags = [String]()
    
    public func setInitialTags(to initialTags: [String]) {
        tags = initialTags
        if let field = tagField {
            field.setTags(tags)
        }
    }
    
    func handleTagSingleTap(forTag tag: String) {
        //
    }
    
    // Upvote/Downvote (only if not you)
    func handleTagDoubleTap(forTag tag: String) {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        if !isMainProfile {
            FIRDatabase.database().reference().child("users").child(uid).child("upvoted tags").child(self.user.id!).observeSingleEvent(of: .value, with: { (snapshot) in
                // If this tag has not already been upvoted
                if !snapshot.hasChild(tag) {
                    
                    self.upvoteAnimation()
                    self.tagField.addUpvotedTag(tag)
                    FIRDatabase.database().reference().child("users").child(self.user.id!).child("tags").child(tag).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        // Increase score
                        let score = snapshot.value as! Int
                        FIRDatabase.database().reference().child("users").child(self.user.id!).child("tags").child(tag).setValue(score + 1)
                        
                        // Add to the list of +1ed tags
                        FIRDatabase.database().reference().child("users").child(uid).child("upvoted tags").child(self.user.id!).child(tag).setValue(1)
                        
                        
                    })
                } else {
                    
                    self.tagField.removeUpvotedTag(tag)
                    FIRDatabase.database().reference().child("users").child(self.user.id!).child("tags").child(tag).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        // Decrease score
                        let score = snapshot.value as! Int
                        FIRDatabase.database().reference().child("users").child(self.user.id!).child("tags").child(tag).setValue(score - 1)
                        
                        // Remove from the list of +1ed tags
                        FIRDatabase.database().reference().child("users").child(uid).child("upvoted tags").child(self.user.id!).child(tag).removeValue()
                        
                    })
                }
            })
        }
    }
    
    func upvoteAnimation() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {() -> Void in
            self.upvotePopup.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.upvotePopup.alpha = 1.0
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction, animations: {() -> Void in
                self.upvotePopup.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: {(_ finished: Bool) -> Void in
                UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {() -> Void in
                    self.upvotePopup.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                    self.upvotePopup.alpha = 0.0
                }, completion: {(_ finished: Bool) -> Void in
                    self.upvotePopup.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            })
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.veryLightOrange
        
        // Search Controller Set Up
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        // Search Bar Set Up
        configureSearchBar()
        
        // Tag Field Set Up
        tagField = TagField()
        tagField.isScrollable()
        tagField.setDoubleTapEnabled(to: true)
        tagField.handler = self
        tagField.backgroundColor = .clear
        
        setUpUI()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.largeTitleDisplayMode = .never
        tabBarController?.tabBar.isHidden = true
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    private func configureSearchBar() {
        
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.tintColor = .white
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "_searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        let placeholder = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        placeholder?.textColor = .white
        searchController.searchBar.placeholder = "Search tags"
        searchController.searchBar.returnKeyType = .send
        searchController.searchBar.searchBarStyle = .minimal
        navigationItem.titleView = searchController.searchBar
        
    }
    
    private func setUpUI() {
        
        let margins = view.layoutMarginsGuide

        view.addSubview(tagField)
        view.addSubview(upvotePopup)
        
        tagField.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20).isActive = true
        tagField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        tagField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        tagField.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        tagField.configure()
        tagField.setTags(tags)
        tagField.setUpvotedTags(User.getCurrentUser()?.upvotedTags[user.id!])
        
        upvotePopup.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        upvotePopup.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        upvotePopup.widthAnchor.constraint(equalToConstant: 150).isActive = true
        upvotePopup.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if !searchController.isActive {
            return
        }
        
        let search = searchController.searchBar.text?.lowercased()
        filteredTags = []
        
        if search == "" {
            filteredTags = tags
            tagField.setTags(filteredTags)
            return
        }

        for tag in tags {
            let lowercasedTag = tag.lowercased()
            if lowercasedTag.contains(search!) {
                filteredTags.append(tag)
            }
        }
        
        tagField.setTags(filteredTags)
        return
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.endEditing(true)
    }
    
}
