//
//  PostCell.swift
//  Found
//
//  Created by Sergio Hernandez on 16/10/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit


class PostCell: BaseCell {
    
    var containerView: UIView!
    
    var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.text = "I'd love hearing from your feedback on this app!"
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sergio Hernandez"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var placeLabel: UILabel = {
        let label = UILabel()
        label.text = "Nice Café @ London"
        label.font = UIFont.systemFont(ofSize: 16)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Used to not have to rearrange all other labels when "Anytime" is shown instead of date and time separately. This label will be empty (invisible) if there is a specific date and time for the post
    var anytimeExceptionalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupViews() {
        
        let dividerLine = DividerLine()
        
        addSubview(userImageView)
        addSubview(dividerLine)
        
        setupContainerView()

        let margins = self.layoutMarginsGuide
        
        // Profile Image View Constraints
        userImageView.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        userImageView.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: -10).isActive = true // the -10 depends on the height of the cell, and allows the user to percieve the image to be on the center of the posts, even if it's not on the center of the actual cell
        userImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        userImageView.widthAnchor.constraint(equalTo: userImageView.heightAnchor).isActive = true
        
        // Divider Line View Constraints
        dividerLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerLine.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        dividerLine.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        dividerLine.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
    }
    
    private func setupContainerView() {
        
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        var margins = self.layoutMarginsGuide

        // Container View Constraints
        containerView.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 90).isActive = true
        containerView.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(placeLabel)
        containerView.addSubview(anytimeExceptionalLabel)

        
        margins = containerView.layoutMarginsGuide
        
        // Name Label Constraints
        nameLabel.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        
        // Title Label Constraints
        titleLabel.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        
        // Time Label Constraints
        timeLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 1/3).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        // Date Label Constraints
        dateLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 1/3).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor).isActive = true
        
        // Place Label Constraints
        placeLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 2/3).isActive = true
        placeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        placeLabel.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        placeLabel.centerYAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true

        // Any Time Exceptional Label Constraints
        anytimeExceptionalLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 1/3).isActive = true
        anytimeExceptionalLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        anytimeExceptionalLabel.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        anytimeExceptionalLabel.centerYAnchor.constraint(equalTo: placeLabel.centerYAnchor).isActive = true
    }
    
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        // To be overriden
    }
}
