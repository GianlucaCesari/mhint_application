//
//  DetailsRecipes.swift
//  Mhint
//
//  Created by Andrea Merli on 26/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class DetailsRecipesController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate{
    
    let cellId = "cellDetailsRecipes"
    
    var player = AVPlayer()
    
    let heightCell = GlobalSize().widthScreen*0.15
    let widthCollectionView = GlobalSize().widthScreen
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = GlobalColor().backgroundCollectionView
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        let btnMenu = UIButton.init(type: .custom)
        let imgMenu = UIImage(named: "close-details-recipes")
        btnMenu.frame = CGRect(x: 0, y: 0, width: GlobalSize().sizeIconMenuBar, height: GlobalSize().sizeIconMenuBar)
        btnMenu.setImage(imgMenu, for: .normal)
        btnMenu.addTarget(self, action: #selector(self.back(sender:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnMenu)
        let btnMenuBack = UIButton.init(type: .custom)
        btnMenuBack.setTitleColor(.clear, for: .normal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnMenuBack)
        
        self.navigationController?.navigationBar.barTintColor = .clear
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: widthCollectionView, height: heightCell)
        collectionView?.collectionViewLayout = layout
        collectionView?.backgroundColor = GlobalColor().backgroundCollectionView
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.255, width: widthCollectionView, height: GlobalSize().heightScreen*0.72)
        collectionView?.register(CustomCellChooseHomeDetailsRecipes.self, forCellWithReuseIdentifier: cellId)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        
        videoRecipes()
        
    }
    
    //COLLECTIONVIEW
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCellChooseHomeDetailsRecipes
        
        cell.lineTitleSection.frame = CGRect(x: 0, y: (heightCell-2)/2, width: GlobalSize().widthScreen, height: 2)
        cell.lineTitleSection.backgroundColor = .black
        cell.lineTitleSection.alpha = 0.4
        
        cell.titleSection.text = "NUTRITIONAL VALUE"
        cell.titleSection.frame = CGRect(x: GlobalSize().widthScreen*0.06, y: (heightCell-GlobalSize().heightScreen*0.1)/2, width: GlobalSize().widthScreen*0.35, height: GlobalSize().heightScreen*0.1)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: widthCollectionView, height: heightCell)
    }
    
    func videoRecipes() {
        let videoURL = URL(string: "https://15-lvl3-pdl.vimeocdn.com/01/1067/3/80339790/207851306.mp4?expires=1495805453&token=0d7db8187270338612246")
        player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 20, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.561)
        self.view.layer.addSublayer(playerLayer)
        
        let overlay = UIView()
        overlay.frame = playerLayer.frame
        overlay.backgroundColor = .black
        overlay.alpha = 0.3
        self.view.addSubview(overlay)
        
        let btnPlayVideo = UIButton.init(type: .custom)
        let imgMenu = UIImage(named: "play")
        btnPlayVideo.frame = CGRect(x: GlobalSize().widthScreen*0.45, y: GlobalSize().widthScreen*0.35, width: GlobalSize().widthScreen*0.1, height: GlobalSize().widthScreen*0.1)
        btnPlayVideo.setImage(imgMenu, for: .normal)
        btnPlayVideo.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        self.view.addSubview(btnPlayVideo)
        
        let titleRecipes = UILabel()
        titleRecipes.text = "Pasta con tonno"
        titleRecipes.textAlignment = .center
        titleRecipes.font = UIFont(name: "AvenirLTStd-Heavy", size: GlobalSize().widthScreen*0.05)
        titleRecipes.textColor = .white
        titleRecipes.frame = CGRect(x: 0, y: GlobalSize().widthScreen*0.21, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.1)
        self.view.addSubview(titleRecipes)
        
    }
    
    func playVideo() {
        player.play()
    }
    
    
    func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
}
