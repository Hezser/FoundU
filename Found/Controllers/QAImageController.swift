//
//  QAImageView.swift
//  Found
//
//  Created by Sergio Hernandez on 04/10/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import Photos

class QAImageController: QAController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var picture: UIImageView!
    var pictureURL: String!
    private var imageWasSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create Image View
        picture = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        picture.center = view.center
        picture.backgroundColor = .gray
        picture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleChangeOfPicture)))
        picture.isUserInteractionEnabled = true
        view.addSubview(picture)
    }
    
    @objc func handleChangeOfPicture() {
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
            picture.image = selectedImage
            imageWasSelected = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    override func nextPressed(sender: UIButton!) {
        if imageWasSelected {
            uploadPictureToFirebaseStorage(picture: self.picture.image!, completion: {
                self.addDataToProfile(data: self.pictureURL)
                self.goToNextView()
            })
        } else {
            let alert = UIAlertController(title: "No picture selected", message: "Please, select a picture to continue.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
                // Alert is dismissed
            }
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion:nil)
        }
    }
    
    func uploadPictureToFirebaseStorage(picture: UIImage?, completion completed: @escaping FinishedDownload) {
        
        let imageName = UUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
        
        // To change the quality of picture after compression change 0.1 for a value closer to 1
        if let profileImage = picture, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    self.pictureURL = profileImageUrl
                    completed()
                }
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Change of picture was canceled")
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
