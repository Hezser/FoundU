//
//  PostController.swift
//  Found
//
//  Created by Sergio Hernandez on 22/10/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
import Firebase

class PostController: UIViewController, ProposalPopUpController, UITextViewDelegate, UIScrollViewDelegate, TagFieldHandler {
    
    typealias FinishedDownload = () -> ()
    
    var user: User!
    var post: Post!
    
    var proposalPopUpView: ProposalPopUpView!
    var tabBarHeight: CGFloat = 50
    
    // For the purpose of leaving space for the meet button
    var scrollViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = true
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
    
    var meetButton: UIButton = {
       let button = UIButton()
        button.setTitle("Let's Meet!", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.addTarget(self, action: #selector(handleMeetSetUp), for: .touchUpInside)
        button.backgroundColor = Color.lightOrange
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
    
    var placeTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // Used to not have to rearrange all other labels when "Anytime" is shown instead of date and time separately. This label will be empty (invisible) if there is a specific date and time for the post
    var anytimeExceptionalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var detailsTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var titleTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.font = UIFont.systemFont(ofSize: 26)
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var tagField: TagField!
    
    var userContainer: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = Color.lightOrange
        containerView.layer.cornerRadius = 10
        return containerView
    }()
    
    var userNameTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.textContainerInset = .zero
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var userDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.textContainerInset = .zero
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
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
        view.backgroundColor = Color.veryLightOrange
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.largeTitleDisplayMode = .never
        if let height = tabBarController?.tabBar.frame.size.height {
            tabBarHeight = height
        }
        tabBarController?.tabBar.isHidden = true
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    
    func handleTagSingleTap(forTag tag: String) {
        // Go to tag page
    }
    
    func handleTagDoubleTap(forTag tag: String) {
        // Upvote/Downvote (only if not your post)
    }
    
    @objc func handleEdit(_ sender: UIButton) {
        let editPostController = EditPostController()
        editPostController.post = post
        navigationController?.pushViewController(editPostController, animated: true)
    }
    
    public func configure() {
        
        // Set Up Tag Field
        tagField = TagField()
        tagField.isNotScrollable()
        tagField.setDoubleTapEnabled(to: true)
    
        scrollView.delegate = self
        titleTextView.delegate = self
        detailsTextView.delegate = self
        userDescriptionTextView.delegate = self
        userNameTextView.delegate = self
        
        setUpContent()
        setUpViews()
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        if (user.id == uid) {
            // Set up edit button
            let editButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(handleEdit))
            navigationItem.rightBarButtonItem = editButton
            blurEffectView.isHidden = true // Otherwise the app crashes because in touchesBegan() it checks if blurEffectView is hidden to do some actions on popUpView. If the post is from the user, then setUpBlurAndVibrancy() will never be called, so popUpView will not be created and blurEffectView.isHidden will not be true. Hence actions will be made on a nil object
        } else {
            // Set up popup
            proposalPopUpView = ProposalPopUpView()
            proposalPopUpView.proposalPopUpController = self
            setUpBlurAndVibrancy()
            proposalPopUpView.configurePopUp()
        }
        
    }
    
    func setUpContent() {
        
        // Clear previous text
        timeLabel.text = ""
        dateLabel.text = ""
        anytimeExceptionalLabel.text = ""
        
        // Set up text
        titleTextView.text = post.title
        placeTextView.text = post.place
        if post.time == "Anytime" {
            anytimeExceptionalLabel.text = "Anytime"
        } else {
            let commaIndex = post.time.indexDistance(of: ",")
            dateLabel.text = post.time[0...commaIndex!-1]
            timeLabel.text = post.time[commaIndex!+2...post.time.count-1]
        }
        
        userDescriptionTextView.text = post.userDescription
        detailsTextView.text = post.details
        userImageView.image = post.userPicture
        userNameTextView.text = post.userName
        if let tags = post.tags {
            tagField.setTags(tags)
        }
        
    }
    
    func setUpViews() {
        
        // UI
        view.addSubview(scrollViewContainer)
        scrollViewContainer.addSubview(scrollView)
        scrollView.addSubview(titleTextView)
        scrollView.addSubview(timeLabel)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(anytimeExceptionalLabel)
        scrollView.addSubview(placeTextView)
        
        var spacing: CGFloat = 0
        let uid = FIRAuth.auth()?.currentUser?.uid
        if post.userID != uid {
            spacing = tabBarHeight
            view.addSubview(meetButton)
        }
        
        // Scroll View Container Constraints
        scrollViewContainer.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true // negative (wtf swift???)
        scrollViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -spacing).isActive = true
        scrollViewContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollViewContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        // Scroll View Constraints
        scrollView.topAnchor.constraint(equalTo: scrollViewContainer.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: scrollViewContainer.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: scrollViewContainer.rightAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: scrollViewContainer.heightAnchor).isActive = true
        
        let margins = scrollView.layoutMarginsGuide
        
        // Title Label Constraints
        titleTextView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        titleTextView.widthAnchor.constraint(equalTo: margins.widthAnchor, constant: -40).isActive = true
        titleTextView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        
        // Date Label Constraints
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: titleTextView.widthAnchor, multiplier: 1/2).isActive = true
        dateLabel.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 30).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: titleTextView.leftAnchor).isActive = true
        
        // Time Label Constraints
        timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: titleTextView.widthAnchor, multiplier: 1/2).isActive = true
        timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: titleTextView.leftAnchor).isActive = true
        
        // Place Text View Constraints
        placeTextView.widthAnchor.constraint(equalTo: titleTextView.widthAnchor, multiplier: 1/2).isActive = true
        placeTextView.centerYAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
        placeTextView.rightAnchor.constraint(equalTo: titleTextView.rightAnchor).isActive = true
        
        // Anytime Exceptional Label Constraints
        anytimeExceptionalLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        anytimeExceptionalLabel.widthAnchor.constraint(equalTo: titleTextView.widthAnchor, multiplier: 1/2).isActive = true
        anytimeExceptionalLabel.centerYAnchor.constraint(equalTo: placeTextView.centerYAnchor).isActive = true
        anytimeExceptionalLabel.leftAnchor.constraint(equalTo: titleTextView.leftAnchor).isActive = true
        
        setUpUserSectionView()
        
        if let _ = post.tags {
            scrollView.addSubview(tagField)
            // Hashtag Field Constraints
            tagField.topAnchor.constraint(equalTo: userContainer.layoutMarginsGuide.bottomAnchor, constant: 30).isActive = true
            tagField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            tagField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 4/5).isActive = true
            tagField.configure()
            tagField.heightAnchor.constraint(equalToConstant: tagField.getHeight()).isActive = true
        }

        scrollView.addSubview(detailsTextView)
        // Details Label Constraints
        detailsTextView.widthAnchor.constraint(equalTo: titleTextView.widthAnchor).isActive = true
        detailsTextView.topAnchor.constraint(equalTo: tagField.layoutMarginsGuide.bottomAnchor, constant: 30).isActive = true
        detailsTextView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        
        if post.userID != uid {
            // Meet Button Constraints
            meetButton.heightAnchor.constraint(equalToConstant: tabBarHeight).isActive = true
            meetButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            meetButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            meetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
        vibrancyEffectView.contentView.addSubview(proposalPopUpView)
        blurEffectView.isHidden = true
        vibrancyEffectView.isHidden = true

        // PopUp View Constraints
        let margins = vibrancyEffectView.layoutMarginsGuide
        proposalPopUpView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        proposalPopUpView.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        proposalPopUpView.widthAnchor.constraint(equalTo: margins.widthAnchor, constant: -50).isActive = true
        proposalPopUpView.heightAnchor.constraint(equalTo: proposalPopUpView.widthAnchor).isActive = true

    }
    
    func setUpUserSectionView() {
        
        scrollView.addSubview(userContainer)
        
        // User Container Constraints
        userContainer.widthAnchor.constraint(equalTo: titleTextView.widthAnchor).isActive = true
        userContainer.topAnchor.constraint(equalTo: placeTextView.bottomAnchor, constant: 40).isActive = true
        userContainer.centerXAnchor.constraint(equalTo: titleTextView.centerXAnchor).isActive = true
        
        let dividerLine = DividerLine()
        dividerLine.setColor(to: .white)
        
        userContainer.addSubview(userImageView)
        userContainer.addSubview(userNameTextView)
        userContainer.addSubview(dividerLine)
        userContainer.addSubview(userDescriptionTextView)
        
        let margins = userContainer.layoutMarginsGuide
        
        // User Image View Constraints
        userImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        userImageView.widthAnchor.constraint(equalTo: userImageView.heightAnchor).isActive = true
        userImageView.centerYAnchor.constraint(equalTo: userContainer.centerYAnchor).isActive = true
        userImageView.leftAnchor.constraint(equalTo: userContainer.leftAnchor, constant: 10).isActive = true
        
        // User Name Label Constraints
        userNameTextView.topAnchor.constraint(equalTo: userContainer.topAnchor, constant: 10).isActive = true
        userNameTextView.centerXAnchor.constraint(equalTo: userContainer.centerXAnchor, constant: 40).isActive = true // IDK why 40... should be 90: 10 (spacing left of image) + 70 (width of image) + 10 (spacing with image)
        userNameTextView.widthAnchor.constraint(lessThanOrEqualTo: userContainer.widthAnchor, constant: -100).isActive = true // 90 from before + 10 of spacing on the right
        
        // Divider Line Constraints
        dividerLine.topAnchor.constraint(equalTo: userNameTextView.bottomAnchor).isActive = true
        dividerLine.centerXAnchor.constraint(equalTo: userNameTextView.centerXAnchor).isActive = true
        dividerLine.widthAnchor.constraint(equalTo: userNameTextView.widthAnchor).isActive = true
        dividerLine.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        
        // User Description Label Constraints
        userDescriptionTextView.topAnchor.constraint(equalTo: userNameTextView.bottomAnchor, constant: 10).isActive = true
        userDescriptionTextView.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 10).isActive = true
        userDescriptionTextView.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        
        // Dynamically set the container's height
        userContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: calculateSizeOfUserContainer()).isActive = true
        
        // If tapped inside, takes you to the user's profile. Not done when the post is from the current user
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        if post.userID != uid {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePushUserProfile))
            userContainer.addGestureRecognizer(tapGesture)
        }
        
    }
    
    fileprivate func calculateSizeOfUserContainer() -> CGFloat {
        view.layoutIfNeeded()
        var sum: CGFloat = 30 // Name label
        sum += userDescriptionTextView.frame.size.height
        
        if sum < 60 { // 80 + padding space (20) = 100
            return 80
        } else {
            return sum+40 // +20 to account for additional padding space on top and bottom
        }
    }
    
    @objc func handlePushUserProfile(sender: UITapGestureRecognizer) {
        let profile = ProfileController()
        profile.user = user
        profile.mainProfile = false
        self.navigationController?.pushViewController(profile, animated: true)
    }
    
    func sendProposal(forPost post: Post, time: String, date: String, place: String) {
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).child("proposals").child(post.id).setValue("Ongoing", withCompletionBlock: { (error, reference) in
            
            if error != nil {
                print(error!)
                return
            }
            
            // We have to push the ChatController from the MessagesController in order to preserve the logical navigation of the app
            self.tabBarController?.selectedIndex = 1
            
            let messagesNavigationController = self.tabBarController?.selectedViewController as! UINavigationController
            let messagesController = messagesNavigationController.topViewController as! MessagesListController
            
            messagesController.sendProposal(to: self.user, post: post, title: post.title, place: place, date: date, time: time)
            
            self.dismissPopUp()

        })
    }
    
    // Checks if the user has an ongoing proposal for this post, if the user is blocked by the posting user, etc.
    fileprivate func checkValidityOfProposal(completion completed: @escaping FinishedDownload) {
       
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if !snapshot.hasChild("proposals") {
                print("\nNo proposals exist for this user\n")
                completed()
                return
            }
            
            let proposals = snapshot.childSnapshot(forPath: "proposals")
            print("\nProposals are: \(proposals)\n")
            if (proposals.hasChild(self.post.id!)) {
                print("\nThere already exists a proposal\n")
                // Alert of the existance of ongoing proposal
                let alert = UIAlertController(title: "You already have an ongoing proposal for this post", message: nil, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
                    // Alert is dismissed
                }
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion:nil)
                return
            } else {
                print("\nNo proposal for this post exists\n")
                completed()
                return
            }
        })
        
        // Something went wrong
        return
    }
    
    @objc func handleMeetSetUp(sender: UIButton) {
        
        checkValidityOfProposal(completion: {
            
            self.proposalPopUpView.addButtonFunctionality()
            
            // Animate PopUp View
            self.proposalPopUpView.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            self.proposalPopUpView.alpha = 0
            UIView.animate(withDuration: 0.4) {
                self.blurEffectView.isHidden = false
                self.vibrancyEffectView.isHidden = false
                self.proposalPopUpView.alpha = 1
                self.proposalPopUpView.transform = CGAffineTransform.identity
            }
            
            self.navigationController?.isNavigationBarHidden = true
            
        })
        
    }
    
    func calculateScrollViewHeight() -> CGFloat {
        view.layoutIfNeeded()
        var sum: CGFloat = 160 // Sum of spacing (130 of spacing between views + 30 bottom spacing)
        sum += titleTextView.frame.size.height
        sum += placeTextView.frame.size.height > (dateLabel.frame.size.height + timeLabel.frame.size.height) ? placeTextView.frame.size.height : (dateLabel.frame.size.height + timeLabel.frame.size.height)
        sum += userContainer.frame.size.height
        sum += tagField.getHeight()
        sum += detailsTextView.frame.size.height
        return sum
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = scrollViewContainer.frame.size.width
        scrollView.contentSize = CGSize(width: width, height: calculateScrollViewHeight())
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch? = touches.first
        if (touch?.view != proposalPopUpView) && (blurEffectView.isHidden == false) {
            dismissPopUp()
        } else if (touch?.view == proposalPopUpView) && (blurEffectView.isHidden == false) {
            self.view.endEditing(true)
        }
    }
    
    func dismissPopUp() {
        UIView.animate(withDuration: 0.3, animations: {
            self.proposalPopUpView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.proposalPopUpView.alpha = 0
        }) { (success: Bool) in
            self.blurEffectView.isHidden = true
            self.vibrancyEffectView.isHidden = true
            self.navigationController?.isNavigationBarHidden = false
            self.view.endEditing(true)
        }
    }
}
