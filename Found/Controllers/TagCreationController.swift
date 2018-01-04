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
    
    func handleTagSelection(forTag tag: String) {
        tagField.removeTag(tag)
    }
    
    func handleCellSelection(forTag tag: String) {
        tagField.addTag(tag)
    }
    
    public func configureTagField() {
        tagField.configure()
    }
    
    private func setUpUI() {
        
        addChildViewController(tagSearcher)
        view.addSubview(tagSearcher.view)
        view.addSubview(tagField)
        
        let margins = view.layoutMarginsGuide
        
        tagField.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20).isActive = true
        tagField.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        tagField.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10).isActive = true
        tagField.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 1/4).isActive = true
        
        tagSearcher.view.topAnchor.constraint(equalTo: tagField.bottomAnchor, constant: 10).isActive = true
        tagSearcher.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tagSearcher.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tagSearcher.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
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
        tagField.handler = self
        
        setUpUI()
    }
    
}
