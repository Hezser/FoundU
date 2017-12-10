//
//  UserCell.swift
//  FoundU
//

import UIKit
import Firebase

class ConversationCell: UITableViewCell {
    
    var user: User! // User who sends the message. Initialized only when convenient
    var message: Message!
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setUpContent() {
        
        if let text = message?.text {
            detailTextLabel?.text = text
        } else if message?.postID != nil {
            guard let uid = FIRAuth.auth()?.currentUser?.uid else {
                return
            }
            if uid == message?.fromID {
                self.detailTextLabel?.text = "You made a proposal!"
            } else {
                user = User(id: (message?.fromID)!, completion: {
                    self.detailTextLabel?.text = (self.user.firstName() + " made a proposal!")
                })
            }
        }
        
        if let seconds = message?.timestamp?.doubleValue {
            let timestampDate = Date(timeIntervalSince1970: seconds)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            timeLabel.text = dateFormatter.string(from: timestampDate)
        }
        
        textLabel?.text = message.userName
        profileImageView.image = message.userPicture
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        // Profile Image View Constraints
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        // Time Label Constraints
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
