//
//  PopUpProtocol.swift
//  Found
//
//  Created by Sergio Hernandez on 15/11/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit

protocol PopUpController {
    
    var popUpView: PopUpView! { get set }
    var user: User! { get set }
    var post: Post! { get set }
    
    func dismissPopUp()
    func sendProposal(forPost: Post, time: String, date: String, place: String)
}
