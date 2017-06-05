//
//  indexSettingEditProfile.swift
//  Mhint
//
//  Created by Andrea Merli on 08/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import UIKit

import Alamofire //INTERNET

class editProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate{
    
    let customCellIdentifierEditProfile = "customCellIdentifierEditProfile"
    
    var editProfileData = [String]()
    
    var saveDataProfile:Bool? = nil
    
    var tap = UITapGestureRecognizer()
    let datePickerView:UIDatePicker = UIDatePicker()
    
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
            let b = birthday.replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")", with: "")
            editProfileData.append(b)
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
        save.addTarget(self, action: #selector(saveProfile), for: .touchUpInside)
        self.view.addSubview(save)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: customCellIdentifierEditProfile, for: indexPath) as! CustomCellEditProfile
        
        customCell.titleTextView.text = editProfileData[indexPath.row]
        customCell.titleTextView.frame = CGRect(x: GlobalSize().widthScreen*0.1, y: 0, width: GlobalSize().widthScreen*0.9, height: customCell.frame.size.height)
        customCell.titleTextView.delegate = self
        customCell.titleTextView.tag = indexPath.row
        
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
            customCell.titleTextView.isEnabled = false
            customCell.titleTextView.frame = CGRect(x: GlobalSize().widthScreen*0.1, y: 10, width: GlobalSize().widthScreen*0.9, height: customCell.frame.size.height-10)
        } else {
            customCell.backgroundColor = .white
            customCell.titleTextView.font = UIFont(name: "AvenirLTStd-Medium", size: 17)
        }
        if indexPath.row == 5 || indexPath.row == 6 {
            customCell.titleTextView.keyboardType = UIKeyboardType.decimalPad
        } else if indexPath.row == 3 {
            datePickerView.datePickerMode = UIDatePickerMode.date
            datePickerView.calendar = Calendar.current
            customCell.titleTextView.inputView = datePickerView
            let doneButton = UIButton(frame: CGRect(x:0, y:-40, width:self.view.frame.width, height:40))
            doneButton.setTitle("DONE", for: UIControlState.normal)
            doneButton.setTitleColor(.white, for: .normal)
            doneButton.backgroundColor = GlobalColor().greenSea
            doneButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Heavy", size: 12)
            customCell.titleTextView.inputView?.addSubview(doneButton)
        }
        
        tap = UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturnClose))
        self.view.addGestureRecognizer(tap)
        
        return customCell
    }
    
    func doneButton(sender:UIButton) {
        datePickerView.resignFirstResponder()
    }
    
    func textFieldShouldReturnClose(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.view.removeGestureRecognizer(tap)
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 5:
            textField.text = textField.text?.replacingOccurrences(of: "H. ", with: "")
            textField.text = textField.text?.replacingOccurrences(of: " cm", with: "")
        case 6:
            textField.text = textField.text?.replacingOccurrences(of: "W. ", with: "")
            textField.text = textField.text?.replacingOccurrences(of: " kg", with: "")
        default: break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveDataProfile = false
        switch textField.tag {
        case 0:
            let textTrimmed = (textField.text!).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if textTrimmed != "" {
                GlobalUser.fullName = textTrimmed
                saveData.set(textTrimmed, forKey: "nameProfile")
                editProfileData[0] = textTrimmed
            } else {
                textField.text = editProfileData[0]
                GlobalFunc().alertCustom(stringAlertTitle: "Error type name", stringAlertDescription: "This value need to be set", button: "Ok", s: self)
            }
        case 2:
            let textTrimmed = (textField.text!).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            print(textTrimmed)
            if textTrimmed != "" {
                GlobalUser.address = textTrimmed
                editProfileData[2] = textTrimmed
                saveData.set(textTrimmed, forKey: "address")
            } else {
                print(editProfileData)
                textField.text = editProfileData[2]
                GlobalFunc().alertCustom(stringAlertTitle: "Error type address", stringAlertDescription: "This value need to be set", button: "Ok", s: self)
            }
        case 3:
            let calendar = Calendar.current
            let year = calendar.component(.year, from: datePickerView.date)
            let month = calendar.component(.month, from: datePickerView.date)
            let day = calendar.component(.day, from: datePickerView.date)
            
            textField.text = "\(day.addZero(string: day))/\(month.addZero(string: month))/\(year.addZero(string: year))"
            editProfileData[3] = textField.text!
            GlobalUser.birthday = textField.text!
            saveData.set(textField.text!, forKey: "birthday")
        case 5:
            if let height = Int(textField.text!) {
                textField.text = "H. \(height) cm"
                editProfileData[5] = textField.text!
                GlobalUser.height = height
                saveData.set(height, forKey: "height")
            } else {
                GlobalFunc().alertCustom(stringAlertTitle: "Error type height", stringAlertDescription: "This value need to be integer", button: "Ok", s: self)
                textField.text = editProfileData[5]
            }
        case 6:
            if let weight = Int(textField.text!) {
                textField.text = "W. \(weight) kg"
                editProfileData[6] = textField.text!
                GlobalUser.weight = weight
                saveData.set(weight, forKey: "weight")
            } else {
                GlobalFunc().alertCustom(stringAlertTitle: "Error type weight", stringAlertDescription: "This value need to be integer", button: "Ok", s: self)
                textField.text = editProfileData[6]
            }
        default: break
        }
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
        if saveDataProfile == nil || saveDataProfile! {
            _ = navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Don't forget", message: "You want to save the profile before go back to setting", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (_) -> Void in
                self.saveDataProfile = true
                self.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (_) -> Void in
                self.saveProfile()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func saveProfile() {
        GlobalFunc().alertCustom(stringAlertTitle: "Profile succefully edit", stringAlertDescription: "", button: "Ok", s: self)
        
        let parameter = [
            "mail": GlobalUser.email
            , "name": GlobalUser.fullName!
            , "birthday": GlobalUser.birthday
            , "address": GlobalUser.address
            , "height": GlobalUser.height
            , "weight": GlobalUser.weight
            ] as [String : Any]
        
        Alamofire.request("https://api.mhint.eu/user", method: .put, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in
            print(response)
        }
        saveDataProfile = true
    }
    
}
