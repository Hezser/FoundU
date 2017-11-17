//
//  DividerLine.swift
//  Found
//
//  Created by Sergio Hernandez on 16/11/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit

class DividerLine: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
