//
//  TagSearchHandler.swift
//  Found
//
//  Created by Sergio Hernandez on 03/01/2018.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

protocol TagSearchHandler {
    
    var tagSearcher: TagSearchController! { get set }
    
    func handleCellSelection(forTag tag: String)
}
