//
//  QARegularView.swift
//  Found
//
//  Created by Sergio Hernandez on 21/09/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit

class QARegularView: QAView, UITextFieldDelegate {
    
    var answer: UITextField = {
        var textField = UITextField()
        textField = UITextField()
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        textField.placeholder = "Answer"
        textField.returnKeyType = .done
        textField.backgroundColor = #colorLiteral(red: 1, green: 0.9372548461, blue: 0.8588235378, alpha: 1)
        return textField
    }()
    
    var answerSize: Int!
    
    override func nextPressed(sender: UIButton!) {
        if situation == .profileCreation {
            writeProfileInfoToFirebaseDatabase(data: answer.text ?? "nil", completion: nil)
        }
        else if situation == .postCreation {
            addDataToPost(value: answer.text, type: variable!)
        }
        goToNextView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup text field for answer
        answer.center = view.center
        answer.frame = CGRect(x: 0, y: 0, width: Int(view.bounds.width), height: answerSize ?? 75)
        answer.delegate = self
        view.addSubview(answer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Keyboard dissapears when clicking "done"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}
