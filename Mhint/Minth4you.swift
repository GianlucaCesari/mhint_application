//
//  Teaching.swift
//  Mhint
//
//  Created by Andrea Merli on 20/04/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import UIKit

class MhintController: UIViewController{
    
    //CLASSI ESTERNE
    let globalColor = GlobalColor()
    let globalFunction = GlobalFunc()
    
    var webView: UIWebView! = UIWebView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        globalFunction.navBar(nav: navigationItem, s: self, show: true) //navigation bar
        webView.frame = self.view.frame
        self.view.addSubview(webView)
//        let url = URL(string: "https://mhint.eu/privacy/")
//        let request = URLRequest(url: url!)
        webView.loadRequest(URLRequest(url: URL(string: "https://www.mhint.eu/privacy/index.html")!))
    }
    
}
