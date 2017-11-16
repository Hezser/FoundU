//
//  ProposalCell.swift
//  Found
//
//  Created by Sergio Hernandez on 13/11/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
import Firebase

class ProposalCell: UICollectionViewCell {
    
    var message: Message!
    var chatController: ChatController!
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1/2
        view.layer.masksToBounds = true
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let placeLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.baselineAdjustment = .alignCenters
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let acceptButton: UIButton = {
        let button = UIButton()
        button.setTitle("Accept", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.7234831207, green: 1, blue: 0.6667848926, alpha: 1)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let counterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Counter", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.926276967, green: 0.7887039048, blue: 0.581957822, alpha: 1)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let declineButton: UIButton = {
        let button = UIButton()
        button.setTitle("Decline", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9492980647, green: 0.6576105266, blue: 0.677450324, alpha: 1)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func changeDecisionStatus(to decision: String) {
        let ref = FIRDatabase.database().reference().child("messages").child(message.messageID)
        ref.updateChildValues(["decision" : decision])
    }
    
    @objc func handleAcceptance(_ sender: UIButton) {
        
        print("\nProposal Accepted\n")
        
        // Notification actions (send event by email or something)
        
        // Set image of messagescontroller cell to acceptance one (white tick on green background with circle shape)
        
        containerView.backgroundColor = #colorLiteral(red: 0.7234831207, green: 1, blue: 0.6667848926, alpha: 1)
        acceptButton.isHidden = true
        counterButton.isHidden = true
        declineButton.isHidden = true
        
        frame.size.height = frame.size.height - acceptButton.frame.height
        
        changeDecisionStatus(to: "Accepted") // Posibly do this with uploading time accounting (the app wouldn't crash, but if the user goes back to messages and then back to the conversation quicker than the data is uplaoded, the decision wouldn't have changed
    }
    
    @objc func handleCountering(_ sender: UIButton) {
        
        chatController.setPost(forProposal: message, completion: { () -> () in
            self.chatController.presentPopUp(forCell: self)
        })
    }
    
    func counteringSuccessful() {
        
        print("\nProposal Countered\n")
        
        // Notification actions
        
        // Set image of messagescontroller cell to countering one (whatever white symbol on orange background with circle shape)
        
        containerView.backgroundColor = #colorLiteral(red: 0.926276967, green: 0.7887039048, blue: 0.581957822, alpha: 1)
        acceptButton.isHidden = true
        counterButton.isHidden = true
        declineButton.isHidden = true
        
        frame.size.height = frame.size.height - acceptButton.frame.height
        
        changeDecisionStatus(to: "Countered") // Posibly do this with uploading time accounting (the app wouldn't crash, but if the user goes back to messages and then back to the conversation quicker than the data is uplaoded, the decision wouldn't have changed
    }
    
    @objc func handleDeclination(_ sender: UIButton) {
        
        print("\nProposal Declined\n")
        
        // Notification actions (but only if user clicks yes on alert, of course)
        
        // Delete conversation upon confirming (a confirmation PopUp comes up to confirm you understand the consecuences of declining -> deleting the conversation, if you want to keep talking don't decline yet)
        chatController.deleteConversationByDeclining()
    }
    
    func setBackgroundColor(for decision: String?) {
        
        if decision == "Accepted" {
            containerView.backgroundColor = #colorLiteral(red: 0.7234831207, green: 1, blue: 0.6667848926, alpha: 1)
        } else if decision == "Countered" {
            containerView.backgroundColor = #colorLiteral(red: 0.926276967, green: 0.7887039048, blue: 0.581957822, alpha: 1)
        } else if decision == "Declined" {
            containerView.backgroundColor = #colorLiteral(red: 0.9492980647, green: 0.6576105266, blue: 0.677450324, alpha: 1)
        } else {
            // As of now, we keep the background color on default
        }
    }
    
    func setUpUI(for decision: String?) {
        
        // Container View constraints
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 3/4).isActive = true
        containerView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(placeLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(timeLabel)
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        if message.decision == "" && message.toID == uid {

            containerView.addSubview(acceptButton)
            containerView.addSubview(counterButton)
            containerView.addSubview(declineButton)
            bringSubview(toFront: acceptButton)
            bringSubview(toFront: counterButton)
            bringSubview(toFront: declineButton)
            acceptButton.addTarget(self, action: #selector(handleAcceptance), for: .touchUpInside)
            counterButton.addTarget(self, action: #selector(handleCountering), for: .touchUpInside)
            declineButton.addTarget(self, action: #selector(handleDeclination), for: .touchUpInside)
        }
    
        print("\nDecision is \(decision!)\n")
        
        setUpContainer()
    
    }
    
    func setUpContainer() {
        
        let margins = containerView.layoutMarginsGuide
        
        // Title Label Constraints
        titleLabel.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true // Ideally the height changes with the length of the litle (as well as the cell's height changing depending on the content) (same for place label)
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        
        // Place Label Constraints
        placeLabel.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        placeLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        placeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        placeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        
        // Date Label Constraints
        dateLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 1/3).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: placeLabel.bottomAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // Time Label Constraints
        timeLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 1/3).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: placeLabel.bottomAnchor).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        if message.decision == "" && message.toID == uid {
        
            // Accept Button Constraints
            acceptButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1/3).isActive = true
            acceptButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            acceptButton.heightAnchor.constraint(equalTo: acceptButton.widthAnchor, multiplier: 1/(1.618034*1.5)).isActive = true
            acceptButton.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true

            // Counter Button Constraints
            counterButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1/3).isActive = true
            counterButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            counterButton.heightAnchor.constraint(equalTo: counterButton.widthAnchor, multiplier: 1/(1.618034*1.5)).isActive = true
            counterButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true

            // Decline Button Constraints
            declineButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1/3).isActive = true
            declineButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            declineButton.heightAnchor.constraint(equalTo: declineButton.widthAnchor, multiplier: 1/(1.618034*1.5)).isActive = true
            declineButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        }
    }
    
    func configure() {
        
        titleLabel.text = message.title
        placeLabel.text = message.place
        timeLabel.text = message.time
        dateLabel.text = message.date
        
        setBackgroundColor(for: message.decision)
        
        addSubview(containerView)
        
        setUpUI(for: message.decision)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        acceptButton.removeTarget(nil, action: nil, for: .allEvents)
        counterButton.removeTarget(nil, action: nil, for: .allEvents)
        declineButton.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
