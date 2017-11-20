//
//  QARegularView.swift
//  Found
//
//  Created by Sergio Hernandez on 21/09/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit

class QARegularView: QAView, UITextViewDelegate {
    
    var answerTextView: UITextView = {
        let textView = UITextView()
        textView.returnKeyType = .done
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.isScrollEnabled = false
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func nextPressed(sender: UIButton!) {
        if situation == .profileCreation {
            writeProfileInfoToFirebaseDatabase(data: answerTextView.text ?? "nil", completion: nil)
        }
        else if situation == .postCreation {
            addDataToPost(value: answerTextView.text, type: variable!)
        }
        goToNextView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUpUI() {
        super.setUpUI()
        
        answerTextView.delegate = self
        answerTextView.font = questionLabel.font
        view.addSubview(answerTextView)
        
        let margins = view.layoutMarginsGuide
        
        // Answer Text View Constraints
        answerTextView.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        answerTextView.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        answerTextView.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch? = touches.first
        if (touch?.view != answerTextView) {
            // Hide keyboard
            answerTextView.resignFirstResponder()
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
        return numberOfNewLines > 5
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n" && (variable == . place || variable == .shortSelfDescription || variable == .title)) {
            textView.resignFirstResponder()
            return false
        }
        
        // Check for too many \n, we do not want 600 new lines (since they are counted as chars). We only check this for longSelfDescription and details, since when a new line is trying to be introduced for some other variable, the keyboard returns
        if tooManyNewLines(in: textView, range: range, text: text) {
            return false
        }
        
        // Limit the number of maximum chars
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        if variable == .shortSelfDescription || variable == .title {
            return numberOfChars < 140
        } else if variable == .place {
            return numberOfChars < 50
        } else if variable == .longSelfDescription || variable == .details {
            return numberOfChars < 600
        }
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
