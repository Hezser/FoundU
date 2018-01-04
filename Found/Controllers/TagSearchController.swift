//
//  TagSearchController.swift
//  Found
//
//  Created by Sergio Hernandez on 24/12/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
import Firebase

class TagSearchController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    typealias FinishedDownload = () -> ()
    
    let cellId = "cellId"
    
    public var handler: TagSearchHandler!
    
    private var searchController: UISearchController!
    
    private var numberOfResults = 10  // Maximum number of results
    private var tags = [String]()
    private var filteredTags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsMultipleSelectionDuringEditing = true

        tableView.register(ConversationCell.self, forCellReuseIdentifier: cellId)
        
        retrieveTags(completion: {
            
            self.searchController = UISearchController(searchResultsController: nil)
            self.searchController.hidesNavigationBarDuringPresentation = false
            
            // The object responsible for updating the contents of the search results controller.
            self.searchController.searchResultsUpdater = self
            
            // Determines whether the underlying content is dimmed during a search.
            // if we are presenting the display results in the same view, this should be false
            self.searchController.dimsBackgroundDuringPresentation = false
            
            // Make sure the that the search bar is visible within the navigation bar.
            self.searchController.searchBar.delegate = self
            self.searchController.searchBar.sizeToFit()
            self.searchController.searchBar.tintColor = Color.lightOrange
            self.searchController.searchBar.placeholder = "Search your tags"
            self.searchController.searchBar.returnKeyType = .send
            self.searchController.searchBar.searchBarStyle = .minimal
    
            // Include the search controller's search bar within the table's header view.
            self.tableView.tableHeaderView = self.searchController.searchBar
            
            self.definesPresentationContext = true
            
            return
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // To eliminate the gray color of the bouncing area
        for view in tableView.subviews {
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
        for tag in tags {
            let lowercasedTag = tag.lowercased()
            if lowercasedTag.contains(search!) {
                filteredTags.append(tag)
            }
        }
        
        print(filteredTags)
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTags.count > numberOfResults ? numberOfResults : filteredTags.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        numberOfResults = filteredTags.count > 10 ? 10 : filteredTags.count
        if indexPath.row < filteredTags.count {
            cell.textLabel?.text = filteredTags[indexPath.row]
        }
        
        return cell
    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let handler = handler {
            handler.handleCellSelection(forTag: filteredTags[indexPath.row])
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
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
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.endEditing(true)
    }
    
}
