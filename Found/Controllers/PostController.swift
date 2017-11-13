//
//  PostController.swift
//  Found
//
//  Created by Sergio Hernandez on 22/10/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit

class PostController: UIViewController, UITextFieldDelegate {
    
    var post: Post!
    var user: User!
    
    typealias FinishedDownload = () -> ()
    
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
    
    var popUpView: UIView = {
        let popup = UIView()
        popup.translatesAutoresizingMaskIntoConstraints = false
        popup.backgroundColor = .lightGray
        popup.layer.cornerRadius = 10
        return popup
    }()
    
    var placeTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .center
        tf.returnKeyType = .done
        tf.font = UIFont(name: (tf.font?.fontName)!, size: 20)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.minuteInterval = 15
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    var meetButton: UIButton = {
       let button = UIButton()
        button.setTitle("Let's Meet!", for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(26)
        button.addTarget(self, action: #selector(handleMeetSetUp), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.6470588446, blue: 0.3098038733, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(26)
        button.addTarget(self, action: #selector(handleSendRequest), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.6470588446, blue: 0.3098038733, alpha: 1)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var placeLabel: UILabel = {
        let label = UILabel()
        label.text = "Nice Café @ London"
        label.font = UIFont.systemFont(ofSize: 16)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Used to not have to rearrange all other labels when "Anytime" is shown instead of date and time separately. This label will be empty (invisible) if there is a specific date and time for the post
    var anytimeExceptionalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var detailsLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.baselineAdjustment = .alignCenters
        label.text = "I'd love hearing from your feedback on this app!"
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "I'd love hearing from your feedback on this app!"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var userContainer: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .lightGray
        containerView.layer.cornerRadius = 10
        return containerView
    }()
    
    var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sergio Hernandez"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var userDescriptionLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.text = "I'd love hearing from your feedback on this app!"
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        // Set up text
        titleLabel.text = post.title
        placeLabel.text = post.place
        if post.time == "Anytime" {
            anytimeExceptionalLabel.text = "Anytime"
        } else {
            dateLabel.text = post.time[0...9]
            timeLabel.text = post.time[12...16]
        }
        userNameLabel.text = post.userName
        userDescriptionLabel.text = post.userDescription
        detailsLabel.text = post.details
        
        // Make sure the download of the picture is not so slow that it crashes the app
        let url = URL(string: post.userPictureURL)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)
        
        userImageView.image = image
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "Post"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    func setUpViews() {
        
        // UI
        view.addSubview(titleLabel)
        view.addSubview(timeLabel)
        view.addSubview(dateLabel)
        view.addSubview(anytimeExceptionalLabel)
        view.addSubview(placeLabel)
        view.addSubview(meetButton)
        
        let margins = view.layoutMarginsGuide
        
        // Title Label Constraints
        titleLabel.heightAnchor.constraint(equalToConstant: 90).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, constant: -40).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        
        // Date Label Constraints
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, multiplier: 1/2).isActive = true
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        
        // Time Label Constraints
        timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, multiplier: 1/2).isActive = true
        timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        
        // Place Label Constraints
        placeLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        placeLabel.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, multiplier: 1/2).isActive = true
        placeLabel.centerYAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
        placeLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        
        // Anytime Exceptional Label Constraints
        anytimeExceptionalLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        anytimeExceptionalLabel.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, multiplier: 1/2).isActive = true
        anytimeExceptionalLabel.centerYAnchor.constraint(equalTo: placeLabel.centerYAnchor).isActive = true
        anytimeExceptionalLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        
        setUpUserSectionView()
        
        view.addSubview(detailsLabel)
        
        // Details Label Constraints
        detailsLabel.heightAnchor.constraint(equalToConstant: 120).isActive = true
        detailsLabel.widthAnchor.constraint(equalTo: titleLabel.widthAnchor).isActive = true
        detailsLabel.topAnchor.constraint(equalTo: userContainer.layoutMarginsGuide.bottomAnchor, constant: 40).isActive = true
        detailsLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        
        // Meet Button Constraints
        meetButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        meetButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        meetButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        meetButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        setUpBlurAndVibrancy()
        
    }
    
    func setUpBlurAndVibrancy() {
        
        navigationController?.isNavigationBarHidden = true
        
        // Blur and vibrancy effects
        vibrancyEffectView.frame = view.bounds
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        view.addSubview(vibrancyEffectView)
        blurEffectView.contentView.addSubview(vibrancyEffectView)
        vibrancyEffectView.contentView.addSubview(popUpView)
        blurEffectView.isHidden = true
        vibrancyEffectView.isHidden = true

        // PopUp View Constraints
        let margins = vibrancyEffectView.layoutMarginsGuide
        popUpView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        popUpView.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        popUpView.widthAnchor.constraint(equalTo: margins.widthAnchor, constant: -50).isActive = true
        popUpView.heightAnchor.constraint(equalTo: popUpView.widthAnchor).isActive = true
        
        configurePopUp()
    }
    
    func setUpUserSectionView() {
        
        view.addSubview(userContainer)
        
        // If tapped inside, takes you to the user's profile
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePushUserProfile))
        userContainer.addGestureRecognizer(tapGesture)
        
        // User Container Constraints
        userContainer.heightAnchor.constraint(equalToConstant: 120).isActive = true
        userContainer.widthAnchor.constraint(equalTo: titleLabel.widthAnchor).isActive = true
        userContainer.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 40).isActive = true
        userContainer.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor).isActive = true
        
        userContainer.addSubview(userImageView)
        userContainer.addSubview(userNameLabel)
        userContainer.addSubview(userDescriptionLabel)
        
        let margins = userContainer.layoutMarginsGuide
        
        // User Image View Constraints
        userImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        userImageView.widthAnchor.constraint(equalTo: userImageView.heightAnchor).isActive = true
        userImageView.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        userImageView.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        
        // User Name Label Constraints
        userNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 5).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        
        // User Description Label Constraints
        userDescriptionLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        userDescriptionLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 10).isActive = true
        userDescriptionLabel.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        userDescriptionLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    @objc func handlePushUserProfile(sender: UITapGestureRecognizer) {
        let profile = ProfileController()
        profile.user = user
        profile.mainProfile = false
        profile.view.backgroundColor = .white // Setting background color is needed, otherwise I get a completely black screen (???)
        self.navigationController?.pushViewController(profile, animated: true)
    }
    
    @objc func handleMeetSetUp(sender: UIButton) {
        
        // Animate PopUp View
        popUpView.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        popUpView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.blurEffectView.isHidden = false
            self.vibrancyEffectView.isHidden = false
            self.popUpView.alpha = 1
            self.popUpView.transform = CGAffineTransform.identity
        }
        
        navigationController?.isNavigationBarHidden = true
    }
    
    func configurePopUp() {
        
        popUpView.addSubview(datePicker)
        popUpView.addSubview(placeTextField)
        popUpView.addSubview(sendButton)
        
        let margins = popUpView.layoutMarginsGuide
        
        // Date Picker Constraints & Date Settings
        datePicker.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        datePicker.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        datePicker.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalTo: datePicker.widthAnchor, multiplier: 1/2).isActive = true
        
        if post.time != "Anytime" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE dd MMM, hh:mm"
            datePicker.date = dateFormatter.date(from: post.time)!
        }
        
        // Place Text Field Constraints & Settings
        placeTextField.bottomAnchor.constraint(equalTo: datePicker.topAnchor, constant: -5).isActive = true
        placeTextField.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        placeTextField.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        placeTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        placeTextField.placeholder = post.place
        placeTextField.delegate = self
        
        // Send Button Constraints
        sendButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        sendButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 5).isActive = true
        sendButton.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 1/3).isActive = true
        sendButton.heightAnchor.constraint(equalTo: sendButton.widthAnchor, multiplier: 1/1.618034).isActive = true
        
        
    }
    
    @objc func handleSendRequest(sender: UIButton) {
        
        tabBarController?.selectedIndex = 1
        
        let messagesNavigationController = tabBarController?.selectedViewController as! UINavigationController
        let messagesController = messagesNavigationController.topViewController as! MessagesController
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd LLL"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let time = timeFormatter.string(from: datePicker.date)
        let date = dateFormatter.string(from: datePicker.date)
        var place: String
        if placeTextField.text == nil || placeTextField.text == "" {
            place = placeTextField.placeholder!
        } else {
            place = placeTextField.text!
        }
        
        messagesController.sendProposal(to: user, title: post.title, place: place, date: date, time: time)
        
        dismissPopUp()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch? = touches.first
        if touch?.view != popUpView {
            dismissPopUp()
        }
    }
    
    func dismissPopUp() {
        UIView.animate(withDuration: 0.3, animations: {
            self.popUpView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.popUpView.alpha = 0
        }) { (success: Bool) in
            self.blurEffectView.isHidden = true
            self.vibrancyEffectView.isHidden = true
            self.navigationController?.isNavigationBarHidden = false
            self.view.endEditing(true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}
