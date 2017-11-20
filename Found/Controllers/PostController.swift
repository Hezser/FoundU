//
//  PostController.swift
//  Found
//
//  Created by Sergio Hernandez on 22/10/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
import Firebase

class PostController: UIViewController, PopUpController {
    
    var user: User!
    var post: Post!
    
    var popUpView: PopUpView!
    var tabBarHeight: CGFloat = 50
    
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
    
    var meetButton: UIButton = {
       let button = UIButton()
        button.setTitle("Let's Meet!", for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(22)
        button.addTarget(self, action: #selector(handleMeetSetUp), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.6470588446, blue: 0.3098038733, alpha: 1)
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
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
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
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        if (user.id == uid) {
            // Set up edit button
            let editButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(handleEdit))
            navigationItem.rightBarButtonItem = editButton
            blurEffectView.isHidden = true // Otherwise the app crashes because in touchesBegan() it checks if blurEffectView is hidden to do some actions on popUpView. If the post is from the user, then setUpBlurAndVibrancy() will never be called, so popUpView will not be created and blurEffectView.isHidden will not be true. Hence actions will be made on a nil object
        } else {
            // Set up popup
            popUpView = PopUpView()
            popUpView.popUpController = self
            setUpBlurAndVibrancy()
            popUpView.configurePopUp()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpContent()
        navigationItem.largeTitleDisplayMode = .never
        if let height = tabBarController?.tabBar.frame.size.height {
            tabBarHeight = height
        }
        tabBarController?.tabBar.isHidden = true
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    @objc func handleEdit(_ sender: UIButton) {
        let editPostController = EditPostController()
        editPostController.post = post
        navigationController?.pushViewController(editPostController, animated: true)
    }
    
    func setUpContent() {
        
        // Clear previous text
        timeLabel.text = ""
        dateLabel.text = ""
        anytimeExceptionalLabel.text = ""
        
        // Set up text
        titleLabel.text = post.title
        placeLabel.text = post.place
        if post.time == "Anytime" {
            anytimeExceptionalLabel.text = "Anytime"
        } else {
            let commaIndex = post.time.indexDistance(of: ",")
            dateLabel.text = post.time[0...commaIndex!-1]
            timeLabel.text = post.time[commaIndex!+2...post.time.count-1]
        }
        
        userDescriptionLabel.text = post.userDescription
        detailsLabel.text = post.details
        
        // Make sure the download of the picture is not so slow that it crashes the app
        FIRDatabase.database().reference().child("users").child(post.userID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Set image
            let url = URL(string: snapshot.childSnapshot(forPath: "pictureURL").value as! String)
            let data = try? Data(contentsOf: url!)
            self.userImageView.image = UIImage(data: data!)
            // Set name
            self.userNameLabel.text = (snapshot.childSnapshot(forPath: "name").value as! String)
        })
    }
    
    func setUpViews() {
        
        // UI
        view.addSubview(titleLabel)
        view.addSubview(timeLabel)
        view.addSubview(dateLabel)
        view.addSubview(anytimeExceptionalLabel)
        view.addSubview(placeLabel)
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        if post.userID != uid {
            view.addSubview(meetButton)
        }
        
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
        
        if post.userID != uid {
            // Meet Button Constraints
            meetButton.heightAnchor.constraint(equalToConstant: tabBarHeight).isActive = true
            meetButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            meetButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            meetButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        }
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
    
    func sendProposal(forPost post: Post, time: String, date: String, place: String) {
        
        // We have to push the ChatController from the MessagesController in order to preserve the logical navigation of the app
        tabBarController?.selectedIndex = 1
        
        let messagesNavigationController = tabBarController?.selectedViewController as! UINavigationController
        let messagesController = messagesNavigationController.topViewController as! MessagesController
        
        messagesController.sendProposal(to: user, post: post, title: post.title, place: place, date: date, time: time)
        
        dismissPopUp()
    }
    
    @objc func handleMeetSetUp(sender: UIButton) {
        
        popUpView.addButtonFunctionality()

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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch? = touches.first
        if (touch?.view != popUpView) && (blurEffectView.isHidden == false) {
            dismissPopUp()
        } else if (touch?.view == popUpView) && (blurEffectView.isHidden == false) {
            self.view.endEditing(true)
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
}
