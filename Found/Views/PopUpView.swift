//
//  PopUpView.swift
//  Found
//
//  Created by Sergio Hernandez on 15/11/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit

class PopUpView: UIView, UITextFieldDelegate {
    
    var popUpController: PopUpController!
    var proposalCell: ProposalCell?
    
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
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(26)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.6470588446, blue: 0.3098038733, alpha: 1)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(26)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.6470588446, blue: 0.3098038733, alpha: 1)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    @objc func handleSendProposal(_ sender: UIButton) {
        
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
        
        // If proposalCell != nil it would mean we are in a popUpController = ChatController, never on a PostController
        if proposalCell != nil {
            proposalCell?.counteringSuccessful()
        }
        
        popUpController.sendProposal(forPost: popUpController.post, time: time, date: date, place: place)

    }
    
    @objc func handleCancelProposal(_ sender: UIButton) {
        sendButton.removeTarget(nil, action: nil, for: .allEvents)
        cancelButton.removeTarget(nil, action: nil, for: .allEvents)
        popUpController.dismissPopUp()
    }
    
    func configurePopUp() {
        
        layoutIfNeeded()
        
        addSubview(datePicker)
        addSubview(placeTextField)
        addSubview(sendButton)
        addSubview(cancelButton)
        
        let margins = layoutMarginsGuide
        
        // Date Picker Constraints & Date Settings
        datePicker.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        datePicker.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        datePicker.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalTo: datePicker.widthAnchor, multiplier: 1/2).isActive = true
        
        if popUpController.post.time != "Anytime" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE dd LLLL, HH:mm"
            datePicker.date = dateFormatter.date(from: popUpController.post.time)!
        }
        
        // Place Text Field Constraints & Settings
        placeTextField.bottomAnchor.constraint(equalTo: datePicker.topAnchor, constant: -5).isActive = true
        placeTextField.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        placeTextField.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        placeTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        placeTextField.placeholder = popUpController.post.place
        placeTextField.delegate = self
        
        // Send Button Constraints
        sendButton.centerXAnchor.constraint(equalTo: margins.rightAnchor, constant: -((frame.size.width)/4)).isActive = true
        sendButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 5).isActive = true
        sendButton.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 1/3).isActive = true
        sendButton.heightAnchor.constraint(equalTo: sendButton.widthAnchor, multiplier: 1/1.618034).isActive = true
        
        // Cancel Button Constraints
        cancelButton.centerXAnchor.constraint(equalTo: margins.leftAnchor, constant: (frame.size.width)/4).isActive = true
        cancelButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 5).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 1/3).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: sendButton.widthAnchor, multiplier: 1/1.618034).isActive = true

    }
    
    func addButtonFunctionality() {
        sendButton.addTarget(self, action: #selector(handleSendProposal), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(handleCancelProposal), for: .touchUpInside)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .lightGray
        layer.cornerRadius = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
