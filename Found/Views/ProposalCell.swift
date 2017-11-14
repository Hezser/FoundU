//
//  ProposalCell.swift
//  Found
//
//  Created by Sergio Hernandez on 13/11/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit

class ProposalCell: UICollectionViewCell {
    
    var decision: String!
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor.black.cgColor
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
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(handleAcceptance), for: .touchUpInside)
        return button
    }()
    
    let counterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(handleCountering), for: .touchUpInside)
        return button
    }()
    
    let declineButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(handleDeclination), for: .touchUpInside)
        return button
    }()
    
    @objc func handleAcceptance() {
        
    }
    
    @objc func handleCountering() {
        
    }
    
    @objc func handleDeclination() {
        
    }
    
    func setBackgroundColor(for decision: String?) {
        
        if decision == "Accepted" {
            backgroundColor = .green
        } else if decision == "Countered" {
            backgroundColor = .orange
        } else if decision == "Declined" {
            backgroundColor = .red
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
        if decision == "" {
            print("\nAdding Buttons\n")
            containerView.addSubview(acceptButton)
            containerView.addSubview(counterButton)
            containerView.addSubview(declineButton)
        }
        
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
        dateLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 1/2).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: placeLabel.bottomAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // Time Label Constraints
        timeLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 1/2).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: placeLabel.bottomAnchor).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        if decision == "" {
            
            // Accept Button Constraints
            acceptButton.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 1/3).isActive = true
            acceptButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
            acceptButton.heightAnchor.constraint(equalTo: acceptButton.widthAnchor, multiplier: 1/1.618034).isActive = true
            acceptButton.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
            
            // Counter Button Constraints
            counterButton.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 1/3).isActive = true
            counterButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
            counterButton.heightAnchor.constraint(equalTo: counterButton.widthAnchor, multiplier: 1/1.618034).isActive = true
            counterButton.leftAnchor.constraint(equalTo: acceptButton.leftAnchor).isActive = true
            
            // Decline Button Constraints
            declineButton.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 1/3).isActive = true
            declineButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
            declineButton.heightAnchor.constraint(equalTo: declineButton.widthAnchor, multiplier: 1/1.618034).isActive = true
            declineButton.leftAnchor.constraint(equalTo: counterButton.leftAnchor).isActive = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setBackgroundColor(for: decision)
        
        addSubview(containerView)
        
        setUpUI(for: decision)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
