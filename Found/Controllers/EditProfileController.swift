//
//  EditProfileController.swift
//  Found
//
//  Created by Sergio Hernandez on 16/11/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
import Firebase
import Photos

class EditProfileController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    typealias FinishedDownload = () -> ()
    
    var user: User!
    
    var imageWasChanged = false
    
    var scrollView: UIScrollView = {
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        let view = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)) // y = 20 so that pictureView has some space from the navigationBar
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = true
        return view
    }()
    
    // Used to provide a space between the top navigation bar and the image view. I HATE SCROLL VIEWS
    var spacingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var changePictureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change your profile picture", for: .normal)
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var privateInformationLabel: UILabel = {
        let label = UILabel()
        label.text = "Private Information"
        label.backgroundColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var publicInformationLabel: UILabel = {
        let label = UILabel()
        label.text = "Public Information"
        label.backgroundColor = .white
        label.font = .boldSystemFont(ofSize: 18)
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
        let button = UIButton(type: .system)
        button.setTitle("Change your password", for: .normal)
        button.contentHorizontalAlignment = .left
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
        textField.returnKeyType = .done
        textField.backgroundColor = .white
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
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
        textField.returnKeyType = .done
        textField.backgroundColor = .white
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var dateOfBirthLabel: UILabel = {
        let label = UILabel()
        label.text = "Date Of Birth"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dateOfBirthButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var dateOfBirthPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
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
        textField.returnKeyType = .done
        textField.backgroundColor = .white
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var shortDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Intro"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var shortDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.returnKeyType = .done
        textView.backgroundColor = .white
        textView.textContainer.lineFragmentPadding = 0
//        textView.textContainer.maximumNumberOfLines = 4 // No need for this if we limit the number of chars
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.isScrollEnabled = false // By setting this to false, the text view autoresizes when more lines are needed
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var longDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Bio"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var longDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.returnKeyType = .default
        textView.backgroundColor = .white
        textView.textContainer.lineFragmentPadding = 0
//        textView.textContainer.maximumNumberOfLines = 15 // No need for this if we limit the number of chars
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.isScrollEnabled = false // By setting this to false, the text view autoresizes when more lines are needed
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    @objc func handleChangeProfilePicture() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
            ()
            
            if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
                self.present(picker, animated: true, completion: nil)
            }
            
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromImagePicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromImagePicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromImagePicker = originalImage
        }
        
        if let selectedImage = selectedImageFromImagePicker {
            pictureView.image = selectedImage
        }
        
        imageWasChanged = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Change of picture was canceled")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDateOfBirthPickerAppearance() {
        
        // Animate Date Of Birth Picker
        dateOfBirthPicker.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        dateOfBirthPicker.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.blurEffectView.isHidden = false
            self.vibrancyEffectView.isHidden = false
            self.dateOfBirthPicker.alpha = 1
            self.dateOfBirthPicker.transform = CGAffineTransform.identity
        }
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if (touch?.view != dateOfBirthPicker) && (blurEffectView.isHidden == false) {
            dismissDateOfBirthPicker()
        }
    }
    
    func dismissDateOfBirthPicker() {
        
        // Set date of interactive date of birth picker label
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM, yyyy"
        let dateOfBirth = dateFormatter.string(from: dateOfBirthPicker.date)
        dateOfBirthButton.setTitle(dateOfBirth, for: .normal)
        
        // Animate dismissal
        UIView.animate(withDuration: 0.3, animations: {
            self.dateOfBirthPicker.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.dateOfBirthPicker.alpha = 0
        }) { (success: Bool) in
            self.blurEffectView.isHidden = true
            self.vibrancyEffectView.isHidden = true
            self.navigationController?.isNavigationBarHidden = false
            self.view.endEditing(true)
        }
    }
    
    @objc func handleChangePassword(_ sender: UIButton) {
        let changePasswordController = ChangePasswordController()
        changePasswordController.user = user
        navigationController?.pushViewController(changePasswordController, animated: true)
    }
    
    // This method should not execute unless a different image has been chosen. The way I have done it (using the var imageWasChanged) is probaby not the most efficient
    func saveImage(completion completed: @escaping FinishedDownload) {
        
        print("\nimageWasChanged is \(imageWasChanged)\n")
        if imageWasChanged {
            // Delete previous image from Firebase Storage
            FIRStorage.storage().reference(forURL: user.profileImageURL!).delete(completion: { (error) in
                if error != nil {
                    print(error!)
                }
            })

            // Upload new image to Firebase Storage
            let imageName = UUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
            // To change the quality of picture after compression change 0.1 for a value closer to 1
            if let profileImage = pictureView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        completed()
                        return
                    }
                    
                    if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                        self.user.profileImageURL = profileImageURL
                        completed()
                    }
                })
            }
        } else {
            completed()
        }
    }
    
    @objc func handleSave(_ sender: UIButton) {
        
        // Update user
        user.email = emailTextField.text!
        user.name = nameTextField.text!
        user.age = dateOfBirthPicker.date.age
        user.dateOfBirth = dateOfBirthButton.currentTitle!
        user.place = homePlaceTextField.text!
        user.shortDescription = shortDescriptionTextView.text!
        user.longDescription = longDescriptionTextView.text!
        
        // saveImage() is done first because it updates user.profileImageURL, which is used in data to upload to the user's section in Firebase database
        saveImage(completion: {
            if self.dataIsValid() {
                let data = ["pictureURL" : self.user.profileImageURL!, "email" : self.user.email!, "name" : self.user.name!, "age" : String(describing: self.user.age!), "date of birth" : self.user.dateOfBirth!, "place" : self.user.place!, "short self description" : self.user.shortDescription!, "long self description" : self.user.longDescription!]
                FIRDatabase.database().reference().child("users").child(self.user.id!).updateChildValues(data, withCompletionBlock: { (err, ref) in
                    let profile = self.navigationController?.viewControllers.first as! ProfileController
                    profile.user = self.user
                    // Assuming the EditProfileController is presented and not pushed
                    // Otherwise do: dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                })
            }
        })
    }
    
    @objc func handleCancel(_ sender: UIButton) {
        // Assuming the EditProfileController is presented and not pushed
        // Otherwise do: dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    func dataIsValid() -> Bool {
        // Check that all the info is valid
        return true
    }
    
    func setUserImage(fromURLString urlString: String) {
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.pictureView.image = UIImage(data: data!)
            }
            
        }).resume()
    }
    
    func setUpTextFields() {
        
        // Default Content
        setUserImage(fromURLString: user.profileImageURL!)
        emailTextField.text = user.email
        nameTextField.text = user.name
        homePlaceTextField.text = user.place
        shortDescriptionTextView.text = user.shortDescription
        longDescriptionTextView.text = user.longDescription
        dateOfBirthButton.setTitle(user.dateOfBirth, for: .normal)
        dateOfBirthButton.titleLabel?.font = nameLabel.font
        shortDescriptionTextView.font = nameLabel.font
        longDescriptionTextView.font = nameLabel.font
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM, yyyy"
        dateOfBirthPicker.date = formatter.date(from: user.dateOfBirth!)!
        
        // Delegates
        emailTextField.delegate = self
        nameTextField.delegate = self
        homePlaceTextField.delegate = self
        shortDescriptionTextView.delegate = self
        longDescriptionTextView.delegate = self
    }
    
    func setUpUI() {
        
        view.addSubview(scrollView)
        
        let dividerLine1 = DividerLine()
        let dividerLine2 = DividerLine()
        let dividerLine4 = DividerLine()
        let dividerLine5 = DividerLine()
        let dividerLine6 = DividerLine()
        let dividerLine7 = DividerLine()
        let dividerLine8 = DividerLine()
        
        scrollView.addSubview(spacingView)
        scrollView.addSubview(pictureView)
        scrollView.addSubview(changePictureButton)
        scrollView.addSubview(privateInformationLabel)
        scrollView.addSubview(publicInformationLabel)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(emailLabel)
        scrollView.addSubview(passwordLabel)
        scrollView.addSubview(homePlaceLabel)
        scrollView.addSubview(dateOfBirthLabel)
        scrollView.addSubview(shortDescriptionLabel)
        scrollView.addSubview(longDescriptionLabel)
        scrollView.addSubview(nameTextField)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(changePasswordButton)
        scrollView.addSubview(homePlaceTextField)
        scrollView.addSubview(dateOfBirthButton)
        scrollView.addSubview(shortDescriptionTextView)
        scrollView.addSubview(longDescriptionTextView)
        scrollView.addSubview(dividerLine1)
        scrollView.addSubview(dividerLine2)
        scrollView.addSubview(dividerLine4)
        scrollView.addSubview(dividerLine5)
        scrollView.addSubview(dividerLine6)
        scrollView.addSubview(dividerLine7)
        scrollView.addSubview(dividerLine8)
        
        let margins = scrollView.layoutMarginsGuide
        
        // Spacing View Constraints
//        spacingView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20).isActive = true // Can't use it with scroll view, it wouldn't allow scrolling
        spacingView.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        spacingView.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        spacingView.heightAnchor.constraint(equalToConstant: 20).isActive = true // 20 is the separation between the tab bar and the image view
        
        // Picture View Constraints
        pictureView.topAnchor.constraint(equalTo: spacingView.bottomAnchor).isActive = true
        pictureView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        pictureView.widthAnchor.constraint(equalToConstant: scrollView.frame.size.width/2).isActive = true
        pictureView.heightAnchor.constraint(equalTo: pictureView.widthAnchor).isActive = true
        
        // Change Picture Button Constraints
        changePictureButton.topAnchor.constraint(equalTo: pictureView.bottomAnchor, constant: 10).isActive = true
        changePictureButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        changePictureButton.widthAnchor.constraint(equalTo: pictureView.widthAnchor).isActive = true
        changePictureButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // Private Information Label Constraints
        privateInformationLabel.topAnchor.constraint(equalTo: changePictureButton.bottomAnchor, constant: 15).isActive = true
        privateInformationLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        privateInformationLabel.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        privateInformationLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Long Divider Line After Private Information Label Constraints
        dividerLine1.topAnchor.constraint(equalTo: privateInformationLabel.bottomAnchor).isActive = true
        dividerLine1.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        dividerLine1.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        dividerLine1.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        // Email Label Constraints
        emailLabel.topAnchor.constraint(equalTo: dividerLine1.bottomAnchor, constant: 5).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        emailLabel.widthAnchor.constraint(equalToConstant: scrollView.frame.size.width/4).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Email Text Field Constraints
        emailTextField.topAnchor.constraint(equalTo: dividerLine1.bottomAnchor, constant: 5).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: emailLabel.rightAnchor, constant: 5).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Short Divider Line After Email Constraints
        dividerLine2.topAnchor.constraint(equalTo: emailLabel.bottomAnchor).isActive = true
        dividerLine2.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        dividerLine2.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10).isActive = true
        dividerLine2.heightAnchor.constraint(equalToConstant: 1).isActive = true

        // Password Label Constraints
        passwordLabel.topAnchor.constraint(equalTo: dividerLine2.bottomAnchor).isActive = true
        passwordLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        passwordLabel.widthAnchor.constraint(equalToConstant: scrollView.frame.size.width/4).isActive = true
        passwordLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Password Button Constraints
        changePasswordButton.topAnchor.constraint(equalTo: dividerLine2.bottomAnchor).isActive = true
        changePasswordButton.leftAnchor.constraint(equalTo: passwordLabel.rightAnchor, constant: 5).isActive = true
        changePasswordButton.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        changePasswordButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Public Information Label Constraints
        publicInformationLabel.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 30).isActive = true
        publicInformationLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        publicInformationLabel.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        publicInformationLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Long Divider Line After Private Information Label Constraints
        dividerLine4.topAnchor.constraint(equalTo: publicInformationLabel.bottomAnchor).isActive = true
        dividerLine4.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        dividerLine4.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        dividerLine4.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        // Name Label Constraints
        nameLabel.topAnchor.constraint(equalTo: dividerLine4.bottomAnchor, constant: 5).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: scrollView.frame.size.width/4).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Name Text Field Constraints
        nameTextField.topAnchor.constraint(equalTo: dividerLine4.bottomAnchor, constant: 5).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 5).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Short Divider Line After Name Constraints
        dividerLine5.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        dividerLine5.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        dividerLine5.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10).isActive = true
        dividerLine5.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Date Of Birth Label Constraints
        dateOfBirthLabel.topAnchor.constraint(equalTo: dividerLine5.bottomAnchor).isActive = true
        dateOfBirthLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        dateOfBirthLabel.widthAnchor.constraint(equalToConstant: scrollView.frame.size.width/4).isActive = true
        dateOfBirthLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Date Of Birth Text Field Constraints
        dateOfBirthButton.topAnchor.constraint(equalTo: dividerLine5.bottomAnchor).isActive = true
        dateOfBirthButton.leftAnchor.constraint(equalTo: dateOfBirthLabel.rightAnchor, constant: 5).isActive = true
        dateOfBirthButton.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        dateOfBirthButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Short Divider Line After Date Of Birth Constraints
        dividerLine6.topAnchor.constraint(equalTo: dateOfBirthLabel.bottomAnchor).isActive = true
        dividerLine6.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        dividerLine6.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10).isActive = true
        dividerLine6.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Home Place Label Constraints
        homePlaceLabel.topAnchor.constraint(equalTo: dividerLine6.bottomAnchor).isActive = true
        homePlaceLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        homePlaceLabel.widthAnchor.constraint(equalToConstant: scrollView.frame.size.width/4).isActive = true
        homePlaceLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Home Place Text Field Constraints
        homePlaceTextField.topAnchor.constraint(equalTo: dividerLine6.bottomAnchor).isActive = true
        homePlaceTextField.leftAnchor.constraint(equalTo: homePlaceLabel.rightAnchor, constant: 5).isActive = true
        homePlaceTextField.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        homePlaceTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Short Divider Line After Home Place Constraints
        dividerLine7.topAnchor.constraint(equalTo: homePlaceLabel.bottomAnchor).isActive = true
        dividerLine7.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        dividerLine7.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10).isActive = true
        dividerLine7.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Short Description Label Constraints
        shortDescriptionLabel.topAnchor.constraint(equalTo: dividerLine7.bottomAnchor).isActive = true
        shortDescriptionLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        shortDescriptionLabel.widthAnchor.constraint(equalToConstant: scrollView.frame.size.width/4).isActive = true
        shortDescriptionLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Short Description Text Field Constraints
        shortDescriptionTextView.topAnchor.constraint(equalTo: dividerLine7.bottomAnchor).isActive = true
        shortDescriptionTextView.leftAnchor.constraint(equalTo: shortDescriptionLabel.rightAnchor, constant: 5).isActive = true
        shortDescriptionTextView.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        
        // Short Divider Line After Short Description Constraints
        dividerLine8.topAnchor.constraint(equalTo: shortDescriptionTextView.bottomAnchor).isActive = true
        dividerLine8.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        dividerLine8.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10).isActive = true
        dividerLine8.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Long Description Label Constraints
        longDescriptionLabel.topAnchor.constraint(equalTo: dividerLine8.bottomAnchor).isActive = true
        longDescriptionLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        longDescriptionLabel.widthAnchor.constraint(equalToConstant: scrollView.frame.size.width/4).isActive = true
        longDescriptionLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Long Description Text Field Constraints
        longDescriptionTextView.topAnchor.constraint(equalTo: dividerLine8.bottomAnchor).isActive = true
        longDescriptionTextView.leftAnchor.constraint(equalTo: longDescriptionLabel.rightAnchor, constant: 5).isActive = true
        longDescriptionTextView.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
    }
    
    func setUpBlurAndVibrancy() {
        
        // Blur and vibrancy effects
        vibrancyEffectView.frame = view.bounds
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        view.addSubview(vibrancyEffectView)
        blurEffectView.contentView.addSubview(vibrancyEffectView)
        vibrancyEffectView.contentView.addSubview(dateOfBirthPicker)
        blurEffectView.isHidden = true
        vibrancyEffectView.isHidden = true
        
        // PopUp View Constraints
        let margins = vibrancyEffectView.layoutMarginsGuide
        dateOfBirthPicker.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        dateOfBirthPicker.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        dateOfBirthPicker.widthAnchor.constraint(equalTo: margins.widthAnchor, constant: -50).isActive = true
        dateOfBirthPicker.heightAnchor.constraint(equalTo: dateOfBirthPicker.widthAnchor).isActive = true
        
    }
    
    // Done this way because tap gesture recognizers would not work otherwise
    func setUpButtons() {
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleChangeProfilePicture))
        pictureView.addGestureRecognizer(tapRecognizer)
        
        changePictureButton.addTarget(self, action: #selector(handleChangeProfilePicture), for: .touchUpInside)
        
        changePasswordButton.addTarget(self, action: #selector(handleChangePassword), for: .touchUpInside)

        dateOfBirthButton.addTarget(self, action: #selector(handleDateOfBirthPickerAppearance), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
        
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSave))
        navigationItem.rightBarButtonItem = saveButton
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = cancelButton
        
        setUpButtons()
        
        setUpTextFields()
        
        setUpUI()
        
        setUpBlurAndVibrancy()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.title = "Edit Profile"
        tabBarController?.tabBar.isHidden = true
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight*1.5)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        scrollView.endEditing(true)
        return true
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
        if (text == "\n" && textView == shortDescriptionTextView) {
            textView.resignFirstResponder()
            return false
        }
        
        // Check for too many \n, we do not want 600 new lines (since they are counted as chars). We only check this for longDescriptionTextView, since when a new line is trying to be introduced in shortDescriptionTextView, the keyboard returns
        if tooManyNewLines(in: textView, range: range, text: text) {
            return false
        }
        
        // Limit the number of maximum chars
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        if textView == shortDescriptionTextView {
            return numberOfChars < 140
        } else if textView == longDescriptionTextView {
            return numberOfChars < 600
        }
        return true
    }
}
