//
//  EditPostController.swift
//  Found
//
//  Created by Sergio Hernandez on 19/11/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
import Firebase

class EditPostController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate {
    
    typealias FinishedDownload = () -> ()
    
    var post: Post!
    
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
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.text = "Information"
        label.textColor = Color.strongOrange
        label.backgroundColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var optionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Options"
        label.textColor = Color.strongOrange
        label.backgroundColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var titleTextView: UITextView = {
        let textView = UITextView()
        textView.returnKeyType = .done
        textView.backgroundColor = .white
        textView.textContainer.lineFragmentPadding = 0
        // textView.textContainer.maximumNumberOfLines = 4 // No need for this if we limit the number of chars
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.isScrollEnabled = false // By setting this to false, the text view autoresizes when more lines are needed
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var dateTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "When"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dateTimeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var dateTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.minuteInterval = 15
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    var anytimeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Anytime", for: .normal)
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var placeLabel: UILabel = {
        let label = UILabel()
        label.text = "Where"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var placeTextView: UITextView = {
        let textView = UITextView()
        textView.returnKeyType = .done
        textView.backgroundColor = .white
        textView.textContainer.lineFragmentPadding = 0
        // textView.textContainer.maximumNumberOfLines = 4 // No need for this if we limit the number of chars
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.isScrollEnabled = false // By setting this to false, the text view autoresizes when more lines are needed
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var detailsLabel: UILabel = {
        let label = UILabel()
        label.text = "Details"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var detailsTextView: UITextView = {
        let textView = UITextView()
        textView.returnKeyType = .default
        textView.backgroundColor = .white
        textView.textContainer.lineFragmentPadding = 0
        // textView.textContainer.maximumNumberOfLines = 15 // No need for this if we limit the number of chars
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.isScrollEnabled = false // By setting this to false, the text view autoresizes when more lines are needed
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var deletePostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete this post", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleDateTimePickerAppearance() {
        
        // Animate Date-Time Picker and Anytime Button
        dateTimePicker.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        dateTimePicker.alpha = 0
        anytimeButton.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        anytimeButton.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.blurEffectView.isHidden = false
            self.vibrancyEffectView.isHidden = false
            self.dateTimePicker.alpha = 1
            self.dateTimePicker.transform = CGAffineTransform.identity
            self.anytimeButton.alpha = 1
            self.anytimeButton.transform = CGAffineTransform.identity
        }
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch? = touches.first
        if (touch?.view != dateTimePicker) && (blurEffectView.isHidden == false) {
            // Set date of interactive date of birth picker label
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE dd LLLL, HH:mm"
            let dateTime = dateFormatter.string(from: dateTimePicker.date)
            dateTimeButton.setTitle(dateTime, for: .normal)
            dismissDateTimePicker()
        }
        
    }
    
    func dismissDateTimePicker() {
        
        // Animate dismissal
        UIView.animate(withDuration: 0.3, animations: {
            self.dateTimePicker.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.dateTimePicker.alpha = 0
            self.anytimeButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.anytimeButton.alpha = 0
        }) { (success: Bool) in
            self.blurEffectView.isHidden = true
            self.vibrancyEffectView.isHidden = true
            self.navigationController?.isNavigationBarHidden = false
            self.view.endEditing(true)
        }
        
    }
    
    @objc func handleAnytimeChosen(_ sender: UIButton) {
        dateTimeButton.setTitle("Anytime", for: .normal)
        dismissDateTimePicker()
    }
    
    func deletePost() {
        
        FIRDatabase.database().reference().child("posts").child(post.id).removeValue(completionBlock: { (error, ref) in
            
            if error != nil {
                print("Failed to delete post: ", error!)
                return
            }
            
            let postListController = self.navigationController?.viewControllers[0] as! PostListController
            postListController.loadPostsOnce()
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    @objc func handleDeletePost(_ sender: UIButton) {
        
        // Present the alert to confirm
        let alert = UIAlertController(title: "Delete Post", message: "Are you sure?", preferredStyle: .alert)
        let clearAction = UIAlertAction(title: "Yes", style: .destructive) { (alert: UIAlertAction!) -> Void in
            self.deletePost()
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { (alert: UIAlertAction!) -> Void in
            // Nothing is done
        }
        
        alert.addAction(clearAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion:nil)
    }
    
    @objc func handleSave(_ sender: UIButton) {
        
        // Update post
        post.title = titleTextView.text!
        post.time = dateTimeButton.currentTitle!
        post.place = placeTextView.text!
        post.details = detailsTextView.text!

        if self.dataIsValid() {
            let data = ["title" : post.title!, "time" : post.time!, "place" : post.place!, "details" : post.details!]
            FIRDatabase.database().reference().child("posts").child(self.post.id!).updateChildValues(data, withCompletionBlock: { (err, ref) in
                let postController = self.navigationController?.viewControllers[1] as! PostController
                postController.post = self.post
                let postListController = self.navigationController?.viewControllers[0] as! PostListController
                postListController.loadPostsOnce()
                // Assuming the EditProfileController is presented and not pushed
                // Otherwise do: dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    @objc func handleCancel(_ sender: UIButton) {
        // Assuming the EditProfileController is presented and not pushed
        // Otherwise do: dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    func presentInvalidDataAlert() {
        let alert = UIAlertController(title: "Some information is incomplete", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
            // Alert is dismissed
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion:nil)
    }
    
    func dataIsValid() -> Bool {
        // Check that all the info is valid
        if titleTextView.text == "" {
            presentInvalidDataAlert()
            return false
        } else if placeTextView.text == "" {
            presentInvalidDataAlert()
            return false
        }
        return true
    }
    
    func setUpTextFields() {
        
        // Default Content
        titleTextView.text = post.title
        placeTextView.text = post.place
        detailsTextView.text = post.details
        dateTimeButton.setTitle(post.time, for: .normal)
        dateTimeButton.titleLabel?.font = titleLabel.font
        titleTextView.font = titleLabel.font
        placeTextView.font = titleLabel.font
        detailsTextView.font = titleLabel.font
        if post.time != "Anytime" {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE dd LLLL, HH:mm"
            dateTimePicker.date = formatter.date(from: post.time!)!
        }
        
        // Delegates
        placeTextView.delegate = self
        titleTextView.delegate = self
        detailsTextView.delegate = self
    }
    
    func setUpUI() {
        
        let dividerLine1 = DividerLine()
        let dividerLine2 = DividerLine()
        let dividerLine3 = DividerLine()
        let dividerLine4 = DividerLine()
        let dividerLine5 = DividerLine()
        
        view.addSubview(informationLabel)
        view.addSubview(titleLabel)
        view.addSubview(titleTextView)
        view.addSubview(dateTimeLabel)
        view.addSubview(dateTimeButton)
        view.addSubview(placeLabel)
        view.addSubview(placeTextView)
        view.addSubview(detailsLabel)
        view.addSubview(detailsTextView)
        view.addSubview(optionsLabel)
        view.addSubview(deletePostButton)
        view.addSubview(dividerLine1)
        view.addSubview(dividerLine2)
        view.addSubview(dividerLine3)
        view.addSubview(dividerLine4)
        view.addSubview(dividerLine5)
        
        let margins = view.layoutMarginsGuide
        
        // Information Label Constraints
        informationLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        informationLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Long Divider Line After Information Label Constraints
        dividerLine1.topAnchor.constraint(equalTo: informationLabel.bottomAnchor).isActive = true
        dividerLine1.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        dividerLine1.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        dividerLine1.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        // Title Label Constraints
        titleLabel.topAnchor.constraint(equalTo: dividerLine1.bottomAnchor, constant: 5).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width/4).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Title Text View Constraints
        titleTextView.topAnchor.constraint(equalTo: dividerLine1.bottomAnchor, constant: 5).isActive = true
        titleTextView.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 5).isActive = true
        titleTextView.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        
        // Short Divider Line After Title Constraints
        dividerLine2.topAnchor.constraint(equalTo: titleTextView.bottomAnchor).isActive = true
        dividerLine2.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        dividerLine2.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10).isActive = true
        dividerLine2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Place Label Constraints
        placeLabel.topAnchor.constraint(equalTo: dividerLine2.bottomAnchor).isActive = true
        placeLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        placeLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width/4).isActive = true
        placeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Place Text Field Constraints
        placeTextView.topAnchor.constraint(equalTo: dividerLine2.bottomAnchor).isActive = true
        placeTextView.leftAnchor.constraint(equalTo: placeLabel.rightAnchor, constant: 5).isActive = true
        placeTextView.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        
        // Short Divider Line After Place Constraints
        dividerLine3.topAnchor.constraint(equalTo: placeTextView.bottomAnchor).isActive = true
        dividerLine3.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        dividerLine3.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10).isActive = true
        dividerLine3.heightAnchor.constraint(equalToConstant: 1).isActive = true

        // Date Time Label Constraints
        dateTimeLabel.topAnchor.constraint(equalTo: dividerLine3.bottomAnchor, constant: 5).isActive = true
        dateTimeLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        dateTimeLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width/4).isActive = true
        dateTimeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Date Time Button Constraints
        dateTimeButton.topAnchor.constraint(equalTo: dividerLine3.bottomAnchor, constant: 5).isActive = true
        dateTimeButton.leftAnchor.constraint(equalTo: dateTimeLabel.rightAnchor, constant: 5).isActive = true
        dateTimeButton.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        dateTimeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Short Divider Line After Date-Time Constraints
        dividerLine4.topAnchor.constraint(equalTo: dateTimeLabel.bottomAnchor).isActive = true
        dividerLine4.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        dividerLine4.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10).isActive = true
        dividerLine4.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Details Label Constraints
        detailsLabel.topAnchor.constraint(equalTo: dividerLine4.bottomAnchor).isActive = true
        detailsLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        detailsLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width/4).isActive = true
        detailsLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Details Text View Constraints
        detailsTextView.topAnchor.constraint(equalTo: dividerLine4.bottomAnchor).isActive = true
        detailsTextView.leftAnchor.constraint(equalTo: detailsLabel.rightAnchor, constant: 5).isActive = true
        detailsTextView.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        
        // Options Label Constraints
        optionsLabel.topAnchor.constraint(equalTo: detailsTextView.bottomAnchor, constant: 30).isActive = true
        optionsLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        optionsLabel.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        optionsLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Long Divider Line After Private Information Label Constraints
        dividerLine5.topAnchor.constraint(equalTo: optionsLabel.bottomAnchor).isActive = true
        dividerLine5.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        dividerLine5.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        dividerLine5.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        // Name Label Constraints
        deletePostButton.topAnchor.constraint(equalTo: dividerLine5.bottomAnchor, constant: 5).isActive = true
        deletePostButton.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        deletePostButton.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        deletePostButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setUpBlurAndVibrancy() {
        
        // Blur and vibrancy effects
        vibrancyEffectView.frame = view.bounds
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        view.addSubview(vibrancyEffectView)
        blurEffectView.contentView.addSubview(vibrancyEffectView)
        vibrancyEffectView.contentView.addSubview(dateTimePicker)
        vibrancyEffectView.contentView.addSubview(anytimeButton)
        blurEffectView.isHidden = true
        vibrancyEffectView.isHidden = true
        
        let margins = vibrancyEffectView.layoutMarginsGuide

        // Date Time Picker Constraints
        dateTimePicker.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        dateTimePicker.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        dateTimePicker.widthAnchor.constraint(equalTo: margins.widthAnchor, constant: -50).isActive = true
        dateTimePicker.heightAnchor.constraint(equalTo: dateTimePicker.widthAnchor).isActive = true
        
        // Anytime Button Constraints
        anytimeButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        anytimeButton.topAnchor.constraint(equalTo: dateTimePicker.bottomAnchor).isActive = true
        anytimeButton.widthAnchor.constraint(equalTo: dateTimePicker.widthAnchor).isActive = true
        anytimeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    // Done this way because tap gesture recognizers would not work otherwise
    func setUpButtons() {
        
        dateTimeButton.addTarget(self, action: #selector(handleDateTimePickerAppearance), for: .touchUpInside)
        
        anytimeButton.addTarget(self, action: #selector(handleAnytimeChosen), for: .touchUpInside)
        
        deletePostButton.addTarget(self, action: #selector(handleDeletePost), for: .touchUpInside)
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
        navigationItem.title = "Edit Post"
        tabBarController?.tabBar.isHidden = true
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
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
    
    // Restrict number of characters
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n" && (textView == titleTextView || textView == placeTextView)) {
            textView.resignFirstResponder()
            return false
        }
        
        // Check for too many \n, we do not want 600 new lines (since they are counted as chars). We only check this for detailsTextView, since when a new line is trying to be introduced in titleTextView, the keyboard returns
        if tooManyNewLines(in: textView, range: range, text: text) {
            return false
        }
        
        // Limit the number of maximum chars
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        if textView == titleTextView {
            return numberOfChars < 140
        } else if textView == placeTextView {
            return numberOfChars < 50
        } else if textView == detailsTextView {
            return numberOfChars < 600
        }
        return true
    }
    
}
