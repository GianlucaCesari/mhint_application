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
    
    let sectionTitlearray = ["Nutritional value", "ingredients", "Description"]
    let nutritionalArray = ["Calorie", "Grassi", "Proteine", "Fibre"]
    let descriptionRecipes = "Summer is often synonymous with beaches, ballparks and barbecues, all offering tempting snacks and treats. To many women who are watching their weight, the back-to-school season is an ideal time to enroll in their own Summer is often synonymous with beaches. Summer is often synonymous with beaches, ballparks and barbecues, all offering tempting snacks and treats. To many women who are watching their weight, the back-to-school season is an ideal time to enroll in their own Summer is often synonymous with beaches. Summer is often synonymous with beaches, ballparks and barbecues, all offering tempting snacks and treats. To many women who are watching their weight, the back-to-school season is an ideal time to enroll in their own Summer is often synonymous with beaches. Summer is often synonymous with beaches, ballparks and barbecues, all offering tempting snacks and treats. To many women who are watching their weight, the back-to-school season is an ideal time to enroll in their own Summer is often synonymous with beaches."
    
    let heightCellSection = GlobalSize().widthScreen*0.1
    var heightCellDescription = GlobalSize().widthScreen*0.98
    let heightCell = GlobalSize().widthScreen*0.15
    let widthCollectionView = GlobalSize().widthScreen
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = GlobalColor().backgroundCollectionView
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: widthCollectionView, height: heightCell)
        collectionView?.collectionViewLayout = layout
        collectionView?.backgroundColor = GlobalColor().backgroundCollectionView
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.3, width: widthCollectionView, height: GlobalSize().heightScreen*0.72)
        collectionView?.register(CustomCellChooseHomeDetailsRecipes.self, forCellWithReuseIdentifier: cellId)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        
        videoRecipes()
        
        swipeDown()
        
    }
    
    //COLLECTIONVIEW
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCellChooseHomeDetailsRecipes
        
        if indexPath.row == 0 {
            cell.titleSection.text = sectionTitlearray[0].uppercased()
            cell.lineTitleSection.frame = CGRect(x: 0, y: (heightCell-2)/2, width: GlobalSize().widthScreen, height: 2)
            cell.lineTitleSection.backgroundColor = .black
            cell.lineTitleSection.alpha = 0.4
            cell.titleSection.frame = CGRect(x: GlobalSize().widthScreen*0.06, y: (heightCell-GlobalSize().heightScreen*0.1)/2, width: GlobalSize().widthScreen*0.36, height: GlobalSize().heightScreen*0.1)
        } else if indexPath.row == 2 {
            cell.titleSection.text = sectionTitlearray[1].uppercased()
            cell.lineTitleSection.frame = CGRect(x: 0, y: (heightCell-2)/2, width: GlobalSize().widthScreen, height: 2)
            cell.lineTitleSection.backgroundColor = .black
            cell.lineTitleSection.alpha = 0.4
            cell.titleSection.frame = CGRect(x: GlobalSize().widthScreen*0.06, y: (heightCell-GlobalSize().heightScreen*0.1)/2, width: GlobalSize().widthScreen*0.26, height: GlobalSize().heightScreen*0.1)
        } else if indexPath.row == 4 {
            cell.titleSection.text = sectionTitlearray[2].uppercased()
            cell.lineTitleSection.frame = CGRect(x: 0, y: (heightCell-2)/2, width: GlobalSize().widthScreen, height: 2)
            cell.lineTitleSection.backgroundColor = .black
            cell.lineTitleSection.alpha = 0.4
            cell.titleSection.frame = CGRect(x: GlobalSize().widthScreen*0.06, y: (heightCell-GlobalSize().heightScreen*0.1)/2, width: GlobalSize().widthScreen*0.26, height: GlobalSize().heightScreen*0.1)
        } else if indexPath.row == 5 {
            cell.descriptionRecipes.text = descriptionRecipes
            let heightFrame = NSString(string: descriptionRecipes).boundingRect(with: CGSize(width: GlobalSize().widthScreen*0.88, height: GlobalSize().heightScreen*10), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)], context: nil)
            cell.descriptionRecipes.frame = CGRect(x: GlobalSize().widthScreen*0.06, y: GlobalSize().heightScreen*0.02, width: GlobalSize().widthScreen*0.88, height: (heightFrame.height + GlobalSize().heightScreen*0.07))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 {
            return CGSize(width: widthCollectionView, height: heightCellSection)
        } else if indexPath.row == 5 {
            let heightFrame = NSString(string: descriptionRecipes).boundingRect(with: CGSize(width: GlobalSize().widthScreen*0.88, height: GlobalSize().heightScreen*10), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)], context: nil)
            return CGSize(width: widthCollectionView, height: (heightFrame.height + GlobalSize().heightScreen*0.07))
        } else {
            return CGSize(width: widthCollectionView, height: heightCell)
        }
    }
    
    func videoRecipes() {
        
        let previewVideo = UIImageView()
        previewVideo.sd_setImage(with: URL(string: "https://i.ytimg.com/vi/B7JUzPTib9A/mqdefault.jpg"), placeholderImage: nil)
        previewVideo.frame = CGRect(x: 0, y: 0, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.561)
        self.view.addSubview(previewVideo)
        
        let overlay = UIView()
        overlay.frame = previewVideo.frame
        overlay.backgroundColor = .black
        overlay.alpha = 0.5
        self.view.addSubview(overlay)
        
        let btnPlayVideo = UIButton.init(type: .custom)
        let imgMenu = UIImage(named: "play")
        btnPlayVideo.frame = CGRect(x: GlobalSize().widthScreen*0.45, y: GlobalSize().widthScreen*0.285, width: GlobalSize().widthScreen*0.1, height: GlobalSize().widthScreen*0.1)
        btnPlayVideo.setImage(imgMenu, for: .normal)
        btnPlayVideo.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        self.view.addSubview(btnPlayVideo)
        
        let titleRecipes = UILabel()
        titleRecipes.text = "Pasta con tonno"
        titleRecipes.textAlignment = .center
        titleRecipes.font = UIFont(name: "AvenirLTStd-Heavy", size: GlobalSize().widthScreen*0.05)
        titleRecipes.textColor = .white
        titleRecipes.frame = CGRect(x: 0, y: GlobalSize().widthScreen*0.15, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.1)
        self.view.addSubview(titleRecipes)
        
        let btnMenu = UIButton()
        let imgMenuClose = UIImage(named: "close-details-recipes")
        btnMenu.setImage(imgMenuClose, for: .normal)
        btnMenu.addTarget(self, action: #selector(back), for: .touchUpInside)
        btnMenu.frame = CGRect(x: GlobalSize().widthScreen*0.93, y: 7, width: GlobalSize().widthScreen*0.05, height: GlobalSize().widthScreen*0.05)
        self.view.addSubview(btnMenu)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func playVideo() {
        let youtubeId = "SxTYjptEzZs"
        var youtubeUrl = NSURL(string:"youtube://\(youtubeId)")!
        if UIApplication.shared.canOpenURL(youtubeUrl as URL) {
            UIApplication.shared.open(youtubeUrl as URL)
        } else {
            youtubeUrl = NSURL(string:"https://www.youtube.com/watch?v=\(youtubeId)")!
            UIApplication.shared.open(youtubeUrl as URL)
        }
    }
    
    func swipeDown() {
        let swipeDownGesture = UISwipeGestureRecognizer(target:self, action: #selector(back))
        swipeDownGesture.direction = .down
        self.view.addGestureRecognizer(swipeDownGesture)
    }
    
    func back() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        view.window?.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
}
