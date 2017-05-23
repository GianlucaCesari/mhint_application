//
//  indexSettingEditProfile.swift
//  Mhint
//
//  Created by Andrea Merli on 08/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import UIKit

class editProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    let customCellIdentifierEditProfile = "customCellIdentifierEditProfile"
    
    var editProfileData = [String]()
    
    override func viewDidLoad() {
        
        if let name = saveData.string(forKey: "nameProfile") {
            editProfileData.append(name)
        } else {
            editProfileData.append("Not set")
        }
        editProfileData.append("Personal Info")
        if let address = saveData.string(forKey: "address") {
            editProfileData.append(address)
        } else {
            editProfileData.append("Not set")
        }
        if let birthday = saveData.string(forKey: "birthday") {
            editProfileData.append(birthday)
        } else {
            editProfileData.append("Not set")
        }
        editProfileData.append("Physical Info")
        if let height = saveData.string(forKey: "height") {
            editProfileData.append("H. " + height + " cm")
        } else {
            editProfileData.append("Not set")
        }
        if let weight = saveData.string(forKey: "weight") {
            editProfileData.append("W. " + weight + " kg")
        } else {
            editProfileData.append("Not set")
        }
        
        GlobalFunc().navBarSubView(nav: navigationItem, s: self, title: "Edit Profile")
        
        self.view.backgroundColor = .white
        
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
        layout.itemSize = CGSize(width: view.frame.width, height: 75)
        collectionView?.collectionViewLayout = layout
        collectionView?.backgroundColor = GlobalColor().backgroundCollectionView
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.contentInset.top = -30
        collectionView?.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.04, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.86)
        collectionView?.register(CustomCellEditProfile.self, forCellWithReuseIdentifier: customCellIdentifierEditProfile)
        
        saveBtn()
        
    }
    
    func saveBtn() {
        let save = UIButton()
        save.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.9, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.1)
        save.setTitle("Save Settings", for: .normal)
        save.backgroundColor = GlobalColor().greenSea
        save.setTitleColor(.white, for: .normal)
        save.titleLabel?.font = UIFont(name: "AvenirLTStd-Black", size: 16)
//        save.addTarget(self, action: #selector(), for: .touchUpInside)
        self.view.addSubview(save)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: customCellIdentifierEditProfile, for: indexPath) as! CustomCellEditProfile
        
        customCell.titleTextView.text = editProfileData[indexPath.row]
        customCell.titleTextView.frame = CGRect(x: GlobalSize().widthScreen*0.1, y: 0, width: GlobalSize().widthScreen*0.9, height: customCell.frame.size.height)
        
        if indexPath.row == 0 {
            customCell.backgroundColor = .white
            customCell.titleTextView.frame = CGRect(x: GlobalSize().widthScreen*0.1, y: 100, width: GlobalSize().widthScreen*0.9, height: customCell.frame.size.height-100)
            customCell.titleTextView.font = UIFont(name: "AvenirLTStd-Heavy", size: 16)

            customCell.imageProfile.sd_setImage(with: URL(string: GlobalUser.imageProfile!), placeholderImage: UIImage(named: "default"))
            
            customCell.imageProfile.alpha = 1
            
            customCell.imageProfile.layer.cornerRadius = GlobalSize().widthScreen*0.02
            customCell.imageProfile.layer.borderWidth = GlobalSize().widthScreen*0.015
            customCell.imageProfile.layer.borderColor = UIColor.clear.cgColor
            customCell.imageProfile.layer.masksToBounds = true
            
            customCell.imageProfile.layer.shadowColor = UIColor.black.cgColor
            customCell.imageProfile.layer.shadowOpacity = 0.8
            customCell.imageProfile.layer.shadowOffset = CGSize.zero
            customCell.imageProfile.layer.shadowRadius = 10
            
            customCell.imageProfile.frame = CGRect(x: GlobalSize().widthScreen*0.1, y: GlobalSize().heightScreen*0.03, width: GlobalSize().widthScreen*0.2, height: GlobalSize().widthScreen*0.2)
        }
        else if (indexPath.row == 1 || indexPath.row == 4) {
            customCell.titleTextView.font = UIFont(name: "AvenirLTStd-Black", size: 11)
            customCell.titleTextView.text = editProfileData[indexPath.row].uppercased()
            customCell.titleTextView.addTextSpacing()
            customCell.titleTextView.frame = CGRect(x: GlobalSize().widthScreen*0.1, y: 10, width: GlobalSize().widthScreen*0.9, height: customCell.frame.size.height-10)
        } else {
            customCell.backgroundColor = .white
            customCell.titleTextView.font = UIFont(name: "AvenirLTStd-Medium", size: 17)
        }
        return customCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row) //CLICK ROW
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return editProfileData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: view.frame.width, height: 150)
        }
        else if (indexPath.row == 1 || indexPath.row == 4) {
            return CGSize(width: view.frame.width, height: 60)
        }
        return CGSize(width: view.frame.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
