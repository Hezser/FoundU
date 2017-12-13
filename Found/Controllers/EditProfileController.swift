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
    var workCount = 0
    var studiesCount = 0
    var studiesDividerTopConstraint: NSLayoutConstraint!
    var workHeight: CGFloat = 40
    var studiesHeight: CGFloat = 40
    
    var scrollView: UIScrollView = {
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        let view = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        view.backgroundColor = Color.veryLightOrange
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
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var changePictureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change your profile picture", for: .normal)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(Color.lightOrange, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var privateInformationLabel: UILabel = {
        let label = UILabel()
        label.text = "Private Information"
        label.backgroundColor = .clear
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = Color.lightOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var publicInformationLabel: UILabel = {
        let label = UILabel()
        label.text = "Public Information"
        label.backgroundColor = .clear
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = Color.lightOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var changePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change your password", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(Color.lightOrange, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var emailTextField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.backgroundColor = .clear
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var nameTextField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.backgroundColor = .clear
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var dateOfBirthLabel: UILabel = {
        let label = UILabel()
        label.text = "Birthdate"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dateOfBirthButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
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
        label.text = "Home"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var homePlaceTextField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.backgroundColor = .clear
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var bioLabel: UILabel = {
        let label = UILabel()
        label.text = "Bio"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var bioTextView: UITextView = {
        let textView = UITextView()
        textView.returnKeyType = .done
        textView.backgroundColor = .clear
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.isScrollEnabled = false // By setting this to false, the text view autoresizes when more lines are needed
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var workLabel: UILabel = {
        let label = UILabel()
        label.text = "Work"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var addWorkButton: UIButton = {
        let button = UIButton(type: .contactAdd)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Color.lightOrange
        return button
    }()
    
    var dividerLineWork1: DividerLine!
    var dividerLineWork2: DividerLine!
    var dividerLineWork3: DividerLine!
    
    var whereWorkLabel1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "at"
        label.textColor = Color.lightOrange
        return label
    }()
    
    var whereWorkTextField1: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.placeholder = "company"
        textField.backgroundColor = .clear
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var whatWorkTextField1: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.placeholder = "Position"
        textField.backgroundColor = .clear
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var whereWorkLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "at"
        label.textColor = Color.lightOrange
        return label
    }()
    
    var whereWorkTextField2: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.placeholder = "company"
        textField.backgroundColor = .clear
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var whatWorkTextField2: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.placeholder = "Position"
        textField.backgroundColor = .clear
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var whereWorkLabel3: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "at"
        label.textColor = Color.lightOrange
        return label
    }()
    
    var whereWorkTextField3: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.placeholder = "company"
        textField.backgroundColor = .clear
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var whatWorkTextField3: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.placeholder = "Position"
        textField.backgroundColor = .clear
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var studiesLabel: UILabel = {
        let label = UILabel()
        label.text = "Studies"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var addStudiesButton: UIButton = {
        let button = UIButton(type: .contactAdd)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Color.lightOrange
        return button
    }()

    var dividerLineStudies1: DividerLine!
    var dividerLineStudies2: DividerLine!
    var dividerLineStudies3: DividerLine!

    var whereStudiesLabel1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "at"
        label.textColor = Color.lightOrange
        return label
    }()

    var whereStudiesTextField1: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.placeholder = "institution"
        textField.backgroundColor = .clear
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    var whatStudiesTextField1: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.placeholder = "Course"
        textField.backgroundColor = .clear
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    var whereStudiesLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "at"
        label.textColor = Color.lightOrange
        return label
    }()

    var whereStudiesTextField2: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.placeholder = "institution"
        textField.backgroundColor = .clear
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    var whatStudiesTextField2: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.placeholder = "Course"
        textField.backgroundColor = .clear
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    var whereStudiesLabel3: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "at"
        label.textColor = Color.lightOrange
        return label
    }()

    var whereStudiesTextField3: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.placeholder = "institution"
        textField.backgroundColor = .clear
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    var whatStudiesTextField3: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.placeholder = "Course"
        textField.backgroundColor = .clear
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
    
    fileprivate func prepareDataFor(_ variable: Variable) -> [String] {
        
        var data: [String] = []
        if variable == .work {
            if (whatWorkTextField1.text != "") {
                data.append(whatWorkTextField1.text! + " at " + whereWorkTextField1.text!)
            } else {
                data.append("")
            }
            if (whatWorkTextField2.text != "") {
                data.append(whatWorkTextField2.text! + " at " + whereWorkTextField2.text!)
            } else {
                data.append("")
            }
            if (whatWorkTextField3.text != "") {
                data.append(whatWorkTextField3.text! + " at " + whereWorkTextField3.text!)
            } else {
                data.append("")
            }
        } else if variable == .studies {
            if (whatStudiesTextField1.text != "") {
                data.append(whatStudiesTextField1.text! + " at " + whereStudiesTextField1.text!)
            } else {
                data.append("")
            }
            if (whatStudiesTextField2.text != "") {
                data.append(whatStudiesTextField2.text! + " at " + whereStudiesTextField2.text!)
            } else {
                data.append("")
            }
            if (whatStudiesTextField3.text != "") {
                data.append(whatStudiesTextField3.text! + " at " + whereStudiesTextField3.text!)
            } else {
                data.append("")
            }
        }
        
        return data
    }
    
    @objc func handleSave(_ sender: UIButton) {
        
        // Update user
        user.name = nameTextField.text!
        user.age = dateOfBirthPicker.date.age
        user.dateOfBirth = dateOfBirthButton.currentTitle!
        user.place = homePlaceTextField.text!
        user.bio = bioTextView.text!
        user.work = prepareDataFor(.work)
        user.studies = prepareDataFor(.studies)
        
        // saveImage() is done first because it updates user.profileImageURL, which is used in data to upload to the user's section in Firebase database
        saveImage(completion: {
            if self.dataIsValid() {
                let data = ["pictureURL" : self.user.profileImageURL!, "email" : self.emailTextField.text!, "name" : self.user.name!, "age" : String(describing: self.user.age!), "date of birth" : self.user.dateOfBirth!, "place" : self.user.place!, "bio" : self.user.bio!, "work" : self.user.work!, "studies" : self.user.studies!] as [String : Any]
                if self.user.email != self.emailTextField.text! {
                    FIRAuth.auth()?.currentUser?.updateEmail(self.emailTextField.text!, completion: {(error) in
                        if error != nil {
                            print(error!)
                            // Alert of the invalidity of password
                            let alert = UIAlertController(title: "Invalid email", message: nil, preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
                                // Alert is dismissed
                            }
                            alert.addAction(alertAction)
                            self.present(alert, animated: true, completion:nil)
                        } else {
                            self.user.email = self.emailTextField.text!
                            FIRDatabase.database().reference().child("users").child(self.user.id!).updateChildValues(data, withCompletionBlock: { (err, ref) in
//                                let profile = self.navigationController?.viewControllers.first as! ProfileController
//                                profile.user = self.user
//                                self.navigationController?.popViewController(animated: true)
                                // In order to instantly update, we need to present, not pop (if we add studies/work fields, how do you create new ExperienceFields in viewDidAppear?
                                let menu = MenuController()
                                menu.user = self.user
                                menu.itemToDisplay = 4
                                self.present(menu, animated: true)
                                
                            })
                        }
                    })
                } else {
                    FIRDatabase.database().reference().child("users").child(self.user.id!).updateChildValues(data, withCompletionBlock: { (err, ref) in
                        // let profile = self.navigationController?.viewControllers.first as! ProfileController
                        // profile.user = self.user
                        // self.navigationController?.popViewController(animated: true)
                        // In order to instantly update, we need to present, not pop (if we add studies/work fields, how do you create new ExperienceFields in viewDidAppear?
                        let menu = MenuController()
                        menu.user = self.user
                        menu.itemToDisplay = 4
                        self.present(menu, animated: true)
                    })
                }
            }
        })
    }
    
    @objc func handleCancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func presentInvalidDataAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Some information is incomplete: \(message).", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
            // Alert is dismissed
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion:nil)
    }
    
    func dataIsValid() -> Bool {
        
        // Check that all the info is valid
        if nameTextField.text == "" {
            presentInvalidDataAlert(withMessage: "Your must have a name")
            return false
        } else if homePlaceTextField.text == "" {
            presentInvalidDataAlert(withMessage: "You must have grown up somewhere")
            return false
        } else if bioTextView.text == "" {
            presentInvalidDataAlert(withMessage: "You need to have a short bio")
            return false
        } else if (whatWorkTextField1.text != "" && whereWorkTextField1.text == "") || (whatWorkTextField1.text == "" && whereWorkTextField1.text != "") {
            presentInvalidDataAlert(withMessage: "You cannot start a work field without finishing it")
            return false
        } else if (whatWorkTextField2.text != "" && whereWorkTextField2.text == "") || (whatWorkTextField2.text == "" && whereWorkTextField2.text != "") {
            presentInvalidDataAlert(withMessage: "You cannot start a work field without finishing it")
            return false
        } else if (whatWorkTextField3.text != "" && whereWorkTextField3.text == "") || (whatWorkTextField3.text == "" && whereWorkTextField3.text != "") {
            presentInvalidDataAlert(withMessage: "You cannot start a work field without finishing it")
            return false
        } else if (whatStudiesTextField1.text != "" && whereStudiesTextField1.text == "") || (whatStudiesTextField1.text == "" && whereStudiesTextField1.text != "") {
            presentInvalidDataAlert(withMessage: "You cannot start a studies field without finishing it")
            return false
        } else if (whatStudiesTextField2.text != "" && whereStudiesTextField2.text == "") || (whatStudiesTextField2.text == "" && whereStudiesTextField2.text != "") {
            presentInvalidDataAlert(withMessage: "You cannot start a studies field without finishing it")
            return false
        } else if (whatStudiesTextField2.text != "" && whereStudiesTextField2.text == "") || (whatStudiesTextField2.text == "" && whereStudiesTextField2.text != "") {
            presentInvalidDataAlert(withMessage: "You cannot start a studies field without finishing it")
            return false
        }
        
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
    
    func setUpContent() {
        
        // Default Content
        setUserImage(fromURLString: user.profileImageURL!)
        emailTextField.text = user.email
        nameTextField.text = user.name
        homePlaceTextField.text = user.place
        bioTextView.text = user.bio
        dateOfBirthButton.setTitle(user.dateOfBirth, for: .normal)
        dateOfBirthButton.titleLabel?.font = nameLabel.font
        bioTextView.font = nameLabel.font
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM, yyyy"
        dateOfBirthPicker.date = formatter.date(from: user.dateOfBirth!)!
        for work in user.work! {
            if work != "" {
                let workStrings = separateInformation(for: work)
                if workCount == 0 {
                    whatWorkTextField1.text = workStrings[0]
                    whereWorkTextField1.text = workStrings[1]
                    setUpField(whereWorkLabel1, whereWorkTextField1, whatWorkTextField1, after: dividerLineWork1)
                } else if workCount == 1 {
                    whatWorkTextField2.text = workStrings[0]
                    whereWorkTextField2.text = workStrings[1]
                    setUpField(whereWorkLabel2, whereWorkTextField2, whatWorkTextField2, after: whereWorkTextField1)
                } else if workCount == 2 {
                    whatWorkTextField3.text = workStrings[0]
                    whereWorkTextField3.text = workStrings[1]
                    setUpField(whereWorkLabel3, whereWorkTextField3, whatWorkTextField3, after: whereWorkTextField2)
                }
                workCount += 1
            }
        }
        for studies in user.studies! {
            if studies != "" {
                let studiesStrings = separateInformation(for: studies)
                if studiesCount == 0 {
                    whatStudiesTextField1.text = studiesStrings[0]
                    whereStudiesTextField1.text = studiesStrings[1]
                    setUpField(whereStudiesLabel1, whereStudiesTextField1, whatStudiesTextField1, after: dividerLineStudies1)
                } else if studiesCount == 1 {
                    whatStudiesTextField2.text = studiesStrings[0]
                    whereStudiesTextField2.text = studiesStrings[1]
                    setUpField(whereStudiesLabel2, whereStudiesTextField2, whatStudiesTextField2, after: whereStudiesTextField1)
                } else if studiesCount == 2 {
                    whatStudiesTextField3.text = studiesStrings[0]
                    whereStudiesTextField3.text = studiesStrings[1]
                    setUpField(whereStudiesLabel3, whereStudiesTextField3, whatStudiesTextField3, after: whereStudiesTextField2)
                }
                studiesCount += 1
            }
        }
        
        // Delegates
        emailTextField.delegate = self
        nameTextField.delegate = self
        homePlaceTextField.delegate = self
        bioTextView.delegate = self
    }
    
    func setUpUI() {
        
        let dividerLine1 = DividerLine()
        let dividerLine2 = DividerLine()
        let dividerLine4 = DividerLine()
        let dividerLine5 = DividerLine()
        let dividerLine6 = DividerLine()
        let dividerLine7 = DividerLine()
        dividerLineWork1 = DividerLine()
        dividerLineWork2 = DividerLine()
        dividerLineWork3 = DividerLine()
        dividerLineStudies1 = DividerLine()
        dividerLineStudies2 = DividerLine()
        dividerLineStudies3 = DividerLine()
        
        view.addSubview(scrollView)
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
        scrollView.addSubview(bioLabel)
        scrollView.addSubview(workLabel)
        scrollView.addSubview(studiesLabel)
        scrollView.addSubview(addWorkButton)
        scrollView.addSubview(addStudiesButton)
        scrollView.addSubview(nameTextField)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(changePasswordButton)
        scrollView.addSubview(homePlaceTextField)
        scrollView.addSubview(dateOfBirthButton)
        scrollView.addSubview(bioTextView)
        scrollView.addSubview(dividerLine1)
        scrollView.addSubview(dividerLine2)
        scrollView.addSubview(dividerLine4)
        scrollView.addSubview(dividerLine5)
        scrollView.addSubview(dividerLine6)
        scrollView.addSubview(dividerLine7)
        scrollView.addSubview(dividerLineWork1)
        scrollView.addSubview(dividerLineStudies1)
        
        let margins = scrollView.layoutMarginsGuide
        
        // Spacing View Constraints
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
        
        // Bio Label Constraints
        bioLabel.topAnchor.constraint(equalTo: dividerLine7.bottomAnchor).isActive = true
        bioLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        bioLabel.widthAnchor.constraint(equalToConstant: scrollView.frame.size.width/4).isActive = true
        bioLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Bio Text Field Constraints
        bioTextView.topAnchor.constraint(equalTo: dividerLine7.bottomAnchor).isActive = true
        bioTextView.leftAnchor.constraint(equalTo: bioLabel.rightAnchor, constant: 5).isActive = true
        bioTextView.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        
        // Short Divider Line After Bio Constraints
        dividerLineWork1.topAnchor.constraint(equalTo: bioTextView.bottomAnchor).isActive = true
        dividerLineWork1.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        dividerLineWork1.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10).isActive = true
        dividerLineWork1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Work Label Constraints
        workLabel.topAnchor.constraint(equalTo: dividerLineWork1.bottomAnchor).isActive = true
        workLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        workLabel.widthAnchor.constraint(equalToConstant: scrollView.frame.size.width/4).isActive = true
        workLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Add Work Button Constraints and Functionality
        addWorkButton.centerYAnchor.constraint(equalTo: workLabel.centerYAnchor).isActive = true
        addWorkButton.rightAnchor.constraint(equalTo: workLabel.rightAnchor).isActive = true
        addWorkButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addWorkButton.widthAnchor.constraint(equalTo: addWorkButton.heightAnchor).isActive = true
        
        addWorkButton.addTarget(self, action: #selector(handleNewWorkRequest), for: .touchUpInside)
        
        // Short Divider Line After Work Constraints
        studiesDividerTopConstraint = dividerLineStudies1.topAnchor.constraint(equalTo: workLabel.bottomAnchor, constant: 0)
        studiesDividerTopConstraint.isActive = true
        dividerLineStudies1.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        dividerLineStudies1.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10).isActive = true
        dividerLineStudies1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Studies Label Constraints
        studiesLabel.topAnchor.constraint(equalTo: dividerLineStudies1.bottomAnchor).isActive = true
        studiesLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        studiesLabel.widthAnchor.constraint(equalToConstant: scrollView.frame.size.width/4).isActive = true
        studiesLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Add Studies Button Constraints and Functionality
        addStudiesButton.centerYAnchor.constraint(equalTo: studiesLabel.centerYAnchor).isActive = true
        addStudiesButton.rightAnchor.constraint(equalTo: studiesLabel.rightAnchor).isActive = true
        addStudiesButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addStudiesButton.widthAnchor.constraint(equalTo: addStudiesButton.heightAnchor).isActive = true
        
        addStudiesButton.addTarget(self, action: #selector(handleNewStudiesRequest), for: .touchUpInside)

    }
    
    @objc func handleNewWorkRequest(_ sender: UIButton) {
        if workCount < 3 {
            switch workCount {
            case 0 :
                setUpField(whereWorkLabel1, whereWorkTextField1, whatWorkTextField1, after: dividerLineWork1)
                workCount += 1
            case 1 :
                setUpField(whereWorkLabel2, whereWorkTextField2, whatWorkTextField2, after: whereWorkTextField1)
                workCount += 1
            case 2 :
                setUpField(whereWorkLabel3, whereWorkTextField3, whatWorkTextField3, after: whereWorkTextField2)
                workCount += 1
            default :
                return
            }
        }
    }
    
    @objc func handleNewStudiesRequest(_ sender: UIButton) {
        if studiesCount < 3 {
            switch studiesCount {
            case 0 :
                setUpField(whereStudiesLabel1, whereStudiesTextField1, whatStudiesTextField1, after: dividerLineStudies1)
                studiesCount += 1
            case 1 :
                setUpField(whereStudiesLabel2, whereStudiesTextField2, whatStudiesTextField2, after: whereStudiesTextField1)
                studiesCount += 1
            case 2 :
                setUpField(whereStudiesLabel3, whereStudiesTextField3, whatStudiesTextField3, after: whereStudiesTextField2)
                studiesCount += 1
            default :
                return
            }
        }
    }
    
    func setUpField(_ whereLabel: UILabel, _ whereTextField: UITextField, _ whatTextField: UITextField, after topView: UIView) {
        
        var titleLabel = workLabel // By default, will change to studiesLabel if necesessary
        
        scrollView.addSubview(whereLabel)
        scrollView.addSubview(whereTextField)
        scrollView.addSubview(whatTextField)
        
        whereTextField.delegate = self
        whatTextField.delegate = self
        
        let margins = scrollView.layoutMarginsGuide
        
        // What Text View Constraints
        whatTextField.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        whatTextField.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 5).isActive = true
        whatTextField.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        whatTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // What Label Constraints
        whereLabel.topAnchor.constraint(equalTo: whatTextField.bottomAnchor, constant: -10).isActive = true
        whereLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 5).isActive = true
        whereLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        whereLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Where Text View Constraints
        whereTextField.topAnchor.constraint(equalTo: whatTextField.bottomAnchor, constant: -10).isActive = true
        whereTextField.leftAnchor.constraint(equalTo: whereLabel.rightAnchor, constant: 5).isActive = true
        whereTextField.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        whereTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        if whereLabel != whereWorkLabel1 && whereLabel != whereStudiesLabel1 {
            
            var dividerLine: DividerLine!
            if whereLabel == whereWorkLabel2 {
                workHeight += 70
                dividerLine = dividerLineWork2
                scrollView.addSubview(dividerLine)
                studiesDividerTopConstraint.constant += 70 // 40+40-10 of both textfields (where, what), -10 because we supperpose the textfields
                view.layoutIfNeeded()
            } else if whereLabel == whereWorkLabel3 {
                workHeight += 70
                addWorkButton.isHidden = true
                dividerLine = dividerLineWork3
                scrollView.addSubview(dividerLine)
                studiesDividerTopConstraint.constant += 70 // 40+40-10 of both textfields (where, what), -10 because we supperpose the textfields
            } else if whereLabel == whereStudiesLabel2 {
                studiesHeight += 70
                dividerLine = dividerLineStudies2
                scrollView.addSubview(dividerLine)
                titleLabel = studiesLabel
            } else if whereLabel == whereStudiesLabel3 {
                studiesHeight += 70
                addStudiesButton.isHidden = true
                dividerLine = dividerLineStudies3
                scrollView.addSubview(dividerLine)
                titleLabel = studiesLabel
            }
            
            // Divider Line Constraints
            dividerLine.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
            dividerLine.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 10).isActive = true
            dividerLine.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10).isActive = true
            dividerLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
        } else if whereLabel == whereWorkLabel1 {
            studiesDividerTopConstraint.constant += 30 // 40-10 because of the bottom textfield (the upper one is not counted since we are already under workLabel, and -10 because we supperpose the textfields)
            workHeight += 30
        } else if whereLabel == whereStudiesLabel1 {
            studiesHeight += 30
        }

    }
    
    func separateInformation(for string: String) -> [String] {
        var separatedString = [String]()
        if let range = string.range(of: " at ") {
            separatedString.append(String(string[..<range.lowerBound]))
            separatedString.append(String(string[range.upperBound...]))
        }
        return separatedString
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
        
        setUpUI()
        
        setUpContent()
        
        setUpBlurAndVibrancy()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        view.layoutIfNeeded()
        pictureView.setRounded()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.title = "Edit Profile"
        tabBarController?.tabBar.isHidden = true
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func calculateScrollViewHeight() -> CGFloat {
        view.layoutIfNeeded()
        var sum: CGFloat = 104 // Sum of blank vertical distance between views + width of divider lines
        sum += pictureView.frame.size.height
        sum += changePictureButton.frame.size.height
        sum += privateInformationLabel.frame.size.height
        sum += publicInformationLabel.frame.size.height
        sum += passwordLabel.frame.size.height
        sum += emailTextField.frame.size.height
        sum += nameTextField.frame.size.height
        sum += dateOfBirthLabel.frame.size.height
        sum += homePlaceTextField.frame.size.height
        sum += bioTextView.frame.size.height
        sum += workHeight
        sum += studiesHeight
        return sum
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        scrollView.contentSize = CGSize(width: screenWidth, height: calculateScrollViewHeight())
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            scrollView.contentInset = UIEdgeInsets.zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        scrollView.endEditing(true)
        return true
    }
    
    // Not used right know
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
    
    // Restrict number of characters
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n" && textView == bioTextView) {
            textView.resignFirstResponder()
            return false
        }

        // Limit the number of maximum chars
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        if textView == bioTextView {
            return numberOfChars < 140
        }
        return true
    }
    
    // Restrict number of characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        
        if textField == whatWorkTextField1 || textField == whatWorkTextField2 || textField == whatWorkTextField3 || textField == whereWorkTextField1 || textField == whereWorkTextField2 || textField == whereWorkTextField3 {
            return newLength <= 40
        } else if textField == nameTextField || textField == homePlaceTextField {
            return newLength <= 25
        }

        return newLength <= 100 // Bool
    }
}
