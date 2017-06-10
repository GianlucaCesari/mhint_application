//
//  Teaching.swift
//  Mhint
//
//  Created by Andrea Merli on 20/04/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import UIKit

//GIF
import SwiftyGif

class MhintController: UIViewController, UIWebViewDelegate{
    
    //CLASSI ESTERNE
    let globalColor = GlobalColor()
    let globalFunction = GlobalFunc()
    
    var webView: UIWebView! = UIWebView()
    
    var imageLoadingView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        UIApplication.shared.statusBarView?.backgroundColor = .white
        
        imageLoadingView = UIImageView(gifImage: UIImage(gifName: "load"), manager: SwiftyGifManager(memoryLimit:20))
        imageLoadingView.frame = CGRect(x: GlobalSize().widthScreen*0.25, y: GlobalSize().heightScreen*0.4, width: GlobalSize().widthScreen*0.5, height: GlobalSize().widthScreen*0.5)
        
        globalFunction.navBar(nav: navigationItem, s: self, show: true) //navigation bar
        GlobalFunc().navBarSubView(nav: navigationItem, s: self, title: "Privacy Policy")
        
        webView.frame = self.view.frame
        webView.backgroundColor = .clear
        let url = URL(string: "https://www.mhint.eu/privacy/index.html")
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
        webView.delegate = self
        self.view.addSubview(webView)
        
        self.view.addSubview(imageLoadingView)
        
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        webView.alpha = 0
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        imageLoadingView.alpha = 1
        webView.alpha = 1
        self.view.willRemoveSubview(imageLoadingView)
        imageLoadingView.alpha = 0
    }
    
}
