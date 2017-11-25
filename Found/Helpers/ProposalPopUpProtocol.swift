//
//  PopUpProtocol.swift
//  Found
//
//  Created by Sergio Hernandez on 15/11/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit

protocol ProposalPopUpController {
    
    var proposalPopUpView: ProposalPopUpView! { get set }
    var user: User! { get set }
    var post: Post! { get set }
    
    func dismissPopUp()
    func sendProposal(forPost: Post, time: String, date: String, place: String)
}
