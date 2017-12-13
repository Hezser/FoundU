//
//  StudiesField.swift
//  Found
//
//  Created by Sergio Hernandez on 12/12/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit

// Height of this view must be always set to 70
class ExperienceField: UIView, UITextFieldDelegate {
    
    var variable: Variable! {
        didSet {
            if variable == .studies {
                whatTextField.placeholder = "Course"
                whereTextField.placeholder = "institution"
            } else if variable == .work {
                whatTextField.placeholder = "Position"
                whereTextField.placeholder = "company"
            }
        }
    }
    
    var situation: Situation! {
        didSet {
            if situation == .profile {
                whatTextField.isUserInteractionEnabled = false
                whereTextField.isUserInteractionEnabled = false
            } else if situation == .editProfile {
                whatTextField.isUserInteractionEnabled = true
                whereTextField.isUserInteractionEnabled = true
            }
        }
    }
    
    var whatTextField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.backgroundColor = .clear
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var whereLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "at"
        label.textColor = Color.lightOrange
        return label
    }()
    
    var whereTextField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.backgroundColor = .clear
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    public func setWhat(to string: String) {
        whatTextField.text = string
    }
    
    public func setWhere(to string: String) {
        whereTextField.text = string
    }
    
    public func getWhat() -> String {
        return whatTextField.text!
    }
    
    public func getWhere() -> String {
        return whereTextField.text!
    }
    
    fileprivate func setUpUI() {
        
        addSubview(whatTextField)
        addSubview(whereLabel)
        addSubview(whereTextField)
        
        whereTextField.delegate = self
        whatTextField.delegate = self
        
        // What Text View Constraints
        whatTextField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        whatTextField.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        whatTextField.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        whatTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // What Label Constraints
        whereLabel.topAnchor.constraint(equalTo: whatTextField.bottomAnchor, constant: -10).isActive = true
        whereLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        whereLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        whereLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Where Text View Constraints
        whereTextField.topAnchor.constraint(equalTo: whatTextField.bottomAnchor, constant: -10).isActive = true
        whereTextField.leftAnchor.constraint(equalTo: whereLabel.rightAnchor, constant: 5).isActive = true
        whereTextField.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        whereTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
        setUpUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
