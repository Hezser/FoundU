//
//  TagCreationController.swift
//  Found
//
//  Created by Sergio Hernandez on 31/12/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
import Firebase

class TagCreationController: UIViewController, TagFieldHandler, TagSearchHandler {
    
    internal var tagSearcher: TagSearchController!
    internal var tagField: TagField!
    private var id: String!
    private var entity: Entity!
    private var distanceFromTop: CGFloat! {
        didSet {
            setUpUI()
        }
    }
    
    func handleTagSingleTap(forTag tag: String) {
        tagField.removeTag(tag)
    }
    
    func handleTagDoubleTap(forTag tag: String) {
        //
    }
    
    func handleCellSelection(forTag tag: String) {
        tagField.addTag(tag)
    }
    
    public func setID(_ id: String, of entity: Entity) {
        self.id = id
        self.entity = entity
    }
    
    public func setDistanceFromTop(to distance: CGFloat) {
        distanceFromTop = distance
    }
    
    public func getTags() -> [String] {
        return tagField.getTags()
    }
    
    public func configureTagField() {
        tagField.configure()
    }
    
    public func setTags(to tags: [String]?) {
        if let initialTags = tags {
            tagField.setTags(initialTags)
        }
    }
    
    public func addTag(_ tag: String?) {
        if let newTag = tag {
            tagField.addTag(newTag)
        }
    }
    
    public func configureNavigationBar() {
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSave))
        navigationItem.rightBarButtonItem = saveButton
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "Edit Tags"
        tabBarController?.tabBar.isHidden = true
        navigationItem.largeTitleDisplayMode = .never
    }
    
    public func deactivateSearchBar() {
        tagSearcher.deactivateSearchBar()
    }
    
    public func activateSearchBar() {
        tagSearcher.activateSearchBar()
    }
    
    @objc func handleSave(_ sender: UIButton) {
//        var reference: String
//        if entity == .user {
//            reference = "users"
//        } else {
//            reference = "posts"
//        }
//
//        
//
//        let data: [String : Int]
//        for tag in tagField.getTags() {
//            data[tag] = data ? 1
//        }
//
//        FIRDatabase.database().reference().child(reference).child(id).child("tags").updateChildValues(tagField.getTags())
    }
    
    @objc func handleCancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpUI() {
        
        // Set Up Tag Searcher
        tagSearcher = TagSearchController()
        tagSearcher.handler = self
        
        // Set Up Tag Field
        tagField = TagField()
        tagField.isScrollable()
        tagField.setDoubleTapEnabled(to: false)
        tagField.handler = self
        
        addChildViewController(tagSearcher)
        view.addSubview(tagSearcher.view)
        view.addSubview(tagField)
        
        tagSearcher.view.topAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor, constant: -distanceFromTop).isActive = true
        tagSearcher.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tagSearcher.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tagSearcher.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tagField.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        tagField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        tagField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        tagField.bottomAnchor.constraint(equalTo: tagSearcher.view.topAnchor, constant: -10).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        activateSearchBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        deactivateSearchBar()
    }
    
}
