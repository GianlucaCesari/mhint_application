//
//  GlobalUser.swift
//  Mhint
//
//  Created by Andrea Merli on 20/04/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import UIKit
import Alamofire

class GlobalUser{
    
    static var fullName:String? = nil
    static var imageProfile:String? = nil
    
    static var address:String = ""
    static var birthday = DateComponents()
    
    static var height:Float = -1
    static var weight:Float = -1
    
    static var sex:Int = 0
    static var blood:Int = 0
    static var lifestyle:Int = 0
    
    static var email:String = ""
    
    static var phoneNumber:String? = nil
    
    //FACEBOOK
    static var fullNameFacebook:String? = nil
    static var imageProfileFacebook:String? = nil
    static var emailFacebook:String? = nil
    
    //TWITTER
    static var imageProfileTwitter:String? = nil
    static var nickname:String = ""
    static var fullNameTwitter:String? = nil
    static var emailTwitter:String? = nil
    
    //GOOGLE
    static var imageProfileGoogle:String? = nil
    static var fullNameGoogle:String? = nil
    static var emailGoogle:String? = nil
    
    func start(){
        if let name = saveData.value(forKey: "nameProfile") {
            GlobalUser.fullName = name as? String
        }
    
        if let img = saveData.value(forKey: "imageProfile") {
            GlobalUser.imageProfile = img as? String
        }
        
        if let hei = saveData.value(forKey: "height") {
            GlobalUser.height = hei as! Float
        }
        
        if let wei = saveData.value(forKey: "weight") {
            GlobalUser.weight = wei as! Float
        }
        
        if let add = saveData.value(forKey: "address") {
            GlobalUser.address = add as! String
        }
        
        if let add = saveData.value(forKey: "email") {
            GlobalUser.email = add as! String
        }
        
//        let bir = saveData.value(forKey: "birthday") as! DateComponents
//        GlobalUser.birthday = bir
    }
    
    func randomStringPassword(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func createUser(name: String, imageProfile: String, birthday: String, address: String, height: Float, weight: Float, sex: Int, lifestyle: Int, sectionEnabled: Array<Any>, logins: Array<Any>, mail: String) {
        
        let password = randomStringPassword(length: 10)
        
        print("Name: ", name)
        print("Birthday: ", birthday)
        print("image: ", imageProfile)
        print("address: ", address)
        print("height: ", height)
        print("weight: ", weight)
        print("sex: ", sex)
        print("lifestyle: ", lifestyle)
        print("sectionEnabled: ", sectionEnabled)
        print("logins: ", logins)
        print("mail: ", mail)
        print("password: ", password)
        
        let parameter = [
            "name": name//STRING
            //, "birthday": birthday//DATE
            , "imageProfile": imageProfile//STRING
            , "address": address//STRING
            , "height": height//FLOAT
            , "weight": weight//FLOAT
            , "sex": sex//INT (1,2,3)
            , "lifestyle": lifestyle//NUMBER
            , "sectionsEnabled": [
                "food": sectionEnabled[0]
                , "need": sectionEnabled[1]
            ]//FOOD, NEED
            , "logins": [
                "facebook": logins[0]
                , "twitter": logins[1]
                , "google": logins[2]
                , "health": logins[3]
            ]//FACEBOOK, TWITTER, GOOGLE, HEALTH
            , "mail": mail//STRING
            , "password": password//STRING
        ] as [String : Any]
        
        Alamofire.request("https://api.mhint.eu/user", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in
            print(response)
        }
        
    }
    
}
