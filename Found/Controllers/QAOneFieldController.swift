//
//  QARegularView.swift
//  Found
//
//  Created by Sergio Hernandez on 21/09/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit

class QAOneFieldController: QAController, UITextViewDelegate {
    
    var answerTextView: UITextView = {
        let textView = UITextView()
        textView.returnKeyType = .done
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.isScrollEnabled = false
        textView.textColor = Color.white
        textView.tintColor = Color.white
        textView.backgroundColor = Color.lightOrange
        textView.alpha = 0.75
        textView.layer.cornerRadius = 10
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    func presentInvalidDataAlert(withMessage message: String) {
        let alert = UIAlertController(title: "\(message).", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
            // Alert is dismissed
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion:nil)
    }
    
    func dataIsValid() -> Bool {
        
        // Check that title of post is long enough (5 chars)
        if variable == .title {
            if answerTextView.text.count < 5 {
                presentInvalidDataAlert(withMessage: "The title is not long enough")
                return false
            }
        }
        
        return true
    }
    
    override func nextPressed(sender: UIButton!) {
        if dataIsValid() {
            if situation == .profileCreation {
                addDataToProfile(data: answerTextView.text ?? "")
            }
            else if situation == .postCreation {
                addDataToPost(data: answerTextView.text)
            }
            goToNextView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUpUI() {
        super.setUpUI()
        
        answerTextView.delegate = self
        answerTextView.font = questionTextView.font
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
        
        if (text == "\n" && (variable == . place || variable == .bio || variable == .title)) {
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
        if variable == .bio || variable == .title {
            return numberOfChars < 140
        } else if variable == .place {
            return numberOfChars < 50
        } else if variable == .bio || variable == .details {
            return numberOfChars < 600
        }
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
