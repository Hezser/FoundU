//
//  QATwoFieldsController.swift
//  Found
//
//  Created by Sergio Hernandez on 25/11/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit

class QATwoFieldsController: QAController, UITextViewDelegate {
    
    var titleTextView: UITextView = {
        let textView = UITextView()
        textView.returnKeyType = .done
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.isScrollEnabled = false
        textView.textAlignment = .center
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var contentTextView: UITextView = {
        let textView = UITextView()
        textView.returnKeyType = .done
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.isScrollEnabled = false
        textView.textAlignment = .left
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func nextPressed(sender: UIButton!) {
//        if situation == .profileCreation {
//            writeProfileInfoToFirebaseDatabase(data: , completion: nil)
//        }
        goToNextView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUpUI() {
        super.setUpUI()
        
        titleTextView.delegate = self
        titleTextView.font = questionLabel.font
        contentTextView.delegate = self
        contentTextView.font = questionLabel.font
        view.addSubview(titleTextView)
        view.addSubview(contentTextView)
        
        let margins = view.layoutMarginsGuide
        
        // Title Text View Constraints
        titleTextView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20).isActive = true
        titleTextView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        titleTextView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        // Content Text View Constraints
        contentTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 10).isActive = true
        contentTextView.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 5).isActive = true
        contentTextView.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -5).isActive = true
        contentTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch? = touches.first
        if touch?.view != titleTextView && touch?.view != contentTextView {
            // Hide keyboard
            contentTextView.resignFirstResponder()
            titleTextView.resignFirstResponder()
        }
        
    }
    
    func tooManyNewLines(in textView: UITextView, range: NSRange, text: String) -> Bool {
        let text = (textView.text as NSString).replacingCharacters(in: range, with: text)
        var numberOfNewLines = 0
        for char in text {
            if char == "\n" {
                numberOfNewLines += 1
            }
        }
        return numberOfNewLines > 2
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" && textView == titleTextView {
            textView.resignFirstResponder()
            return false
        }
        
        // Check for too many \n, we do not want 600 new lines (since they are counted as chars)
        if tooManyNewLines(in: textView, range: range, text: text) {
            return false
        }
        
        // Limit the number of maximum chars
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        if textView == titleTextView {
            return numberOfChars < 50
        } else if textView == contentTextView {
            return numberOfChars < 240
        }
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

