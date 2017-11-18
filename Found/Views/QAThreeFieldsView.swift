//
//  QAThreeFieldsView.swift
//  Found
//
//  Created by Sergio Hernandez on 28/09/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit

class QAThreeFieldsView: QAView, UITextFieldDelegate {
    
    var textField1: UITextField!
    var textField2: UITextField!
    var textField3: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTextFields()
    }
    
    func createTextFields() {
        
        textField1 = UITextField()
        textField2 = UITextField()
        textField3 = UITextField()
        textField1.backgroundColor = .white
        textField2.backgroundColor = .white
        textField3.backgroundColor = .white
        textField1.translatesAutoresizingMaskIntoConstraints = false
        textField2.translatesAutoresizingMaskIntoConstraints = false
        textField3.translatesAutoresizingMaskIntoConstraints = false
        textField1.returnKeyType = .done
        textField2.returnKeyType = .done
        textField3.returnKeyType = .done
        
        textField1.delegate = self
        textField2.delegate = self
        textField3.delegate = self
        
        view.addSubview(textField1)
        view.addSubview(textField2)
        view.addSubview(textField3)
        
        let margins = view.layoutMarginsGuide
        
        textField2.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        textField2.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        textField2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField2.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        
        textField1.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        textField1.bottomAnchor.constraint(equalTo: textField2.topAnchor, constant: -50).isActive = true
        textField1.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField1.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        
        textField3.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        textField3.bottomAnchor.constraint(equalTo: textField2.topAnchor, constant: 50).isActive = true
        textField3.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField3.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
    }
    
    override func nextPressed(sender: UIButton!) {
        if situation == .profileCreation {
            writeProfileInfoToFirebaseDatabase(data: [textField1.text ?? "nil", textField2.text ?? "nil", textField3.text ?? "nil"], completion: nil)
        }
        goToNextView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Keyboard dissapears when clicking "return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }    
}
