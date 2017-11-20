//
//  ChangePasswordController.swift
//  Found
//
//  Created by Sergio Hernandez on 17/11/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordController: UIViewController, UITextFieldDelegate {
    
    var user: User!
    
    var currentPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Current Password"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var currentPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var newPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "New Password"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var newPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var repeatNewPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Repeat New Password"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var repeatNewPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    @objc func handleSave(_ sender: UIButton) {
        if dataIsValid() {
            FIRAuth.auth()?.currentUser?.updatePassword(newPasswordTextField.text!, completion: {(error) in
                if error != nil {
                    print(error!)
                    // Alert of the invalidity of password
                    let alert = UIAlertController(title: "Invalid new password", message: nil, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
                        // Alert is dismissed
                    }
                    alert.addAction(alertAction)
                    self.present(alert, animated: true, completion:nil)
                } else {
                    FIRDatabase.database().reference().child("users").child(self.user.id!).updateChildValues(["password" : self.newPasswordTextField.text!], withCompletionBlock: { (err, ref) in
                        // Assuming the EditProfileController is presented and not pushed
                        // Otherwise do: dismiss(animated: true, completion: nil)
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            })
        }
    }
    
    @objc func handleCancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func dataIsValid() -> Bool {
        // Check that the current password is correct, that both new and repeatNew passwords are the same, that the old password and new password are different and that the new password is a valid password
        
        // Current Password is correct
        if currentPasswordTextField.text! != user.password {
            let alert = UIAlertController(title: "Wrong current password", message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
                // Alert is dismissed
            }
            
            alert.addAction(alertAction)
            
            self.present(alert, animated: true, completion:nil)
            return false
        }
            
        // New password is not repeated correctly
        else if newPasswordTextField.text! != repeatNewPasswordTextField.text! {
            let alert = UIAlertController(title: "Passwords don't match", message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
                // Alert is dismissed
            }
            
            alert.addAction(alertAction)
            
            self.present(alert, animated: true, completion:nil)
            return false
        }
        
        // New and old passwords are the same
        else if currentPasswordTextField.text! == newPasswordTextField.text! {
            let alert = UIAlertController(title: "Old and new passwords are the same", message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
                // Alert is dismissed
            }
            
            alert.addAction(alertAction)
            
            self.present(alert, animated: true, completion:nil)
            return false
        }
        return true
    }
    
    func setUpUI() {
        
        let dividerLine1 = DividerLine()
        let dividerLine2 = DividerLine()
        
        view.addSubview(currentPasswordLabel)
        view.addSubview(currentPasswordTextField)
        view.addSubview(newPasswordLabel)
        view.addSubview(newPasswordTextField)
        view.addSubview(repeatNewPasswordLabel)
        view.addSubview(repeatNewPasswordTextField)
        view.addSubview(dividerLine1)
        view.addSubview(dividerLine2)
        
        // Set Text Field Delegates
        currentPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        repeatNewPasswordTextField.delegate = self
        
        let margins = view.layoutMarginsGuide
        
        // Current Password Label Constraints
        currentPasswordLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 30).isActive = true
        currentPasswordLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        currentPasswordLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width/2).isActive = true
        currentPasswordLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Current Password Text Field Constraints
        currentPasswordTextField.topAnchor.constraint(equalTo: margins.topAnchor, constant: 30).isActive = true
        currentPasswordTextField.leftAnchor.constraint(equalTo: currentPasswordLabel.rightAnchor, constant: 5).isActive = true
        currentPasswordTextField.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        currentPasswordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Divider Line After Current Password Text Field Constraints
        dividerLine1.topAnchor.constraint(equalTo: currentPasswordTextField.bottomAnchor, constant: 10).isActive = true
        dividerLine1.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        dividerLine1.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10).isActive = true
        dividerLine1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Current Password Label Constraints
        newPasswordLabel.topAnchor.constraint(equalTo: dividerLine1.bottomAnchor, constant: 10).isActive = true
        newPasswordLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        newPasswordLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width/2).isActive = true
        newPasswordLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Current Password Text Field Constraints
        newPasswordTextField.topAnchor.constraint(equalTo: dividerLine1.bottomAnchor, constant: 10).isActive = true
        newPasswordTextField.leftAnchor.constraint(equalTo: newPasswordLabel.rightAnchor, constant: 5).isActive = true
        newPasswordTextField.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        newPasswordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Divider Line After Current Password Text Field Constraints
        dividerLine2.topAnchor.constraint(equalTo: newPasswordLabel.bottomAnchor, constant: 10).isActive = true
        dividerLine2.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        dividerLine2.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10).isActive = true
        dividerLine2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Current Password Label Constraints
        repeatNewPasswordLabel.topAnchor.constraint(equalTo: dividerLine2.bottomAnchor, constant: 10).isActive = true
        repeatNewPasswordLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        repeatNewPasswordLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width/2).isActive = true
        repeatNewPasswordLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Current Password Text Field Constraints
        repeatNewPasswordTextField.topAnchor.constraint(equalTo: dividerLine2.bottomAnchor, constant: 10).isActive = true
        repeatNewPasswordTextField.leftAnchor.constraint(equalTo: currentPasswordLabel.rightAnchor, constant: 5).isActive = true
        repeatNewPasswordTextField.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        repeatNewPasswordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSave))
        navigationItem.rightBarButtonItem = saveButton
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = cancelButton
        
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.title = "Change Password"
        tabBarController?.tabBar.isHidden = true
        navigationItem.largeTitleDisplayMode = .never
    }

func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    view.endEditing(true)
    return true
}
}
