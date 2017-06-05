//
//  indexSocialSetting.swift
//  Mhint
//
//  Created by Andrea Merli on 07/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import UIKit

//SOCIAL IMPORT
import FBSDKLoginKit //FACEBOOK SDK
import Firebase //FIREBASE
import FirebaseAuth //FIREBASE
import GoogleSignIn //GOOGLE SDK
import TwitterKit //TWITTER SDK
import Fabric //TWITTER - FABRIC

class socialController: UICollectionViewController, UICollectionViewDelegateFlowLayout, GIDSignInUIDelegate{
    
    let celId = "cellIdSocail"
    
    let arraySocial = ["Facebook", "Google", "Twitter", "LinkedIn", "Pinterest", "Instagram"]
    let arrayColor = [UIColor.init(red: 59/255, green: 89/255, blue: 152/255, alpha: 1), UIColor.init(red: 221/255, green: 75/255, blue: 57/255, alpha: 1), UIColor.init(red: 29/255, green: 161/255, blue: 242/255, alpha: 1), UIColor.init(red: 0/255, green: 119/255, blue: 181/255, alpha: 1), UIColor.init(red: 189/255, green: 8/255, blue: 28/255, alpha: 1), UIColor.init(red: 131/255, green: 58/255, blue: 180/255, alpha: 1)]
    
    var facebookToken = ""
    
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
        
        customCell.switchSection.isEnabled = false
        
        if indexPath.row == 0 {
            customCell.switchSection.isOn = saveData.bool(forKey: "loginFacebook")
        } else if indexPath.row == 1 {
            customCell.switchSection.isOn = saveData.bool(forKey: "loginGoogle")
        } else if indexPath.row == 2 {
            customCell.switchSection.isOn = saveData.bool(forKey: "loginTwitter")
        } else {
            customCell.switchSection.isOn = false
        }
        
        return customCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCellEditSocial
        
        if indexPath.row == 1 && !cell.switchSection.isOn {
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().signIn()
            saveData.set(true, forKey: "loginGoogle")
        } else if indexPath.row == 1 && cell.switchSection.isOn {
            saveData.set(false, forKey: "loginGoogle")
        } else if indexPath.row == 0 && !cell.switchSection.isOn {
            facebook()
            saveData.set(true, forKey: "loginFacebook")
        } else if indexPath.row == 0 && cell.switchSection.isOn {
            saveData.set(false, forKey: "loginFacebook")
        }else if indexPath.row == 2 && !cell.switchSection.isOn {
            twitter()
            saveData.set(true, forKey: "loginTwitter")
        } else if indexPath.row == 2 && cell.switchSection.isOn {
            saveData.set(false, forKey: "loginTwitter")
        }
        
