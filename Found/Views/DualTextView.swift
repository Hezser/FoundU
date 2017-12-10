////
////  DualTextView.swift
////  Found
////
////  Created by Sergio Hernandez on 28/11/2017.
////  Copyright © 2017 Sergio Hernandez. All rights reserved.
////
//
//import UIKit
//
//class DualTextView: UIStackView {
//
//    var controller: UITextViewDelegate!
//
//    var variable: Variable! {
//        didSet {
//            backgroundColor = .green
//            setUpContent()
//            setUpUI()
//        }
//    }
//
//    var firstLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 18)
//        label.text = "At"
//        label.textColor = #colorLiteral(red: 0.9901074767, green: 0.4136155248, blue: 0.2146835923, alpha: 1)
//        return label
//    }()
//
//    var firstTextView: UITextView = {
//        let textView = UITextView()
//        textView.textAlignment = .left
//        textView.isScrollEnabled = false
//        textView.isUserInteractionEnabled = true
//        textView.isEditable = true
//        textView.backgroundColor = .blue
//        textView.textContainer.lineFragmentPadding = 0
//        textView.font = UIFont.systemFont(ofSize: 16)
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        return textView
//    }()
//
//    var secondLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 18)
//        label.textColor = #colorLiteral(red: 0.9901074767, green: 0.4136155248, blue: 0.2146835923, alpha: 1)
//        return label
//    }()
//
//    var secondTextView: UITextView = {
//        let textView = UITextView()
//        textView.textAlignment = .left
//        textView.isScrollEnabled = false
//        textView.isUserInteractionEnabled = true
//        textView.isEditable = true
//        textView.textContainer.lineFragmentPadding = 0
//        textView.font = UIFont.systemFont(ofSize: 16)
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        return textView
//    }()
//
//    func setUpContent() {
//
//        if variable == .work {
//            secondLabel.text = "as"
//        } else {
//            secondLabel.text = "studying"
//        }
//
//    }
//
//    func setUpUI() {
//
//        let firstUnderline = DividerLine()
//        let secondUnderline = DividerLine()
//
//        addArrangedSubview(secondTextView)
//        addArrangedSubview(firstTextView)
//        addArrangedSubview(firstLabel)
//        addArrangedSubview(secondLabel)
//        //        addSubview(firstUnderline)
//        //        addSubview(secondUnderline)
//
//        firstTextView.delegate = controller
//        secondTextView.delegate = controller
//
//        firstLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        firstLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        firstLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        firstLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//        firstTextView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        firstTextView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true // The left anchor has to be the left anchor of the view. In order to change the starting point of the text horizontally, we change the left inset
//        firstTextView.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
//
//        layoutIfNeeded()
//        firstTextView.contentInset.left = firstLabel.frame.size.width
//
//        secondLabel.topAnchor.constraint(equalTo: firstTextView.bottomAnchor, constant: -((firstTextView.font?.lineHeight)!)).isActive = true
//        secondLabel.leftAnchor.constraint(equalTo: firstTextView.rightAnchor, constant: 5).isActive = true
//        secondLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        if variable == .work {
//            secondLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        } else {
//            secondLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
//        }
//
//        secondTextView.centerYAnchor.constraint(equalTo: secondLabel.centerYAnchor).isActive = true
//        secondTextView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true // The left anchor has to be the left anchor of the view. In order to change the starting point of the text horizontally, we change the left inset
//        secondTextView.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
//
//    }
//
//    func textViewDidChange(_ textView: UITextView) {
//        // Change the secondTextView left inset dinamically
//        let firstTextViewTextWidth = firstTextView.text.size(OfFont: firstTextView.font!).width
//        secondTextView.contentInset.left = firstLabel.frame.size.width + secondLabel.frame.size.width + firstTextViewTextWidth + 15
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .green
//        axis = .vertical
//        isUserInteractionEnabled = true
//        translatesAutoresizingMaskIntoConstraints = false
//    }
//
//    required init(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}

