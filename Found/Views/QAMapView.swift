//
//  QAMapView.swift
//  Found
//
//  Created by Sergio Hernandez on 21/09/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
import MapKit

class QAMapView: QAView {
    
    @IBOutlet weak var map: MKMapView!
    
    @IBAction func ratherWriteItDownPressed(_ sender: UIButton) {
        let auxView = QARegularView()
        auxView.question = "Please write down the place you'd like to meet at. If you'll leave it blank I'll assume you are flexible on this."
        auxView.nextView = self.nextView
        present(auxView, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
