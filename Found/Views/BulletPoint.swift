//
//  BulletPoint.swift
//  Found
//
//  Created by Sergio Hernandez on 12/12/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit

class BulletPoint: UILabel {
    
    public var color: UIColor! {
        didSet {
            textColor = color
        }
    }
    public var size: CGFloat! {
        didSet {
            UIFont.systemFont(ofSize: size)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        text = "\u{2022}"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
