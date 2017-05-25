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
        GlobalFunc().navBarSubView(nav: navigationItem, s: self, title: "Privacy Policy")
        webView.frame = self.view.frame
        self.view.addSubview(webView)
        let url = URL(string: "https://www.mhint.eu/privacy/index.html")
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let url = URL(string: "https://www.mhint.eu/privacy/index.html")
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
}
