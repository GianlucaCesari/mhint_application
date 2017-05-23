//
//  Emergency.swift
//  Mhint
//
//  Created by Andrea Merli on 20/04/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import UIKit

class EmergencyController: UIViewController{
    
    //CLASSI ESTERNE
    let globalColor = GlobalColor()
    let globalFunction = GlobalFunc()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        globalFunction.navBar(nav: navigationItem, s: self, show: true) //navigation bar
        
    }
    
}