        if indexPath.row < 3 {
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
    
    
    //TWITTER
    func twitter() {
        Twitter.sharedInstance().logIn { (session, error) in
            if session != nil {
                let client = TWTRAPIClient.withCurrentUser()
                let request = client.urlRequest(withMethod: "GET",
                                                url: "https://api.twitter.com/1.1/account/verify_credentials.json?include_email=true",
                                                parameters: ["include_email": "true", "skip_status": "true"],
                                                error: nil)
                
                GlobalUser.nickname = (session?.userName)!
                GlobalFunc().saveUserProfile(value: (session?.userName)!, description: "nickname")
                
                guard let token = session?.authToken else { return }
                guard let secret = session?.authTokenSecret else { return }
                let credentials = TwitterAuthProvider.credential(withToken: token, secret: secret)
                
                client.sendTwitterRequest(request) { response, data, connectionError in
                    if (connectionError == nil) {
                        do{
                            let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                            
                            let firstName = json["name"] as! String
                            let hometown = json["location"]! as! String
                            
                            if let email = json["email"] {
                                GlobalUser.emailTwitter = email as? String
                                GlobalFunc().saveUserProfile(value: email as! String, description: "emailTwitter")
                            }
                            
                            GlobalUser.address = hometown
                            GlobalFunc().saveUserProfile(value: hometown, description: "address")
                            
                            saveData.set(firstName, forKey: "nameProfile")
                            GlobalFunc().saveUserProfile(value: firstName, description: "fullNameTwitter")
                            GlobalUser.fullNameTwitter = firstName
                            
                        } catch {
                            GlobalFunc().alert(stringAlertTitle: "Error Login Twitter", stringAlertDescription: connectionError as! String, s: self)
                        }
                        
                    }
                    else {
                        print("Error: \(String(describing: connectionError))")
                    }
                }
                
                Auth.auth().signIn(with: credentials, completion: {
                    (user, error) in
                    
                    if let image = user?.photoURL {
                        GlobalFunc().saveUserProfile(value: String(describing: image), description: "imageProfileTwitter")
                        if saveData.string(forKey: "imageProfile") == nil {
                            GlobalUser.imageProfileTwitter = String(describing: image)
                            saveData.set(String(describing: image), forKey: "imageProfile")
                        }
                    }
                    
                    if error != nil {
                        print("Error Twitter on Firebase")
                        return
                    }
                    print("Successfully Twitter on Firebase")
                    
                })
            } else {
                NSLog("Login error: %@", error!.localizedDescription);
            }
        }
    }
    
    
    //FACEBOOK
    func facebook() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile", "user_birthday", "user_hometown"], from: self, handler: { //PERMESSI DA CHIEDERE
            (result, err) in
            if result?.token != nil {
                self.facebookToken = (result?.token.tokenString)!
                print(self.facebookToken)
                self.showNameFromFacebook()
            } else {
                GlobalFunc().alert(stringAlertTitle: "Error login Facebook", stringAlertDescription: "Ops, something goes wrong.", s: self)
            }
        })
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        showNameFromFacebook()
    }
    func showNameFromFacebook() {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, picture, birthday, hometown, first_name, last_name"]).start{ //COSA PRENDERE
            (connection, result, err) in
            
            if err != nil {
                print("Error Facebook: ", err ?? "")
                GlobalFunc().alert(stringAlertTitle: "Error Login Facebook", stringAlertDescription: err as! String, s: self)
                return
            }
            
            //PRENDERE DATI DA FACEBOOK
            let result = result as? NSDictionary
            let userID = (result?["id"]!)!
            
            //NAME
            if let user_name = result?["name"] as? String {
                GlobalUser.fullNameFacebook = user_name
                GlobalFunc().saveUserProfile(value: user_name, description: "nameProfile")
            }
            
            //firstName
            if let firstName = result?["first_name"] as? String {
                GlobalUser.firstName = firstName
                saveData.set(firstName, forKey: "firstName")
            }
            
            //lastName
            if let lastName = result?["last_name"] as? String {
                GlobalUser.lastName = lastName
                saveData.set(lastName, forKey: "lastName")
            }
            
            //BIRTHDAY
            GlobalFunc().saveUserProfile(value: String(describing: result?["birthday"]), description: "birthday")
            if let user_birthday = result?["birthday"] as? DateComponents {
                var dateBirthday = ""
                dateBirthday = String(describing: user_birthday.day!) + "/" + String(describing: user_birthday.month!) + "/" + String(describing: user_birthday.year!)
                GlobalFunc().saveUserProfile(value: dateBirthday.replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")", with: ""), description: "birthday")
                GlobalUser.birthday = dateBirthday.replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")", with: "")
            }
            
            //HOMETOWN
            if let user_home = result?["hometown"] as? NSDictionary {
                if let hometown = user_home["name"]! as? String {
                    GlobalUser.address = hometown
                    GlobalFunc().saveUserProfile(value: hometown, description: "address")
                }
            }
            
            //EMAIL
            if let email = result?["email"] as? String {
                GlobalUser.emailFacebook = email
                GlobalFunc().saveUserProfile(value: email, description: "emailFacebook")
            }
            
            //IMAGE
            if let picture = result?["picture"] as? NSDictionary {
                if let picture_data = picture["data"]! as? NSDictionary {
                    if picture_data["url"]! is String {
                        GlobalUser.imageProfileFacebook = "http://graph.facebook.com/\(userID)/picture?type=large"
                        GlobalFunc().saveUserProfile(value: "http://graph.facebook.com/\(userID)/picture?type=large", description: "imageProfile")
                    }
                }
            }
            //PRENDERE DATI DA FACEBOOK
            //CARICA SU FIREBASE
            let credentials = FacebookAuthProvider.credential(withAccessToken: self.facebookToken)
            Auth.auth().signIn(with: credentials, completion: {
                (user, error) in
                if error != nil {
                    print("Error Facebook on Firebase")
                    return
                }
                
                if let email = user?.email {
                    if GlobalUser.emailFacebook == nil {
                        GlobalUser.emailFacebook = email
                        GlobalFunc().saveUserProfile(value: email, description: "emailFacebook")
                    }
                }
                
                print("Successfully Facebook on Firebase")
            })
        }
    }
    
    
    
    func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
}
