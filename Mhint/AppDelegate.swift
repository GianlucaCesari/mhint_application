//
//  AppDelegate.swift
//  Mhint
//
//  Created by Andrea Merli on 15/04/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import UIKit
import UserNotifications //NOTIFICHE
import CoreLocation //POSIZIONE
//LOGIN
import FBSDKCoreKit
import GoogleSignIn
import TwitterKit
import Fabric
import Firebase
import Alamofire
import Whisper

//MENU
import AKSideMenu

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, AKSideMenuDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var chatController = ChatController()
    var chatbotController = ChatBotController()
    var locationManager: CLLocationManager!
    
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        //ALL'APERTURA DI UNA LOCALNOTIFICATION VA A SHOPPINGLIST 
        let controllerToShow = HomeShoppingListController(collectionViewLayout: layout)
        self.window!.rootViewController = controllerToShow
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        NOTIFICATIONS REMOTES
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
//            // iOS 9 support
//        else if #available(iOS 9, *) {
//            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
//            UIApplication.shared.registerForRemoteNotifications()
//        }
//            // iOS 8 support
//        else if #available(iOS 8, *) {
//            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
//            UIApplication.shared.registerForRemoteNotifications()
//        }
//            // iOS 7 support
        else {  
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in }
        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsetsMake(8, 0, 0, 0)
        layout.itemSize = CGSize(width: GlobalSize().widthScreen, height: 100)
        chatbotController = ChatBotController(collectionViewLayout: layout)
        let layoutChat = UICollectionViewFlowLayout.init()
        layoutChat.sectionInset = UIEdgeInsetsMake(8, 0, 0, 0)
        layoutChat.itemSize = CGSize(width: GlobalSize().widthScreen, height: 100)
        chatController = ChatController(collectionViewLayout: layoutChat)
        
        GlobalUser().start()//ISTANZIA
        
        //MENU
        
        var navigationController = UINavigationController()
        if saveData.bool(forKey: "welcomeFinish") {
            navigationController = UINavigationController(rootViewController: chatbotController)
        } else {
            navigationController = UINavigationController(rootViewController: chatController)
        }
        
        let leftMenuViewController = LeftMenuViewController()
        let rightMenuViewController = LeftMenuViewController()
        let sideMenuViewController: AKSideMenu = AKSideMenu(contentViewController: navigationController, leftMenuViewController: leftMenuViewController, rightMenuViewController: rightMenuViewController)
        sideMenuViewController.panGestureRightEnabled = false
        sideMenuViewController.menuPreferredStatusBarStyle = .lightContent
        sideMenuViewController.delegate = self
        sideMenuViewController.contentViewShadowColor = .darkGray
        sideMenuViewController.contentViewShadowOffset = CGSize(width: 0, height: 0)
        sideMenuViewController.contentViewShadowOpacity = 0.4
        sideMenuViewController.contentViewShadowRadius = 12
        sideMenuViewController.contentViewShadowEnabled = true
        window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = sideMenuViewController
        self.window!.backgroundColor = .white
        self.window?.makeKeyAndVisible()
        
        //SOCIAL
        FirebaseApp.configure() //FIREBASE
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions) //FACEBOOK
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID //GOOGLE
        GIDSignIn.sharedInstance().delegate = self //GOOGLE
        Fabric.with([Twitter.self]) //TWITTER
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        saveData.set(deviceTokenString, forKey: "deviceTokenString")
        // /deviceverify
        if saveData.string(forKey: "email") != nil {
            let parameter = [
                "mail": saveData.string(forKey: "email")!,//STRING
                "device_token": deviceTokenString
                ] as [String : Any]
            Alamofire.request("https://api.mhint.eu/deviceverify", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in
                print(response)
            }
        }
        
        // Persist it in your backend in case it's new
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
        
        let announcement = Announcement(title: String(describing:data["user"]!), subtitle: String(describing:data["text"]!),image: UIImage(named: "iconChat"), duration: 30)
        Whisper.show(shout: announcement, to: (self.window?.rootViewController)!, completion: {
            print("Entra qui dentro quando schiacci") //QUESTO ANDRA A NEEDSVIEWCONTROLLER
        })
        
        
//        let alertController = UIAlertController(title: "Title", message: "Any message", preferredStyle: .actionSheet)
//        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
//            UIAlertAction in
//            NSLog("OK Pressed")
//        }
//        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) {
//            UIAlertAction in
//            NSLog("Cancel Pressed")
//        }
//        alertController.addAction(okAction)
//        alertController.addAction(cancelAction)
//        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            ChatController().generateButton(buttonMessage: "Facebook;Twitter;Google")
            print("Error Google: ", error)
            return
        }
        
        let image:String = String(describing: user.profile.imageURL(withDimension: 120))
        
        let name:String = (user.profile.name) as String
        
        GlobalFunc().saveUserProfile(value: name, description: "fullNameGoogle")
        if saveData.string(forKey: "nameProfile") == nil {
            saveData.set(name, forKey: "nameProfile")
            GlobalUser.fullNameGoogle = name
            saveData.set(user.profile.givenName, forKey: "firstName")
            saveData.set(user.profile.familyName, forKey: "lastName")
            GlobalUser.firstName = user.profile.givenName
            GlobalUser.lastName = user.profile.familyName
        }
        
        if saveData.string(forKey: "imageProfile") == nil {
            let imgGoogle = image.replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")", with: "")
            GlobalUser.imageProfileGoogle = imgGoogle
            saveData.set(imgGoogle, forKey: "imageProfile")
            GlobalFunc().saveUserProfile(value: imgGoogle, description: "imageProfileGoogle")
        }
        
        GlobalUser.emailGoogle = user.profile.email ?? ""
        GlobalFunc().saveUserProfile(value: user.profile.email ?? "", description: "emailGoogle")
        
        guard let idTokenGoogle = user.authentication.idToken else {return}
        guard let accessToken = user.authentication.accessToken else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: idTokenGoogle, accessToken: accessToken)
        
        //FIREBASE
        Auth.auth().signIn(with: credentials, completion: {(user, err) in
            if err != nil{
                print("Error Google on Firebase")
                return
            }
            ChatController.loginGoogleBool = true
            print("Successfully Google on Firebase")
        })
    }
    
    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {
        locationManager.startMonitoringSignificantLocationChanges()
    }

    //LOGIN
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handle = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options [UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: [UIApplicationOpenURLOptionsKey.annotation])
        GIDSignIn.sharedInstance().handle(url, sourceApplication:options [UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [UIApplicationOpenURLOptionsKey.annotation])
        return handle
    }
    
    //MENU
    open func sideMenu(_ sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController) {}
    open func sideMenu(_ sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController) {}
    open func sideMenu(_ sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController) {}
    open func sideMenu(_ sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController) {}
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        GlobalFunc().getLocation(latitude: lat, longitude: long)
    }
}

