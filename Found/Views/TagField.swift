//
//  TagField.swift
//  Found
//
//  Created by Sergio Hernandez on 20/12/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit

class TagField: UIView {
    
    private let height: CGFloat = 40
    
    private var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.isScrollEnabled = false  // By default
        view.showsVerticalScrollIndicator = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public var handler: TagFieldHandler!
    
    private final var originalWidth: CGFloat!
    private var availableWidth: CGFloat!
    private var rows = [UIStackView]()
    private var rowsWidthConstraints = [NSLayoutConstraint]()  // God made this. You are welcome.
    private var tagViews = [UIButton]()
    private var tags = [String]()
    
    public func isScrollable() {
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
    }
    public func isNotScrollable() {
        scrollView.isScrollEnabled = false
        scrollView.showsVerticalScrollIndicator = false
    }
    public func getNumberOfRows() -> Int {
        return self.rows.count
    }
    public func getHeight() -> CGFloat {
        return (CGFloat((50 * (rows.count - 1)) + 40)) // 40 is the height of each hastag, 10 the vertical spacing between tags (40+10=50)
    }
    public func getTags() -> [String] {
        return tags
    }
    public func setTags(_ tags: [String]) {
        self.tags = tags
        if (availableWidth != nil) {
            addTagViews()
        }
    }
    public func addTag(_ tag: String) {
        if !tags.contains(tag) {
            tags.append(tag)
            if (availableWidth != nil) {
                addTagViews()
            }
        }
    }
    public func removeTag(_ tag: String) {
        if let index = tags.index(of: tag) {
            tags.remove(at: index)
            if (availableWidth != nil) {
                addTagViews()
            }
        }
    }
    
    public func configure() {
        layoutIfNeeded()
        availableWidth = frame.size.width
        originalWidth = frame.size.width
        addTagViews()
    }
    
    private func addTagViews() {
        // Remove all tags and rows
        rows = []
        rowsWidthConstraints = []
        tagViews = []
        for view in scrollView.subviews {
            view.removeFromSuperview()
        }
        
        // Add all again
        availableWidth = originalWidth
        for tag in tags {
            addTagView(for: tag)
        }
    }
    
    private func addTagView(for tag: String) {
        
        let tagButton: UIButton = {
            let button = UIButton()
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.setTitle(tag, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 5
            button.backgroundColor = Color.lightOrange
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.sizeToFit()
            button.addTarget(self, action: #selector(handleTagSelection), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        scrollView.addSubview(tagButton)
        
        // Constraints
        let width = (tagButton.titleLabel?.frame.size.width)! + CGFloat(20)  // 10 of padding on each side
        tagButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        tagButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        // First button
        if rows.isEmpty {
            let stackView = UIStackView()
            scrollView.addSubview(stackView)
            stackView.alignment = .center
            stackView.autoresizesSubviews = true
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(tagButton)
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            stackView.heightAnchor.constraint(equalToConstant: height).isActive = true
            rowsWidthConstraints.append(stackView.widthAnchor.constraint(equalToConstant: width))
            rowsWidthConstraints.last?.isActive = true
            rows.append(stackView)
            scrollView.contentSize = CGSize(width: frame.size.width, height: calculateScrollViewHeight())
            availableWidth = availableWidth - width
        // Contiguous to previous button
        } else if (width + 5 + 10) < availableWidth {  // 5 of horizontal spacing with contiguous button // +10 because of imprecisions I cannot find in the code (it should be the exact width I am calculating here, but it isn't, so the +10 is an error margin)
            rows.last?.addArrangedSubview(tagButton)
            rowsWidthConstraints.last?.constant += width + 5
            availableWidth = availableWidth - (width + 5)
        // On a new row
        } else {
            let stackView = UIStackView()
            scrollView.addSubview(stackView)
            stackView.alignment = .center
            stackView.autoresizesSubviews = true
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(tagButton)
            stackView.topAnchor.constraint(equalTo: (rows.last?.bottomAnchor)!, constant: 10).isActive = true
            stackView.heightAnchor.constraint(equalToConstant: height).isActive = true
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            rowsWidthConstraints.append(stackView.widthAnchor.constraint(equalToConstant: width))
            rowsWidthConstraints.last?.isActive = true
            rows.append(stackView)
            scrollView.contentSize = CGSize(width: frame.size.width, height: calculateScrollViewHeight())
            availableWidth = originalWidth - width
        }
        
        tagViews.append(tagButton)

    }
    
    private func calculateScrollViewHeight() -> CGFloat {
        var contentHeight: CGFloat = 0
        for _ in rows {
            contentHeight += height
        }
        contentHeight += CGFloat(10*(rows.count-1))  // Vertical spacing
        
        return contentHeight
    }
    
    @objc func handleTagSelection(_ sender: UIButton) {
        if let handler = handler {
            handler.handleTagSelection(forTag: (sender.titleLabel?.text)!)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
    
        addSubview(scrollView)
        
        // Scroll View Constraints
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
