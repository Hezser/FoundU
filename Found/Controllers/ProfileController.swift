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
    
    var pictureView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var ageLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var placeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var shortDescriptionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var longDescriptionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(pictureView)
        view.addSubview(nameLabel)
        view.addSubview(ageLabel)
        view.addSubview(placeLabel)
        view.addSubview(shortDescriptionLabel)
        view.addSubview(longDescriptionLabel)
        
        makeUIConstraints()
        
        if mainProfile {
            let logOutButton = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(handleLogOut))
            navigationItem.rightBarButtonItem = logOutButton
            let editButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(handleEdit))
            navigationItem.leftBarButtonItem = editButton
        }
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
        
        print("\nUser is: \(user)\n")
        nameLabel.text = user.name
        ageLabel.text = String(describing: user.age!) + " years old"
        placeLabel.text = "From " + user.place!
        shortDescriptionLabel.text = user.shortDescription
        longDescriptionLabel.text = user.longDescription
        
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
    
    func makeUIConstraints() {
        
        let margins = view.layoutMarginsGuide
        
        // Picture
        pictureView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 50).isActive = true
        pictureView.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        pictureView.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 1/3).isActive = true
        pictureView.heightAnchor.constraint(equalTo: pictureView.widthAnchor).isActive = true
        
        // Name Label
        nameLabel.topAnchor.constraint(equalTo: pictureView.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: pictureView.rightAnchor, constant: 20).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: 10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Age Label
        ageLabel.centerYAnchor.constraint(equalTo: pictureView.centerYAnchor).isActive = true
        ageLabel.leftAnchor.constraint(equalTo: pictureView.rightAnchor, constant: 20).isActive = true
        ageLabel.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: 10).isActive = true
        ageLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Place Label
        placeLabel.bottomAnchor.constraint(equalTo: pictureView.bottomAnchor).isActive = true
        placeLabel.leftAnchor.constraint(equalTo: pictureView.rightAnchor, constant: 20).isActive = true
        placeLabel.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: 10).isActive = true
        placeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Short Description
        shortDescriptionLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        shortDescriptionLabel.topAnchor.constraint(equalTo: pictureView.bottomAnchor, constant: 30).isActive = true
        shortDescriptionLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, constant: -20).isActive = true
        shortDescriptionLabel.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        // Long Description
        longDescriptionLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        longDescriptionLabel.topAnchor.constraint(equalTo: shortDescriptionLabel.bottomAnchor, constant: 30).isActive = true
        longDescriptionLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, constant: -20).isActive = true
        longDescriptionLabel.heightAnchor.constraint(equalToConstant: 240).isActive = true
        
        
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
