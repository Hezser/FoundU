//
//  QAThreeFieldsView.swift
//  Found
//
//  Created by Sergio Hernandez on 28/09/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit

class QAThreeFieldsView: QAView, UITextFieldDelegate {
    
    var atTextField1: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.layer.cornerRadius = 5
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var asTextField1: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.layer.cornerRadius = 5
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    var atTextField2: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.layer.cornerRadius = 5
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var asTextField2: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.layer.cornerRadius = 5
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var atTextField3: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.layer.cornerRadius = 5
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var asTextField3: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.layer.cornerRadius = 5
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTextFields()
    }
    
    func createTextFields() {
        
        let topDividerLine = DividerLine()
        let bottomDividerLine = DividerLine()
        let dividerLine1 = DividerLine()
        let dividerLine2 = DividerLine()
        
        let atLabel1 = UILabel()
        let atLabel2 = UILabel()
        let atLabel3 = UILabel()
        let asLabel1 = UILabel()
        let asLabel2 = UILabel()
        let asLabel3 = UILabel()
        
        atLabel1.text = "At:"
        atLabel2.text = "At:"
        atLabel3.text = "At:"
        if variable == .work {
            asLabel1.text = "as:"
            asLabel2.text = "as:"
            asLabel3.text = "as:"
        } else {
            asLabel1.text = "studying:"
            asLabel2.text = "studying:"
            asLabel3.text = "studying:"
        }
        atLabel1.translatesAutoresizingMaskIntoConstraints = false
        atLabel2.translatesAutoresizingMaskIntoConstraints = false
        atLabel3.translatesAutoresizingMaskIntoConstraints = false
        asLabel1.translatesAutoresizingMaskIntoConstraints = false
        asLabel2.translatesAutoresizingMaskIntoConstraints = false
        asLabel3.translatesAutoresizingMaskIntoConstraints = false
        var asWidth = 30
        if variable == .studies {
            asWidth = 80
        }
        
        atTextField1.delegate = self
        atTextField2.delegate = self
        atTextField3.delegate = self
        asTextField1.delegate = self
        asTextField2.delegate = self
        asTextField3.delegate = self

        view.addSubview(atTextField1)
        view.addSubview(atTextField2)
        view.addSubview(atTextField3)
        view.addSubview(asTextField1)
        view.addSubview(asTextField2)
        view.addSubview(asTextField3)
        view.addSubview(atLabel1)
        view.addSubview(atLabel2)
        view.addSubview(atLabel3)
        view.addSubview(asLabel1)
        view.addSubview(asLabel2)
        view.addSubview(asLabel3)
        view.addSubview(dividerLine1)
        view.addSubview(dividerLine2)
        view.addSubview(topDividerLine)
        view.addSubview(bottomDividerLine)
        
        let margins = view.layoutMarginsGuide
        
        // At Label 2 Constraints (We start at two so we can position it in the center and adjust the other views based on these
        atLabel2.bottomAnchor.constraint(equalTo: margins.centerYAnchor, constant: -2.5).isActive = true
        atLabel2.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        atLabel2.widthAnchor.constraint(equalToConstant: 30).isActive = true
        atLabel2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // At Text Field 2 Constraints
        atTextField2.bottomAnchor.constraint(equalTo: margins.centerYAnchor, constant: -2.5).isActive = true
        atTextField2.leftAnchor.constraint(equalTo: atLabel2.rightAnchor, constant: 5).isActive = true
        atTextField2.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10).isActive = true
        atTextField2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // As Label 2 Constraints
        asLabel2.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: 2.5).isActive = true
        asLabel2.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        asLabel2.widthAnchor.constraint(equalToConstant: CGFloat(asWidth)).isActive = true
        asLabel2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // As Text Field 2 Constraints
        asTextField2.topAnchor.constraint(equalTo: margins.centerYAnchor, constant: 2.5).isActive = true
        asTextField2.leftAnchor.constraint(equalTo: asLabel2.rightAnchor, constant: 5).isActive = true
        asTextField2.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10).isActive = true
        asTextField2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // Divider Line Between Sections 1 and 2 Constraints
        dividerLine1.bottomAnchor.constraint(equalTo: atLabel2.topAnchor, constant: -10).isActive = true
        dividerLine1.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        dividerLine1.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        dividerLine1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // As Label 1 Constraints
        asLabel1.bottomAnchor.constraint(equalTo: dividerLine1.topAnchor, constant: -10).isActive = true
        asLabel1.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        asLabel1.widthAnchor.constraint(equalToConstant: CGFloat(asWidth)).isActive = true
        asLabel1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // As Text Field 1 Constraints
        asTextField1.bottomAnchor.constraint(equalTo: dividerLine1.topAnchor, constant: -10).isActive = true
        asTextField1.leftAnchor.constraint(equalTo: asLabel1.rightAnchor, constant: 5).isActive = true
        asTextField1.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10).isActive = true
        asTextField1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // At Label 1 Constraints
        atLabel1.bottomAnchor.constraint(equalTo: asLabel1.topAnchor, constant: -5).isActive = true
        atLabel1.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        atLabel1.widthAnchor.constraint(equalToConstant: 30).isActive = true
        atLabel1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // At Text Field 1 Constraints
        atTextField1.bottomAnchor.constraint(equalTo: asLabel1.topAnchor, constant: -5).isActive = true
        atTextField1.leftAnchor.constraint(equalTo: atLabel1.rightAnchor, constant: 5).isActive = true
        atTextField1.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10).isActive = true
        atTextField1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // Top Divider Line Constraints
        topDividerLine.bottomAnchor.constraint(equalTo: atLabel1.topAnchor, constant: -10).isActive = true
        topDividerLine.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        topDividerLine.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        topDividerLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Divider Line Between Sections 2 and 3 Constraints
        dividerLine2.topAnchor.constraint(equalTo: asLabel2.bottomAnchor, constant: 10).isActive = true
        dividerLine2.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        dividerLine2.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        dividerLine2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // At Label 3 Constraints
        atLabel3.topAnchor.constraint(equalTo: dividerLine2.bottomAnchor, constant: 10).isActive = true
        atLabel3.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        atLabel3.widthAnchor.constraint(equalToConstant: 30).isActive = true
        atLabel3.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // At Text Field 3 Constraints
        atTextField3.topAnchor.constraint(equalTo: dividerLine2.bottomAnchor, constant: 10).isActive = true
        atTextField3.leftAnchor.constraint(equalTo: atLabel3.rightAnchor, constant: 5).isActive = true
        atTextField3.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10).isActive = true
        atTextField3.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // As Label 3 Constraints
        asLabel3.topAnchor.constraint(equalTo: atLabel3.bottomAnchor, constant: 5).isActive = true
        asLabel3.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        asLabel3.widthAnchor.constraint(equalToConstant: CGFloat(asWidth)).isActive = true
        asLabel3.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // As Text Field 3 Constraints
        asTextField3.topAnchor.constraint(equalTo: atLabel3.bottomAnchor, constant: 5).isActive = true
        asTextField3.leftAnchor.constraint(equalTo: asLabel3.rightAnchor, constant: 5).isActive = true
        asTextField3.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10).isActive = true
        asTextField3.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // Bottom Divider Line Constraints
        bottomDividerLine.topAnchor.constraint(equalTo: asLabel3.bottomAnchor, constant: 10).isActive = true
        bottomDividerLine.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        bottomDividerLine.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        bottomDividerLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
    }
    
    func dataIsValid() -> Bool {
        
        if (atTextField1.text != "" && asTextField1.text == "") || (atTextField1.text == "" && asTextField1.text != "") {
            return false
        } else if (atTextField2.text != "" && asTextField2.text == "") || (atTextField2.text == "" && asTextField2.text != "")  {
            return false
        } else if (atTextField3.text != "" && asTextField3.text == "") || (atTextField3.text == "" && asTextField3.text != "")  {
            return false
        }
        return true
    }
    
    override func nextPressed(sender: UIButton!) {
        
        if dataIsValid() {
            if situation == .profileCreation {
                var string1 = "nil", string2 = "nil", string3 = "nil", connective = " as "
                if variable == .studies {
                    connective = " studying "
                }
                if atTextField1.text != "" {
                    string1 = (atTextField1.text! + connective + asTextField1.text!)
                }
                if atTextField2.text != "" {
                    string2 = (atTextField2.text! + connective + asTextField2.text!)
                }
                if atTextField3.text != "" {
                    string3 = (atTextField3.text! + connective + asTextField3.text!)
                }
                writeProfileInfoToFirebaseDatabase(data: [string1, string2, string3], completion: nil)
            }
            goToNextView()
        } else {
            // Alert of the invalidity of input
            let alert = UIAlertController(title: "Invalid Entries", message: "You have not finsihed some of the entries you have started. It is not necessary to complete any of the three entries, but if you start a section of one, you must complete the other section.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
                // Alert is dismissed
            }
            
            alert.addAction(alertAction)
            
            present(alert, animated: true, completion:nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Keyboard dissapears when clicking "return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    // Input in text fields must be less than 30 chars
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 30
    }
}
