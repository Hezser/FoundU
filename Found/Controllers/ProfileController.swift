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
    
    fileprivate var studiesFields = [ExperienceField]()
    fileprivate var workFields = [ExperienceField]()
    
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
    
    var bioLabel: UILabel = {
        let label = UILabel()
        label.text = "Bio"
        label.textAlignment = .left
        label.textColor = Color.lightOrange
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var startQuotations: UILabel = {
        let label = UILabel()
        label.text = "\u{275D}"
        label.textAlignment = .center
        label.textColor = Color.lightOrange
        label.font = UIFont.italicSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var endQuotations: UILabel = {
        let label = UILabel()
        label.text = "\u{275E}"
        label.textAlignment = .center
        label.textColor = Color.lightOrange
        label.font = UIFont.italicSystemFont(ofSize: 30)
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
    
    var studiesLabel: UILabel = {
        let label = UILabel()
        label.text = "Studies"
        label.textAlignment = .left
        label.textColor = Color.lightOrange
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var workLabel: UILabel = {
        let label = UILabel()
        label.text = "Work"
        label.textAlignment = .left
        label.textColor = Color.lightOrange
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        scrollView.backgroundColor = Color.veryLightOrange
        
        setUserData()

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
        
        for studies in user.studies! {
            if studies != "" {
                let studiesStrings = separateInformation(for: studies)
                let newStudyField = ExperienceField()
                newStudyField.variable = .studies
                newStudyField.situation = .profile
                newStudyField.setWhat(to: studiesStrings[0])
                newStudyField.setWhere(to: studiesStrings[1])
                studiesFields.append(newStudyField)
            }
        }
        
        for work in user.work! {
            if work != "" {
                let workStrings = separateInformation(for: work)
                let newWorkField = ExperienceField()
                newWorkField.variable = .work
                newWorkField.situation = .profile
                newWorkField.setWhat(to: workStrings[0])
                newWorkField.setWhere(to: workStrings[1])
                workFields.append(newWorkField)
            }
        }
        
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
        
        placeLabel.topAnchor.constraint(equalTo: ageLabel.bottomAnchor).isActive = true
        placeLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        placeLabel.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        placeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    func setUpUI() {
        
        let dividerLine1 = DividerLine()
        let dividerLine2 = DividerLine()
        let dividerLine3 = DividerLine()
        let dividerLine4 = DividerLine()
        
        view.addSubview(scrollView)
        scrollView.addSubview(basicInformationContainer)
        scrollView.addSubview(dividerLine1)
        scrollView.addSubview(bioLabel)
        scrollView.addSubview(startQuotations)
        scrollView.addSubview(endQuotations)
        scrollView.addSubview(bioTextView)
        scrollView.addSubview(dividerLine2)
        scrollView.addSubview(studiesLabel)
        for studies in studiesFields {
            scrollView.addSubview(studies)
        }
        scrollView.addSubview(dividerLine3)
        scrollView.addSubview(workLabel)
        for work in workFields {
            scrollView.addSubview(work)
        }
        scrollView.addSubview(dividerLine4)
        
        // In case there are no studies or/and work fields to display
        studiesLabel.isHidden = true
        dividerLine3.isHidden = true
        workLabel.isHidden = true
        dividerLine4.isHidden = true
    
        let margins = scrollView.layoutMarginsGuide
        
        setUpBasicInformationContainer()
        
        basicInformationContainer.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        basicInformationContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        basicInformationContainer.heightAnchor.constraint(equalToConstant: calculateBasicInformationContainerHeight()).isActive = true
        
        dividerLine1.topAnchor.constraint(equalTo: basicInformationContainer.bottomAnchor).isActive = true
        dividerLine1.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        dividerLine1.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        dividerLine1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        bioLabel.topAnchor.constraint(equalTo: dividerLine1.bottomAnchor).isActive = true
        bioLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 5).isActive = true
        bioLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        bioLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        bioTextView.topAnchor.constraint(equalTo: dividerLine1.bottomAnchor, constant: 30).isActive = true
        bioTextView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        bioTextView.widthAnchor.constraint(lessThanOrEqualTo: margins.widthAnchor, multiplier: 3/5).isActive = true
        
        startQuotations.topAnchor.constraint(equalTo: bioTextView.topAnchor).isActive = true
        startQuotations.rightAnchor.constraint(equalTo: bioTextView.leftAnchor).isActive = true
        startQuotations.heightAnchor.constraint(equalToConstant: 20).isActive = true
        startQuotations.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        endQuotations.bottomAnchor.constraint(equalTo: bioTextView.bottomAnchor).isActive = true
        endQuotations.leftAnchor.constraint(equalTo: bioTextView.rightAnchor).isActive = true
        endQuotations.heightAnchor.constraint(equalToConstant: 20).isActive = true
        endQuotations.widthAnchor.constraint(equalToConstant: 30).isActive = true

        dividerLine2.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 10).isActive = true
        dividerLine2.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        dividerLine2.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        dividerLine2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        var lastDividerLine: DividerLine = dividerLine2
        var lastView: UIView = lastDividerLine
        
        if !studiesFields.isUseless() {
            
            studiesLabel.isHidden = false
            dividerLine3.isHidden = false
            
            studiesLabel.topAnchor.constraint(equalTo: dividerLine2.bottomAnchor).isActive = true
            studiesLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 5).isActive = true
            studiesLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
            studiesLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            for studies in studiesFields {
                
                let bulletPoint = BulletPoint()
                scrollView.addSubview(bulletPoint)
                bulletPoint.color = Color.lightOrange
                bulletPoint.size = 100
                if lastView == lastDividerLine {
                    bulletPoint.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 30).isActive = true
                } else {
                    bulletPoint.topAnchor.constraint(equalTo: lastView.bottomAnchor).isActive = true
                }
                bulletPoint.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 5).isActive = true
                bulletPoint.heightAnchor.constraint(equalToConstant: 40).isActive = true
                bulletPoint.widthAnchor.constraint(equalToConstant: 10).isActive = true
                
                studies.topAnchor.constraint(equalTo: bulletPoint.topAnchor).isActive = true
                studies.leftAnchor.constraint(equalTo: bulletPoint.rightAnchor, constant: 5).isActive = true
                studies.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -20).isActive = true
                studies.heightAnchor.constraint(equalToConstant: 70).isActive = true
                lastView = studies
                
            }
            
            dividerLine3.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 10).isActive = true
            dividerLine3.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            dividerLine3.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            dividerLine3.heightAnchor.constraint(equalToConstant: 1).isActive = true
            lastDividerLine = dividerLine3
            lastView = lastDividerLine
            
        }
        
        if !workFields.isUseless() {
            
            workLabel.isHidden = false
            dividerLine4.isHidden = false
            
            workLabel.topAnchor.constraint(equalTo: lastView.bottomAnchor).isActive = true
            workLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 5).isActive = true
            workLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
            workLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            for work in workFields {
                
                let bulletPoint = BulletPoint()
                scrollView.addSubview(bulletPoint)
                bulletPoint.color = Color.lightOrange
                bulletPoint.size = 40
                if lastView == lastDividerLine {
                    bulletPoint.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 30).isActive = true
                } else {
                    bulletPoint.topAnchor.constraint(equalTo: lastView.bottomAnchor).isActive = true
                }
                bulletPoint.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 5).isActive = true
                bulletPoint.heightAnchor.constraint(equalToConstant: 40).isActive = true
                bulletPoint.widthAnchor.constraint(equalToConstant: 10).isActive = true
                
                work.topAnchor.constraint(equalTo: bulletPoint.topAnchor).isActive = true
                work.leftAnchor.constraint(equalTo: bulletPoint.rightAnchor, constant: 5).isActive = true
                work.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -20).isActive = true
                work.heightAnchor.constraint(equalToConstant: 70).isActive = true
                lastView = work
                
            }
            
            dividerLine4.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 10).isActive = true
            dividerLine4.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            dividerLine4.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            dividerLine4.heightAnchor.constraint(equalToConstant: 1).isActive = true
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
    
    func calculateBasicInformationContainerHeight() -> CGFloat {
        view.layoutIfNeeded()
        var sum: CGFloat = 60 // Sum of both top and bottom spacing + spacing between views
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
//        scrollView.contentSize = CGSize(width: screenWidth, height: calculateScrollViewHeight())
        scrollView.contentSize = CGSize(width: screenWidth, height: 2000)
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
