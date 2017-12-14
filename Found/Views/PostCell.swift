//
//  PostCell.swift
//  Found
//
//  Created by Sergio Hernandez on 16/10/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit


class PostCell: UICollectionViewCell, UITextViewDelegate {
    
    var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var titleTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 22)
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainerInset = .zero
        textView.isUserInteractionEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var nameTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var placeTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainerInset = .zero
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isUserInteractionEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // Used to not have to rearrange all other labels when "Anytime" is shown instead of date and time separately. This label will be empty (invisible) if there is a specific date and time for the post
    var anytimeExceptionalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func calculateHeight() -> CGFloat {
        layoutIfNeeded()
        var sum = CGFloat(56) // Spacing between views + divider line height + 15 bottom spacing + 10 upper spacing
        sum += userImageView.frame.size.height
        sum += titleTextView.contentSize.height
        if placeTextView.contentSize.height > (dateLabel.frame.size.height + timeLabel.frame.size.height) || anytimeExceptionalLabel.text == "Anytime" {
            sum += placeTextView.contentSize.height
        } else {
            sum += dateLabel.frame.size.height + timeLabel.frame.size.height
        }
        return sum
    }
    
    func setUpUI() {
        
        let dividerLine = DividerLine()
        
        addSubview(dividerLine)
        addSubview(userImageView)
        addSubview(nameTextView)
        addSubview(titleTextView)
        addSubview(dateLabel)
        addSubview(timeLabel)
        addSubview(placeTextView)
        addSubview(anytimeExceptionalLabel)

        let margins = layoutMarginsGuide
        
        // Name Text View Constraints
        nameTextView.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor).isActive = true
        nameTextView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        nameTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // Profile Image View Constraints
        userImageView.rightAnchor.constraint(equalTo: nameTextView.leftAnchor, constant: -5).isActive = true
        userImageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 10).isActive = true
        userImageView.heightAnchor.constraint(equalTo: nameTextView.heightAnchor, multiplier: 2).isActive = true
        userImageView.widthAnchor.constraint(equalTo: userImageView.heightAnchor).isActive = true
        
        // Title Text View Constraints
        titleTextView.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 5).isActive = true
        titleTextView.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -20).isActive = true
        titleTextView.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 20).isActive = true
        
        // Date Label Constraints
        dateLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 2/5).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 20).isActive = true
        
        // Time Label Constraints
        timeLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 2/5).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
        
        // Any Time Exceptional Label Constraints
        anytimeExceptionalLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 2/5).isActive = true
        anytimeExceptionalLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        anytimeExceptionalLabel.rightAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        anytimeExceptionalLabel.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 20).isActive = true
        
        // Place Text View Constraints
        placeTextView.leftAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        placeTextView.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 2/5).isActive = true
        placeTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 20).isActive = true
        
        // Divider Line Constraints
        dividerLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        dividerLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerLine.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        dividerLine.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        
        layoutIfNeeded()
        userImageView.setRounded()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
