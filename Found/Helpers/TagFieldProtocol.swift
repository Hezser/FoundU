//
//  TagFieldProtocol.swift
//  Found
//
//  Created by Sergio Hernandez on 03/01/2018.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

protocol TagFieldHandler {
    
    var tagField: TagField! { get set }
    
    func handleTagSingleTap(forTag tag: String)
    
    func handleTagDoubleTap(forTag tag: String)
}
