//
//  EditProfileController.swift
//  Found
//
//  Created by Sergio Hernandez on 16/11/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit

class EditProfileController: UIViewController, UITextFieldDelegate {
    
    var user: User!
    
    var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return effectView
    }()
    
    var vibrancyEffectView: UIVisualEffectView = {
        let vibrancyEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .dark))
        let effectView = UIVisualEffectView(effect: vibrancyEffect)
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return effectView
    }()
    
    var pictureView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // name, dateOfBirth, homePlace, shortDescription, longDescription, email, password
    var privateInformationLabel: UILabel = {
        let label = UILabel()
        label.text = "Private Information"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var publicInformationLabel: UILabel = {
        let label = UILabel()
        label.text = "Public Information"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var changePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change your password", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(handleChangePassword), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var emailTextField: UITextField = {
        let textField = UITextField()
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        textField.returnKeyType = .done
        textField.backgroundColor = .white
        return textField
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var nameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        textField.returnKeyType = .done
        textField.backgroundColor = .white
        return textField
    }()
    
    var dateOfBirthLabel: UILabel = {
        let label = UILabel()
        label.text = "Date Of Birth"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dateOfBirthPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        return picker
    }()
    
    var homePlaceLabel: UILabel = {
        let label = UILabel()
        label.text = "Home Place"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var homePlaceTextField: UITextField = {
        let textField = UITextField()
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        textField.returnKeyType = .done
        textField.backgroundColor = .white
        return textField
    }()
    
    var shortDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Cool Sentence"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var shortDescriptionTextField: UITextField = {
        let textField = UITextField()
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        textField.returnKeyType = .done
        textField.backgroundColor = .white
        return textField
    }()
    
    var longDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Bio"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var longDescriptionTextField: UITextField = {
        let textField = UITextField()
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        textField.returnKeyType = .done
        textField.backgroundColor = .white
        return textField
    }()
    
    @objc func handleChangePassword(_ sender: UIButton) {
        
    }
    
    @objc func handleSave(_ sender: UIButton) {
        
    }
    
    @objc func handleCancel(_ sender: UIButton) {
        // Assuming the EditProfileController is presented and not pushed
        // Otherwise do: navigationControler?.popController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func setUpTextFields() {
        
        // Default Text
        emailTextField.text = user.email
        nameTextField.text = user.name
        homePlaceTextField.text = user.place
        shortDescriptionTextField.text = user.shortDescription
        longDescriptionTextField.text = user.longDescription
        
        // Delegates
        emailTextField.delegate = self
        nameTextField.delegate = self
        homePlaceTextField.delegate = self
        shortDescriptionTextField.delegate = self
        longDescriptionTextField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This must not be done if the EditProfileController is pushed instead of presented
        let navigationBar = UINavigationBar()
        view.addSubview(navigationBar)
        
        let saveButton = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(handleSave))
        navigationItem.rightBarButtonItem = saveButton
        let cancelButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = cancelButton
        
        setUpTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.title = "Edit Profile"
        navigationItem.largeTitleDisplayMode = .never
    }
    
}
