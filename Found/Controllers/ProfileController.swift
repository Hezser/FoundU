//
//  ProfileController.swift
//  Found
//
//  Created by Sergio Hernandez on 27/09/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class ProfileController: UIViewController {
    
    var user: User!
    var mainProfile: Bool! // Tells if the profile is the user's one (main, as part of the menu), or a profile of some other user
    
    var scrollView: UIScrollView = {
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        let view = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = true
        return view
    }()
    
    // Containing pictureView, nameLabel, ageLabel and placeLabel
    var basicInformationContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var pictureView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var ageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var placeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var bioTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        scrollView.backgroundColor = Color.veryLightOrange

        setUpUI()
        
        if mainProfile {
            let logOutButton = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(handleLogOut))
            navigationItem.rightBarButtonItem = logOutButton
            let editButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(handleEdit))
            navigationItem.leftBarButtonItem = editButton
        }
        
        view.layoutIfNeeded()
        pictureView.setRounded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setUserData()
        
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if !mainProfile {
            title = user.name
            tabBarController?.tabBar.isHidden = true
        }
    }
    
    func setUserData() {
        
        nameLabel.text = user.name
        ageLabel.text = String(describing: user.age!) + " years old"
        placeLabel.text = "From " + user.place!
        bioTextView.text = user.bio!
        bioTextView.font = placeLabel.font
        
        let url = URL(string: user.profileImageURL!)
        let data = try? Data(contentsOf: url!)
        pictureView.image = UIImage(data: data!)
        
    }
    
    func transformURLIntoImage(urlString: String) {
        
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
    
    func setUpBasicInformationContainer() {
        
        basicInformationContainer.addSubview(pictureView)
        basicInformationContainer.addSubview(nameLabel)
        basicInformationContainer.addSubview(ageLabel)
        basicInformationContainer.addSubview(placeLabel)
        
        let margins = basicInformationContainer.layoutMarginsGuide
        
        pictureView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20).isActive = true
        pictureView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        pictureView.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 1/3).isActive = true
        pictureView.heightAnchor.constraint(equalTo: pictureView.widthAnchor).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: pictureView.bottomAnchor, constant: 10).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        ageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        ageLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        ageLabel.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        ageLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        placeLabel.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 10).isActive = true
        placeLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        placeLabel.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        placeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    func setUpUI() {
        
        let dividerLine1 = DividerLine()
        let dividerLine2 = DividerLine()
        
        view.addSubview(scrollView)
        scrollView.addSubview(basicInformationContainer)
        scrollView.addSubview(dividerLine1)
        scrollView.addSubview(bioTextView)
        scrollView.addSubview(dividerLine2)
    
        let margins = scrollView.layoutMarginsGuide
        
        setUpBasicInformationContainer()
        
        basicInformationContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        basicInformationContainer.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        basicInformationContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        basicInformationContainer.heightAnchor.constraint(equalToConstant: calculateBasicInformationContainerHeight()).isActive = true
        
        dividerLine1.topAnchor.constraint(equalTo: basicInformationContainer.bottomAnchor).isActive = true
        dividerLine1.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        dividerLine1.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        dividerLine1.heightAnchor.constraint(equalToConstant: 1).isActive = true

        bioTextView.topAnchor.constraint(equalTo: dividerLine1.bottomAnchor, constant: 10).isActive = true
        bioTextView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        bioTextView.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 3/5).isActive = true

        dividerLine2.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 10).isActive = true
        dividerLine2.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        dividerLine2.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        dividerLine2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func calculateBasicInformationContainerHeight() -> CGFloat {
        view.layoutIfNeeded()
        var sum: CGFloat = 70 // Sum of both top and bottom spacing + spacing between views
        sum += pictureView.frame.size.height
        sum += nameLabel.frame.size.height
        sum += ageLabel.frame.size.height
        sum += placeLabel.frame.size.height
        return sum
    }
    
    func calculateScrollViewHeight() -> CGFloat {
        view.layoutIfNeeded()
        var sum: CGFloat = 43 // Sum of blank vertical distance between views + width of divider lines
        sum += basicInformationContainer.frame.size.height
        sum += bioTextView.frame.size.height
        return sum
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        scrollView.contentSize = CGSize(width: screenWidth, height: calculateScrollViewHeight())
    }
    
    @objc func handleLogOut(_ sender: UIButton) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    @objc func handleEdit(_ sender: UIButton) {
        let editProfileController = EditProfileController()
        editProfileController.user = user
        navigationController?.pushViewController(editProfileController, animated: true)
    }
    
}
