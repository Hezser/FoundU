//
//  ChatLogController.swift
//  FoundU
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation

class ChatController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ProposalPopUpController {
    
    var proposalPopUpView: ProposalPopUpView!
    var user: User! // User who owns the post, also partner in conversation
    var post: Post! // Different proposals may represent different posts, so this variable is updated right before an action which requires the post (such as presenting the PopUpView) with the post of the proposal currently being used. This variable is kind of a wildcard: it represents different posts at different times as it is convenient
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    var messages = [Message]()
    
    let messageCellID = "messageCellID"
    let proposalCellID = "proposalCellID"
    
    typealias FinishedDownload = () -> ()
    
    var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.isHidden = true
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return effectView
    }()
    
    var vibrancyEffectView: UIVisualEffectView = {
        let vibrancyEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .dark))
        let effectView = UIVisualEffectView(effect: vibrancyEffect)
        effectView.isHidden = true
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return effectView
    }()
    
    lazy var inputContainerView: ChatInputContainerView = {
        let chatInputContainerView = ChatInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        chatInputContainerView.chatController = self
        return chatInputContainerView
    }()
    
    func observeMessages() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid, let toId = user?.id else {
            return
        }
        let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(uid).child(toId)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageID = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("messages").child(messageID)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                self.messages.append(Message(withID: messageID, snapshot: snapshot))
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                    //scroll to the last index
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                })
            })
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = Color.veryLightOrange
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: messageCellID)
        collectionView?.register(ProposalCell.self, forCellWithReuseIdentifier: proposalCellID)
        
        collectionView?.keyboardDismissMode = .interactive
        
        observeMessages()
        
        setupKeyboardObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: view.frame.width , height: 64)
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
    
    func setPost(forProposal proposal: Message, completion completed: @escaping FinishedDownload) {
        print("id = \(proposal.postID!)")
        
        FIRDatabase.database().reference().child("posts").child(proposal.postID!).observeSingleEvent(of: .value, with: { (snapshot) in
        
            if snapshot.value as? [String : String] == nil {
                // The post has been removed. Notify the user about this.
                print("\nThe post you are trying to access (id = \(proposal.postID!)) has been removed from the database\n")
                // Alert of the inexistance of the post
                let alert = UIAlertController(title: "This post no longer exists", message: nil, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
                    // Alert is dismissed
                }
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion:nil)
                return
            }
            
            self.post = Post(snapshot)
            completed()
            
        })
    }
    
    func presentPopUp(forCell proposalCell: ProposalCell) {
        
        // Hide inputContainerView
        inputContainerView.isHidden = true
        
        // Set up popup
        proposalPopUpView = ProposalPopUpView()
        proposalPopUpView.proposalPopUpController = self
        proposalPopUpView.proposalCell = proposalCell
        setUpBlurAndVibrancy()
        proposalPopUpView.addButtonFunctionality()
        proposalPopUpView.configurePopUp()
        
        // Animate PopUp View
        proposalPopUpView.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        proposalPopUpView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.blurEffectView.isHidden = false
            self.vibrancyEffectView.isHidden = false
            self.proposalPopUpView.alpha = 1
            self.proposalPopUpView.transform = CGAffineTransform.identity
        }
        
        navigationController?.isNavigationBarHidden = true
    }
    
    func dismissPopUp() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.proposalPopUpView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.proposalPopUpView.alpha = 0
        }) { (success: Bool) in
            self.blurEffectView.isHidden = true
            self.vibrancyEffectView.isHidden = true
            self.navigationController?.isNavigationBarHidden = false
            self.inputContainerView.isHidden = false
            self.view.endEditing(true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch? = touches.first
        if (touch?.view != proposalPopUpView) && (blurEffectView.isHidden == false) {
            print("\n\(blurEffectView.isHidden)\n")
            dismissPopUp()
        } else if (touch?.view == proposalPopUpView) && (blurEffectView.isHidden == false) {
            self.view.endEditing(true)
        }
    }
    
    func sendProposal(forPost post: Post, time: String, date: String, place: String) {
        
        let properties: [String:AnyObject] = [ "postID" : post.id as AnyObject, "decision" : "" as AnyObject, "title" : post.title as AnyObject, "place" : place as AnyObject, "time" : time as AnyObject, "date" : date as AnyObject ]
        sendMessageWithProperties(properties)
        
    }
    
    func deleteConversationByDeclining() {
        
        // Present the alert to confirm
        let alert = UIAlertController(title: "Delete Conversation", message: "When you decline a proposal, the conversation is deleted. Do you still want to decline?", preferredStyle: .alert)
        let clearAction = UIAlertAction(title: "Yes", style: .destructive) { (alert: UIAlertAction!) -> Void in
            self.deleteConversation()
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { (alert: UIAlertAction!) -> Void in
            // Nothing is done
        }
        
        alert.addAction(clearAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion:nil)
    }
    
    func deleteConversation() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        if let chatPartnerID = messages[0].chatPartnerID() {
            
            // Remove user-messages part of the current user
            FIRDatabase.database().reference().child("user-messages").child(uid).child(chatPartnerID).removeValue(completionBlock: { (error, ref) in
                
                if error != nil {
                    print("Failed to delete message:", error!)
                    return
                }
                
                self.navigationController?.popViewController(animated: true)
            })
            
            // Remove user-messages part of the partner user
            FIRDatabase.database().reference().child("user-messages").child(chatPartnerID).child(uid).removeValue(completionBlock: { (error, ref) in
                
                if error != nil {
                    print("Failed to delete message:", error!)
                    return
                }
            })
            
            // Remove each message involving both users
            FIRDatabase.database().reference().child("messages").observeSingleEvent(of: .value, with: { (snapshot) in
                if let messages = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for message in messages {
                        let fromID = message.childSnapshot(forPath: "fromId").value as! String
                        let toID = message.childSnapshot(forPath: "toId").value as! String
                        if (fromID == uid && toID == chatPartnerID) || (fromID == chatPartnerID && toID == uid) {
                            FIRDatabase.database().reference().child("messages").child(message.key).removeValue()
                        }
                    }
                }
            })
        }
    }
    
    @objc func handleUploadTap() {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
            //we selected a video
            handleVideoSelectedForUrl(videoUrl)
        } else {
            //we selected an image
            handleImageSelectedForInfo(info as [String : AnyObject])
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func handleVideoSelectedForUrl(_ url: URL) {
        
        let filename = UUID().uuidString + ".mov"
        let uploadTask = FIRStorage.storage().reference().child("message_movies").child(filename).putFile(url, metadata: nil, completion: { (metadata, error) in
            
            if error != nil {
                print("Failed upload of video:", error!)
                return
            }
            
            if let videoUrl = metadata?.downloadURL()?.absoluteString {
                if let thumbnailImage = self.thumbnailImageForFileUrl(url) {
                    
                    self.uploadToFirebaseStorageUsingImage(thumbnailImage, completion: { (imageUrl) in
                        let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": thumbnailImage.size.width as AnyObject, "imageHeight": thumbnailImage.size.height as AnyObject, "videoUrl": videoUrl as AnyObject]
                        self.sendMessageWithProperties(properties)
                        
                    })
                }
            }
        })
        
        uploadTask.observe(.progress) { (snapshot) in
            if let completedUnitCount = snapshot.progress?.completedUnitCount {
                self.navigationItem.title = String(completedUnitCount)
            }
        }
        
        uploadTask.observe(.success) { (snapshot) in
            self.navigationItem.title = self.user?.name
        }
    }
    
    fileprivate func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage? {
        
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
        
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
            
        } catch let err {
            print(err)
        }
        
        return nil
    }
    
    fileprivate func handleImageSelectedForInfo(_ info: [String: AnyObject]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorageUsingImage(selectedImage, completion: { (imageUrl) in
                self.sendMessageWithImageUrl(imageUrl, image: selectedImage)
            })
        }
    }
    
    fileprivate func uploadToFirebaseStorageUsingImage(_ image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
        
        let imageName = UUID().uuidString
        let ref = FIRStorage.storage().reference().child("message_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            ref.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print("Failed to upload image:", error!)
                    return
                }
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    completion(imageUrl)
                }
                
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    func setupKeyboardObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
    @objc func handleKeyboardDidShow() {
        
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!, animations: { 
            self.view.layoutIfNeeded()
        }) 
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        }) 
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: messageCellID, for: indexPath) as! ChatMessageCell
        cell.chatController = self
        let message = messages[indexPath.item]
        cell.message = message
        cell.textView.text = message.text
        cell.bubbleWidthAnchor?.constant = calculateWidth(of: message)
        
        setupMessageCell(cell, message: message)
        
        // Image or video
        if message.imageURL != nil {
            cell.textView.isHidden = true
        }
        
        // Proposal
        else if message.date != nil {
            let proposalCell = collectionView.dequeueReusableCell(withReuseIdentifier: proposalCellID, for: indexPath) as! ProposalCell
            proposalCell.message = message
            proposalCell.chatController = self
            proposalCell.configure()
            proposalCell.acceptButton.tag = indexPath.row
            proposalCell.counterButton.tag = indexPath.row
            proposalCell.declineButton.tag = indexPath.row
            return proposalCell
        }
        
        // Text message
        else {
            cell.textView.isHidden = false
        }
        
        cell.playButton.isHidden = message.videoURL == nil
        
        return cell
    }
    
    func calculateWidth(of message: Message) -> CGFloat {
        
        // Text message
        if let text = message.text {
            return estimateFrameForText(text).width + 32
        }
        
        // Image
        else if message.imageURL != nil {
            return 200
        }
        
        return 200
    }
    
    fileprivate func setupMessageCell(_ cell: ChatMessageCell, message: Message) {
        
        if let profileImageUrl = self.user?.profileImageURL {
            cell.profileImageView.loadImageUsingCacheWithURLString(profileImageUrl)
        }
        
        if message.fromID == FIRAuth.auth()?.currentUser?.uid {
            // Outgoing blue
            cell.bubbleView.backgroundColor = Color.lightOrange
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = true
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            
        } else {
            // Incoming gray
            cell.bubbleView.backgroundColor = .lightGray
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        
        if let messageImageUrl = message.imageURL {
            cell.messageImageView.loadImageUsingCacheWithURLString(messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        } else {
            cell.messageImageView.isHidden = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        var height: CGFloat = 80
        
        let message = messages[indexPath.item]
        if let text = message.text {
            height = estimateFrameForText(text).height + 20
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            
            // h1 / w1 = h2 / w2
            // solve for h1
            // h1 = h2 / w2 * w1
            
            height = CGFloat(imageHeight / imageWidth * 200)
            
        } else if let date = message.date, let title = message.title, let place = message.place {
            height = estimateFrameForText(date).height + estimateFrameForText(title).height + estimateFrameForText(place).height + 20
            if message.decision == "" && message.toID == uid {
                height += 40 // Account for the buttons
            }
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    @objc func handleSend() {
        if textIsValid(inputContainerView.inputTextField.text!) {
            let properties = ["text": inputContainerView.inputTextField.text!]
            sendMessageWithProperties(properties as [String : AnyObject])
        }
    }
    
    func textIsValid(_ text: String) -> Bool {
        for char in text {
            if char != " " {
                return true
            }
        }
        return false
    }
    
    fileprivate func sendMessageWithImageUrl(_ imageUrl: String, image: UIImage) {
        let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": image.size.width as AnyObject, "imageHeight": image.size.height as AnyObject]
        sendMessageWithProperties(properties)
    }
    
    fileprivate func sendMessageWithProperties(_ properties: [String: AnyObject]) {
        
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        
        var values: [String: AnyObject] = ["toId": toId as AnyObject, "fromId": fromId as AnyObject, "timestamp": timestamp as AnyObject]
        
        //append properties dictionary onto values
        //key $0, value $1
        properties.forEach({values[$0] = $1})
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            self.inputContainerView.inputTextField.text = nil
            
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId).child(toId)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toId).child(fromId)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
        }
    }
    
    func performZoomInForStartingImageView(_ startingImageView: UIImageView) {
        
        inputContainerView.hideKeyboard()
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackBackgroundView?.alpha = 1
                self.inputContainerView.alpha = 0
                
                // math?
                // h2 / w1 = h1 / w1
                // h2 = h1 / w1 * w1
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                zoomingImageView.center = keyWindow.center
                
                }, completion: { (completed) in
                   // 
            })
            
        }
    }
    
    @objc func handleZoomOut(_ tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            //need to animate back out to controller
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
                
                }, completion: { (completed) in
                    zoomOutImageView.removeFromSuperview()
                    self.startingImageView?.isHidden = false
            })
        }
    }
}













