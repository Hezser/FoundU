//
//  TagSearchController.swift
//  Found
//
//  Created by Sergio Hernandez on 24/12/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
import Firebase

class TagSearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    typealias FinishedDownload = () -> ()
    
    let cellId = "cellId"
    
    public var handler: TagSearchHandler!
    
    private var searchController: UISearchController!
    private var tableview: UITableView!
    
    private var numberOfResults = 10  // Maximum number of results
    private var tags = [String]()
    private var filteredTags = [String]()
    
    public func deactivateSearchBar() {
        DispatchQueue.main.async {
            self.searchController.searchBar.isHidden = true
        }
    }
    
    public func activateSearchBar() {
        DispatchQueue.main.async {
            self.searchController.searchBar.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Table View Set Up
        tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = .clear
        tableview.separatorStyle = .singleLine
        tableview.tableFooterView = UIView(frame: CGRect.zero)
        tableview.allowsMultipleSelectionDuringEditing = true
        tableview.register(ConversationCell.self, forCellReuseIdentifier: cellId)
        
        // Search Controller Set Up
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false

        // Search Bar Set Up
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = Color.lightOrange
        searchController.searchBar.placeholder = "Search your tags"
        searchController.searchBar.returnKeyType = .send
        searchController.searchBar.searchBarStyle = .minimal
        
        setUpUI()
        
        retrieveTags(completion: {
            return
        })
        
    }
    
    private func setUpUI() {
        
        view.addSubview(searchController.searchBar)  // Constraints for the search bar result in strange behaviour when it is tapped
        
        view.addSubview(tableview)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        tableview.topAnchor.constraint(equalTo: view.topAnchor, constant: searchController.searchBar.frame.size.height).isActive = true
        tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // To eliminate the gray color of the bouncing area
        for view in tableview.subviews {
            view.backgroundColor = .clear
        }
    }
    
    private func retrieveTags(completion completed: @escaping FinishedDownload) {
        
        FIRDatabase.database().reference().child("tags").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                self.tags.append((child as! FIRDataSnapshot).key)
            }
            completed()
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {

        if !searchController.isActive {
            return
        }
        
        let search = searchController.searchBar.text?.lowercased()
        filteredTags = []
        
        if search == "" {
            filteredTags = tags
            DispatchQueue.main.async(execute: {
                self.tableview.reloadData()
            })
            return
        }
        
        for tag in tags {
            let lowercasedTag = tag.lowercased()
            if lowercasedTag.contains(search!) {
                filteredTags.append(tag)
            }
        }
        
        DispatchQueue.main.async{
            self.tableview.reloadData()
        }
        return

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTags.count > numberOfResults ? numberOfResults : filteredTags.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        numberOfResults = filteredTags.count > 10 ? 10 : filteredTags.count
        if indexPath.row < filteredTags.count {
            cell.textLabel?.text = filteredTags[indexPath.row]
        }
        
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let handler = handler {
            handler.handleCellSelection(forTag: filteredTags[indexPath.row])
        }
        
        tableview.deselectRow(at: indexPath, animated: true)
        
        return
    }
    
    // New Tag
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let text = searchController.searchBar.text {
            if text.count > 1 {
                
                // Add to tagField
                if let handler = handler {
                    handler.handleCellSelection(forTag: text)
                }
                
                // Add to tags
                if !tags.contains(text) {
                    tags.append(text)
                }
                
                // Add to database
                FIRDatabase.database().reference().child("tags").observeSingleEvent(of: .value, with: { (snapshot) in
                    if !snapshot.hasChild(text) {
                        FIRDatabase.database().reference().child("tags").updateChildValues([text: 1])
                    }
                })
            }
        }
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.endEditing(true)
    }
    
}
