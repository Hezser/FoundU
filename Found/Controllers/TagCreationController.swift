//
//  TagCreationController.swift
//  Found
//
//  Created by Sergio Hernandez on 31/12/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit

class TagCreationController: UIViewController, TagFieldHandler, TagSearchHandler {
    
    internal var tagSearcher: TagSearchController!
    internal var tagField: TagField!
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
    
    public func setDistanceFromTop(to distance: CGFloat) {
        distanceFromTop = distance
    }
    
    public func getTags() -> [String] {
        return tagField.getTags()
    }
    
    public func configureTagField() {
        tagField.configure()
    }
    
    public func deactivateSearchBar() {
        tagSearcher.deactivateSearchBar()
    }
    
    public func activateSearchBar() {
        tagSearcher.activateSearchBar()
    }
    
    private func setUpUI() {
        
        addChildViewController(tagSearcher)
        view.addSubview(tagSearcher.view)
        view.addSubview(tagField)
        
        tagSearcher.view.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -distanceFromTop).isActive = true
        tagSearcher.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tagSearcher.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tagSearcher.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tagField.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tagField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        tagField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        tagField.bottomAnchor.constraint(equalTo: tagSearcher.view.topAnchor, constant: -10).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Set Up Tag Searcher
        tagSearcher = TagSearchController()
        tagSearcher.handler = self
        
        // Set Up Tag Field
        tagField = TagField()
        tagField.isScrollable()
        tagField.setDoubleTapEnabled(to: false)
        tagField.handler = self
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
