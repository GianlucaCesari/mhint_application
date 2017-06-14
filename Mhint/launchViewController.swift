//
//  launchViewController.swift
//  Mhint
//
//  Created by Andrea Merli on 12/06/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import UIKit

class launchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let img = UIImageView(frame: CGRect(x: self.view.bounds.width*0.407, y: (self.view.bounds.height-(self.view.bounds.width*0.186))/2, width: self.view.bounds.width*0.186, height: self.view.bounds.width*0.186))
        img.image = UIImage(named: "iconChatSplashScreen")
        self.view.addSubview(img)
    }
}
