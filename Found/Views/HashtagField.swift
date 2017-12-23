//
//  HashtagField.swift
//  Found
//
//  Created by Sergio Hernandez on 20/12/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
class HashtagField: UIView {
    
    private let height: CGFloat = 40
    
    private final var originalWidth: CGFloat!
    private var availableWidth: CGFloat!
    private var rows = [UIStackView]()
    private var rowsWidthConstraints = [NSLayoutConstraint]()
    private var hashtagViews = [UIButton]()
    private var hashtags = [String]()
    
    public func getNumberOfRows() -> Int {
        return self.rows.count
    }
    public func getHeight() -> CGFloat {
        return (CGFloat((50 * (rows.count - 1)) + 40)) // 40 is the height of each hastag, 10 the vertical spacing between hashtags (40+10=50)
    }
    public func getHashtags() -> [String] {
        return hashtags
    }
    public func setHashtags(_ hashtags: [String]) {
        self.hashtags = hashtags
        if (availableWidth != nil) {
            addHashtagViews()
        }
    }
    public func addHashtag(_ hashtag: String) {
        self.hashtags.append(hashtag)
        if (availableWidth != nil) {
            addHashtagViews()
        }
    }
    
    public func configure() {
        layoutIfNeeded()
        availableWidth = frame.size.width
        originalWidth = frame.size.width
        addHashtagViews()
    }
    
    private func addHashtagViews() {
        // Remove all hashtags
        for view in subviews {
            view.removeFromSuperview()
        }
        // Add all again
        originalWidth = availableWidth
        for hashtag in hashtags {
            addHashtagView(for: hashtag)
        }
    }
    
    private func addHashtagView(for hashtag: String) {
        
        let hashtagButton: UIButton = {
            let button = UIButton()
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.setTitle(hashtag, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 5
            button.backgroundColor = Color.lightOrange
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.sizeToFit()
            button.addTarget(self, action: #selector(handleHashtagSelection), for: .touchUpInside)
            button.titleEdgeInsets.left = 10
            button.titleEdgeInsets.right = 10
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        addSubview(hashtagButton)
        
        // Constraints
        let width = (hashtagButton.titleLabel?.frame.size.width)! + CGFloat(20) // 10 of padding
        hashtagButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        hashtagButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        if rows.isEmpty {
            let stackView = UIStackView()
            addSubview(stackView)
            stackView.alignment = .center
            stackView.autoresizesSubviews = true
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(hashtagButton)
            stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            stackView.heightAnchor.constraint(equalToConstant: height).isActive = true
            rowsWidthConstraints.append(stackView.widthAnchor.constraint(equalToConstant: width))
            rowsWidthConstraints.last?.isActive = true
            rows.append(stackView)
            availableWidth = availableWidth - width
        } else if (width + 5) < availableWidth { // 5 of horizontal spacing with contiguous button
            rows.last?.addArrangedSubview(hashtagButton)
            rowsWidthConstraints.last?.constant += width + 5
            availableWidth = availableWidth - (width + 5)
        } else {
            let stackView = UIStackView()
            addSubview(stackView)
            stackView.alignment = .center
            stackView.autoresizesSubviews = true
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(hashtagButton)
            stackView.topAnchor.constraint(equalTo: (rows.last?.bottomAnchor)!, constant: 10).isActive = true
            stackView.heightAnchor.constraint(equalToConstant: height).isActive = true
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            rowsWidthConstraints.append(stackView.widthAnchor.constraint(equalToConstant: width))
            rowsWidthConstraints.last?.isActive = true
            rows.append(stackView)
            availableWidth = originalWidth - width
        }
        
        hashtagViews.append(hashtagButton)

    }
    
    @objc func handleHashtagSelection(_ sender: UIButton) {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
