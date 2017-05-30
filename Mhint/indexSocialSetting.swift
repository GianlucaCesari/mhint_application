//
//  indexSocialSetting.swift
//  Mhint
//
//  Created by Andrea Merli on 07/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import UIKit

class socialController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    let celId = "cellIdSocail"
    
    let arraySocial = ["Facebook", "Google", "Twitter", "LinkedIn", "Pinterest", "Instagram"]
    let arrayColor = [UIColor.init(red: 59/255, green: 89/255, blue: 152/255, alpha: 1), UIColor.init(red: 221/255, green: 75/255, blue: 57/255, alpha: 1), UIColor.init(red: 29/255, green: 161/255, blue: 242/255, alpha: 1), UIColor.init(red: 0/255, green: 119/255, blue: 181/255, alpha: 1), UIColor.init(red: 189/255, green: 8/255, blue: 28/255, alpha: 1), UIColor.init(red: 131/255, green: 58/255, blue: 180/255, alpha: 1)]
    
    let heightRow = CGFloat(60)
    
    override func viewDidLoad() {
        
        GlobalFunc().navBarSubView(nav: navigationItem, s: self, title: "Connect your account")
        
        let btnMenu = UIButton.init(type: .custom)
        let imgMenu = UIImage(named: "arrowLeft")
        btnMenu.frame = CGRect(x: 0, y: 0, width: GlobalSize().sizeIconMenuBar, height: GlobalSize().sizeIconMenuBar)
        btnMenu.setImage(imgMenu, for: .normal)
        btnMenu.addTarget(self, action: #selector(self.back(sender:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnMenu)
        
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 2
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: view.frame.width, height: heightRow)
        collectionView?.collectionViewLayout = layout
        collectionView?.backgroundColor = .white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.04, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.96)
        collectionView?.register(CustomCellEditSocial.self, forCellWithReuseIdentifier: celId)
        
    }
    
    //COLLECTIONVIEW
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: celId, for: indexPath) as! CustomCellEditSocial
        
        let stringImage = arraySocial[indexPath.row].lowercased()
        let imageSocial = UIImage(named: stringImage)
        customCell.img.image = imageSocial
        customCell.img.alpha = 0.9
        customCell.img.frame = CGRect(x: 20, y: (Int(heightRow)-(Int(heightRow)/3))/2, width: Int(heightRow)/3, height: Int(heightRow)/3)
        
        customCell.titleTextView.text = arraySocial[indexPath.row]
        customCell.titleTextView.frame = CGRect(x: 60, y: 0, width: Int(GlobalSize().widthScreen/2), height: Int(heightRow))
        customCell.switchSection.frame = CGRect(x: GlobalSize().widthScreen*0.8, y: (CGFloat(heightRow)-customCell.switchSection.frame.size.height)/2, width: 0, height: 0)
        
        if indexPath.row > 2 {
            customCell.switchSection.isOn = false
            customCell.switchSection.isEnabled = false
        } else if !saveData.bool(forKey: "loginFacebook") && indexPath.row == 0 {
            customCell.switchSection.isOn = false
        } else if !saveData.bool(forKey: "loginGoogle") && indexPath.row == 1 {
            customCell.switchSection.isOn = false
        } else if !saveData.bool(forKey: "loginTwitter") && indexPath.row == 2 {
            customCell.switchSection.isOn = false
        }
        
        return customCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < 3 {
            let cell = collectionView.cellForItem(at: indexPath) as! CustomCellEditSocial
            cell.switchSection.isOn = !cell.switchSection.isOn
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arraySocial.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: heightRow)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    //COLLECTIONVIEW
    
    func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
}
