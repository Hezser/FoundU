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
    
    func handleTagDoubleTap(forTag tag: String) {
        //
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
        tagField.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20).isActive = true
        tagField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        tagField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        tagField.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        tagField.configure()
        tagField.setTags(tags)
        
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
