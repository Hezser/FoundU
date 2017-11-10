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
    
    // Tells if the profile is the user's one (main, as part of the menu), or a profile of some other user
    var mainProfile: Bool!
    
    var nameLabel: UILabel!
    var ageLabel: UILabel!
    var placeLabel: UILabel!
    var shortDescriptionLabel: UILabel!
    var longDescriptionLabel: UILabel!
    var picture: UIImageView!
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        // Creates UI fields were the profile data will be displayed (need to migrate all the text field storyboard connections to programmatic code in this function)
        makeUIViews()
        
        // If this is the main profile, create a logout button
        if mainProfile {
            let logOutButton = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(handleLogOut))
            navigationItem.rightBarButtonItem = logOutButton
        }
        
        // Set info
        setUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if mainProfile {
            title = "You"
//            navigationController?.isNavigationBarHidden = true
        } else {
            title = user.name
//            navigationController?.isNavigationBarHidden = false
        }
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
//    func makeLogoutButton() {
//
//        let logoutButton = UIButton()
//        logoutButton.backgroundColor = #colorLiteral(red: 0.9331143498, green: 0.134441793, blue: 0, alpha: 1)
//        logoutButton.setTitle("Log Out", for: .normal)
//        logoutButton.layer.cornerRadius = 5
//        logoutButton.clipsToBounds = true
//        logoutButton.translatesAutoresizingMaskIntoConstraints = false
//        logoutButton.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
//
//        view.addSubview(logoutButton)
//
//        let margins = view.layoutMarginsGuide
//
//        logoutButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
//        logoutButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        logoutButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 10).isActive = true
//        logoutButton.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
//    }
    
    func setUserData() {
        
        print("\nUser is: \(user)\n")
        nameLabel.text = user.name
        ageLabel.text = String(describing: user.age!) + " years old"
        placeLabel.text = "From " + user.place!
        shortDescriptionLabel.text = user.shortDescription
        longDescriptionLabel.text = user.longDescription
        
        let url = URL(string: user.profileImageURL!)
        let data = try? Data(contentsOf: url!)
        picture.image = UIImage(data: data!)
        
    }
    
    func transformURLIntoImage(urlString: String) {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.picture.image = UIImage(data: data!)
            }
            
        }).resume()
    }
    
    func makeUIViews() {
        // Image View for the profile picture
        picture = UIImageView()
        picture.contentMode = .scaleAspectFill
        picture.layer.cornerRadius = 10
        picture.clipsToBounds = true
        picture.translatesAutoresizingMaskIntoConstraints = false
        
        // Labels
        nameLabel = UILabel()
        ageLabel = UILabel()
        placeLabel = UILabel()
        shortDescriptionLabel = UILabel()
        longDescriptionLabel = UILabel()
        
        shortDescriptionLabel.lineBreakMode = .byWordWrapping
        shortDescriptionLabel.numberOfLines = 0
        shortDescriptionLabel.textAlignment = .center
        longDescriptionLabel.lineBreakMode = .byWordWrapping
        longDescriptionLabel.numberOfLines = 0
        
        nameLabel.backgroundColor = .white
        ageLabel.backgroundColor = .white
        placeLabel.backgroundColor = .white
        shortDescriptionLabel.backgroundColor = .white
        longDescriptionLabel.backgroundColor = .white
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        shortDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        longDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(picture)
        view.addSubview(nameLabel)
        view.addSubview(ageLabel)
        view.addSubview(placeLabel)
        view.addSubview(shortDescriptionLabel)
        view.addSubview(longDescriptionLabel)
        
        makeUIConstraints()
        
    }
    
    func makeUIConstraints() {
        
        let margins = view.layoutMarginsGuide
        
        // Picture
        picture.topAnchor.constraint(equalTo: margins.topAnchor, constant: 50).isActive = true
        picture.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        picture.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 1/3).isActive = true
        picture.heightAnchor.constraint(equalTo: picture.widthAnchor).isActive = true
        
        // Name Label
        nameLabel.topAnchor.constraint(equalTo: picture.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: picture.rightAnchor, constant: 20).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: 10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Age Label
        ageLabel.centerYAnchor.constraint(equalTo: picture.centerYAnchor).isActive = true
        ageLabel.leftAnchor.constraint(equalTo: picture.rightAnchor, constant: 20).isActive = true
        ageLabel.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: 10).isActive = true
        ageLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Place Label
        placeLabel.bottomAnchor.constraint(equalTo: picture.bottomAnchor).isActive = true
        placeLabel.leftAnchor.constraint(equalTo: picture.rightAnchor, constant: 20).isActive = true
        placeLabel.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: 10).isActive = true
        placeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Short Description
        shortDescriptionLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        shortDescriptionLabel.topAnchor.constraint(equalTo: picture.bottomAnchor, constant: 30).isActive = true
        shortDescriptionLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, constant: -20).isActive = true
        shortDescriptionLabel.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        // Long Description
        longDescriptionLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        longDescriptionLabel.topAnchor.constraint(equalTo: shortDescriptionLabel.bottomAnchor, constant: 30).isActive = true
        longDescriptionLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, constant: -20).isActive = true
        longDescriptionLabel.heightAnchor.constraint(equalToConstant: 240).isActive = true
        
        
    }
    
    @objc func handleLogOut() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
}
