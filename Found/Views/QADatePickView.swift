//
//  QAPickView.swift
//  Found
//
//  Created by Sergio Hernandez on 21/09/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit

class QADatePickView: QAView {
    
    var datePicker: UIDatePicker!

    override func nextPressed(sender: UIButton!) {
        let age = datePicker.date.age
        let ageString = String(age)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM, yyyy"
        let dateOfBirth = dateFormatter.string(from: datePicker.date)
        if situation == .profileCreation {
            writeProfileInfoToFirebaseDatabase(data: ageString, completion: {
                self.variable = .dateOfBirth
                self.writeProfileInfoToFirebaseDatabase(data: dateOfBirth, completion: nil)
            })
        }
        else if situation == .postCreation {
            addDataToPost(value: datePicker.date, type: variable!)
        }
        goToNextView()
    }
    
    @objc func iAmFlexiblePressed(_ sender: UIButton) {
        addDataToPost(value: nil, type: variable!)
        goToNextView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let margins = view.layoutMarginsGuide
        
        // Create Date Picker
        datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        // If the wanted input is date of birth, we only display day, month and year
        if variable == .age {
            datePicker.datePickerMode = .date
        } else if variable == .time {
            datePicker.datePickerMode = .dateAndTime
        }
        
        view.addSubview(datePicker)
        
        datePicker.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        datePicker.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        datePicker.widthAnchor.constraint(equalTo: margins.widthAnchor, constant: -50).isActive = true
        datePicker.heightAnchor.constraint(equalTo: datePicker.widthAnchor, multiplier: 3/4).isActive = true
        
        if situation == .postCreation {
            
            datePicker.minuteInterval = 15
            
            // Create iAmFlexibleButton
            let iAmFlexibleButton = UIButton()
            iAmFlexibleButton.addTarget(self, action: #selector(iAmFlexiblePressed), for: .touchUpInside)
            iAmFlexibleButton.backgroundColor = #colorLiteral(red: 1, green: 0.6470588446, blue: 0.3098038733, alpha: 1)
            iAmFlexibleButton.layer.cornerRadius = 5
            iAmFlexibleButton.translatesAutoresizingMaskIntoConstraints = false
            iAmFlexibleButton.setTitle("I am flexible", for: .normal)
            
            view.addSubview(iAmFlexibleButton)
           
            iAmFlexibleButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: -30).isActive = true
            iAmFlexibleButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
            iAmFlexibleButton.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 1/3).isActive = true
            iAmFlexibleButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
