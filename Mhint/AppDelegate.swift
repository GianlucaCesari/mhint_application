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
import ApiAI

//MENU
import AKSideMenu

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, AKSideMenuDelegate, CLLocationManagerDelegate {
    
    var shortcutItem: UIApplicationShortcutItem?
    var window: UIWindow?
    var chatController = ChatController()
    var chatbotController = ChatBotController()
    var emergencyController = EmergencyController()
    var locationManager: CLLocationManager!
    let apiai = ApiAI.shared()!
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        if application.applicationState == UIApplicationState.inactive || application.applicationState == UIApplicationState.background {
            var navigationController = UINavigationController()
            
            let layoutChat = UICollectionViewFlowLayout.init()
            layoutChat.sectionInset = UIEdgeInsetsMake(8, 0, 0, 0)
            layoutChat.itemSize = CGSize(width: GlobalSize().widthScreen, height: 100)
            let emergency = HomeFoodController(collectionViewLayout: layoutChat)
            navigationController = UINavigationController(rootViewController: emergency)
            
            let leftMenuViewController = LeftMenuViewController()
            let rightMenuViewController = LeftMenuViewController()
            let sideMenuViewController: AKSideMenu = AKSideMenu(contentViewController: navigationController, leftMenuViewController: leftMenuViewController, rightMenuViewController: rightMenuViewController)
            sideMenuViewController.setContentViewController(UINavigationController.init(rootViewController: HomeFoodController(collectionViewLayout: layout)), animated: true)
            
            sideMenuViewController.panGestureRightEnabled = false
            sideMenuViewController.menuPreferredStatusBarStyle = .lightContent
            sideMenuViewController.delegate = self
            sideMenuViewController.contentViewShadowColor = .darkGray
            sideMenuViewController.contentViewShadowOffset = CGSize(width: 0, height: 0)
            sideMenuViewController.contentViewShadowOpacity = 0.4
            sideMenuViewController.contentViewShadowRadius = 12
            sideMenuViewController.contentViewShadowEnabled = true
            self.window!.rootViewController = sideMenuViewController
            self.window!.backgroundColor = .white
            self.window?.makeKeyAndVisible()
        } else {
            let announcement = Announcement(title: "It's time to go grocery-shopping!", subtitle: "Click here to see your grocery list.", image: UIImage(named: "iconChat"), duration: 4, action: {
                var navigationController = UINavigationController()
                
                let layoutChat = UICollectionViewFlowLayout.init()
                layoutChat.sectionInset = UIEdgeInsetsMake(8, 0, 0, 0)
                layoutChat.itemSize = CGSize(width: GlobalSize().widthScreen, height: 100)
                let emergency = HomeFoodController(collectionViewLayout: layoutChat)
                navigationController = UINavigationController(rootViewController: emergency)
                
                let leftMenuViewController = LeftMenuViewController()
                let rightMenuViewController = LeftMenuViewController()
                let sideMenuViewController: AKSideMenu = AKSideMenu(contentViewController: navigationController, leftMenuViewController: leftMenuViewController, rightMenuViewController: rightMenuViewController)
                sideMenuViewController.setContentViewController(UINavigationController.init(rootViewController: HomeFoodController(collectionViewLayout: layout)), animated: true)
                
                sideMenuViewController.panGestureRightEnabled = false
                sideMenuViewController.menuPreferredStatusBarStyle = .lightContent
                sideMenuViewController.delegate = self
                sideMenuViewController.contentViewShadowColor = .darkGray
                sideMenuViewController.contentViewShadowOffset = CGSize(width: 0, height: 0)
                sideMenuViewController.contentViewShadowOpacity = 0.4
                sideMenuViewController.contentViewShadowRadius = 12
                sideMenuViewController.contentViewShadowEnabled = true
                self.window!.rootViewController = sideMenuViewController
                self.window!.backgroundColor = .white
                self.window?.makeKeyAndVisible()
            })
            Whisper.show(shout: announcement, to: (self.window?.rootViewController)!, completion: {})
        }
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let controller = launchViewController() as launchViewController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = controller
        self.window!.backgroundColor = .white
        self.window?.makeKeyAndVisible()
        
        //API.AI
        let configuration: AIConfiguration = AIDefaultConfiguration()
        configuration.clientAccessToken = "fb6d48f1ebf04969b8791576731e4f5b"
        apiai.configuration = configuration
        
        //REMOTE NOTIFICATION
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        } else {
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
        let leftMenuViewController = LeftMenuViewController()
        let rightMenuViewController = LeftMenuViewController()
        if saveData.string(forKey: "email") != nil {
            let email = saveData.string(forKey: "email")!
            let parameter = [
                "mail": email
                ] as [String : Any]
            Alamofire.request("https://api.mhint.eu/user/find", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in
                if let httpStatusCode = response.response?.statusCode {
                    if httpStatusCode == 404 {
                        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                        UserDefaults.standard.synchronize()
                        navigationController = UINavigationController(rootViewController: self.chatController)
                        let sideMenuViewController: AKSideMenu = AKSideMenu(contentViewController: navigationController, leftMenuViewController: leftMenuViewController, rightMenuViewController: rightMenuViewController)
                        sideMenuViewController.panGestureRightEnabled = false
                        sideMenuViewController.menuPreferredStatusBarStyle = .lightContent
                        sideMenuViewController.delegate = self
                        sideMenuViewController.contentViewShadowColor = .darkGray
                        sideMenuViewController.contentViewShadowOffset = CGSize(width: 0, height: 0)
                        sideMenuViewController.contentViewShadowOpacity = 0.4
                        sideMenuViewController.contentViewShadowRadius = 12
                        sideMenuViewController.contentViewShadowEnabled = true
                        self.window!.rootViewController = sideMenuViewController
                    } else {
                        if saveData.bool(forKey: "welcomeFinish0") {
                            navigationController = UINavigationController(rootViewController: self.chatbotController)
                        } else {
                            navigationController = UINavigationController(rootViewController: self.chatController)
                        }
                        let sideMenuViewController: AKSideMenu = AKSideMenu(contentViewController: navigationController, leftMenuViewController: leftMenuViewController, rightMenuViewController: rightMenuViewController)
                        sideMenuViewController.panGestureRightEnabled = false
                        sideMenuViewController.menuPreferredStatusBarStyle = .lightContent
                        sideMenuViewController.delegate = self
                        sideMenuViewController.contentViewShadowColor = .darkGray
                        sideMenuViewController.contentViewShadowOffset = CGSize(width: 0, height: 0)
                        sideMenuViewController.contentViewShadowOpacity = 0.4
                        sideMenuViewController.contentViewShadowRadius = 12
                        sideMenuViewController.contentViewShadowEnabled = true
                        self.window!.rootViewController = sideMenuViewController
                    }
                }
            }
        } else {
            navigationController = UINavigationController(rootViewController: self.chatController)
            let sideMenuViewController: AKSideMenu = AKSideMenu(contentViewController: navigationController, leftMenuViewController: leftMenuViewController, rightMenuViewController: rightMenuViewController)
            sideMenuViewController.panGestureRightEnabled = false
            sideMenuViewController.menuPreferredStatusBarStyle = .lightContent
            sideMenuViewController.delegate = self
            sideMenuViewController.contentViewShadowColor = .darkGray
            sideMenuViewController.contentViewShadowOffset = CGSize(width: 0, height: 0)
            sideMenuViewController.contentViewShadowOpacity = 0.4
            sideMenuViewController.contentViewShadowRadius = 12
            sideMenuViewController.contentViewShadowEnabled = true
            self.window!.rootViewController = sideMenuViewController
        }
        
        //SOCIAL
        FirebaseApp.configure() //FIREBASE
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions) //FACEBOOK
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID //GOOGLE
        GIDSignIn.sharedInstance().delegate = self //GOOGLE
        Fabric.with([Twitter.self]) //TWITTER
        
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            self.shortcutItem = shortcutItem
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        saveData.set(deviceTokenString, forKey: "deviceTokenString")
        if saveData.string(forKey: "email") != nil {
            let email = saveData.string(forKey: "email")!
            let parameter = [
                "mail": email
                ] as [String : Any]
            Alamofire.request("https://api.mhint.eu/user/find", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in
                if let httpStatusCode = response.response?.statusCode {
                    if httpStatusCode == 200 {
                        let parameter = [
                            "mail": email,
                            "device_token": deviceTokenString
                            ] as [String : Any]
                        Alamofire.request("https://api.mhint.eu/deviceverify", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in
                            print("Device Token Send")
                        }
                    }
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        if application.applicationState == UIApplicationState.inactive || application.applicationState == UIApplicationState.background {
            var navigationController = UINavigationController()
            
            let layoutChat = UICollectionViewFlowLayout.init()
            layoutChat.sectionInset = UIEdgeInsetsMake(8, 0, 0, 0)
            layoutChat.itemSize = CGSize(width: GlobalSize().widthScreen, height: 100)
            let emergency = EmergencyController(collectionViewLayout: layoutChat)
            navigationController = UINavigationController(rootViewController: emergency)
            
            let leftMenuViewController = LeftMenuViewController()
            let rightMenuViewController = LeftMenuViewController()
            let sideMenuViewController: AKSideMenu = AKSideMenu(contentViewController: navigationController, leftMenuViewController: leftMenuViewController, rightMenuViewController: rightMenuViewController)
            sideMenuViewController.setContentViewController(UINavigationController.init(rootViewController: EmergencyController(collectionViewLayout: layout)), animated: true)
            
            sideMenuViewController.panGestureRightEnabled = false
            sideMenuViewController.menuPreferredStatusBarStyle = .lightContent
            sideMenuViewController.delegate = self
            sideMenuViewController.contentViewShadowColor = .darkGray
            sideMenuViewController.contentViewShadowOffset = CGSize(width: 0, height: 0)
            sideMenuViewController.contentViewShadowOpacity = 0.4
            sideMenuViewController.contentViewShadowRadius = 12
            sideMenuViewController.contentViewShadowEnabled = true
            self.window!.rootViewController = sideMenuViewController
            self.window!.backgroundColor = .white
            self.window?.makeKeyAndVisible()
        } else {
            let announcement = Announcement(title: String(describing:data["user"]!), subtitle: String(describing:data["text"]!),image: UIImage(named: "iconChat"), duration: 4, action: {
                var navigationController = UINavigationController()
                
                let layoutChat = UICollectionViewFlowLayout.init()
                layoutChat.sectionInset = UIEdgeInsetsMake(8, 0, 0, 0)
                layoutChat.itemSize = CGSize(width: GlobalSize().widthScreen, height: 100)
                let emergency = EmergencyController(collectionViewLayout: layoutChat)
                navigationController = UINavigationController(rootViewController: emergency)
                
                let leftMenuViewController = LeftMenuViewController()
                let rightMenuViewController = LeftMenuViewController()
                let sideMenuViewController: AKSideMenu = AKSideMenu(contentViewController: navigationController, leftMenuViewController: leftMenuViewController, rightMenuViewController: rightMenuViewController)
                sideMenuViewController.setContentViewController(UINavigationController.init(rootViewController: EmergencyController(collectionViewLayout: layout)), animated: true)
                
                sideMenuViewController.panGestureRightEnabled = false
                sideMenuViewController.menuPreferredStatusBarStyle = .lightContent
                sideMenuViewController.delegate = self
                sideMenuViewController.contentViewShadowColor = .darkGray
                sideMenuViewController.contentViewShadowOffset = CGSize(width: 0, height: 0)
                sideMenuViewController.contentViewShadowOpacity = 0.4
                sideMenuViewController.contentViewShadowRadius = 12
                sideMenuViewController.contentViewShadowEnabled = true
                self.window!.rootViewController = sideMenuViewController
                self.window!.backgroundColor = .white
                self.window?.makeKeyAndVisible()
            })
            Whisper.show(shout: announcement, to: (self.window?.rootViewController)!, completion: {})
        }
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
    
    //3DTOUCH
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler( handleShortcut(shortcutItem) )
    }
    
    func handleShortcut( _ shortcutItem:UIApplicationShortcutItem ) -> Bool {
        var succeeded = false
        if saveData.bool(forKey: "welcomeFinish0") {
            if(shortcutItem.type == "Mhint") {
                
                var navigationController = UINavigationController()
                
                let layoutChat = UICollectionViewFlowLayout.init()
                layoutChat.sectionInset = UIEdgeInsetsMake(8, 0, 0, 0)
                layoutChat.itemSize = CGSize(width: GlobalSize().widthScreen, height: 100)
                let emergency = ChatBotController(collectionViewLayout: layoutChat)
                navigationController = UINavigationController(rootViewController: emergency)
                
                let leftMenuViewController = LeftMenuViewController()
                let rightMenuViewController = LeftMenuViewController()
                let sideMenuViewController: AKSideMenu = AKSideMenu(contentViewController: navigationController, leftMenuViewController: leftMenuViewController, rightMenuViewController: rightMenuViewController)
                sideMenuViewController.setContentViewController(UINavigationController.init(rootViewController: emergency), animated: true)
                
                sideMenuViewController.panGestureRightEnabled = false
                sideMenuViewController.menuPreferredStatusBarStyle = .lightContent
                sideMenuViewController.delegate = self
                sideMenuViewController.contentViewShadowColor = .darkGray
                sideMenuViewController.contentViewShadowOffset = CGSize(width: 0, height: 0)
                sideMenuViewController.contentViewShadowOpacity = 0.4
                sideMenuViewController.contentViewShadowRadius = 12
                sideMenuViewController.contentViewShadowEnabled = true
                self.window!.rootViewController = sideMenuViewController
                self.window!.backgroundColor = .white
                self.window?.makeKeyAndVisible()
                
                succeeded = true
            }
            else if( shortcutItem.type == "Food" ) {
                
                var navigationController = UINavigationController()
                
                let layoutChat = UICollectionViewFlowLayout.init()
                layoutChat.sectionInset = UIEdgeInsetsMake(8, 0, 0, 0)
                layoutChat.itemSize = CGSize(width: GlobalSize().widthScreen, height: 100)
                let emergency = HomeFoodController(collectionViewLayout: layoutChat)
                navigationController = UINavigationController(rootViewController: emergency)
                
                let leftMenuViewController = LeftMenuViewController()
                let rightMenuViewController = LeftMenuViewController()
                let sideMenuViewController: AKSideMenu = AKSideMenu(contentViewController: navigationController, leftMenuViewController: leftMenuViewController, rightMenuViewController: rightMenuViewController)
                sideMenuViewController.setContentViewController(UINavigationController.init(rootViewController: emergency), animated: true)
                
                sideMenuViewController.panGestureRightEnabled = false
                sideMenuViewController.menuPreferredStatusBarStyle = .lightContent
                sideMenuViewController.delegate = self
                sideMenuViewController.contentViewShadowColor = .darkGray
                sideMenuViewController.contentViewShadowOffset = CGSize(width: 0, height: 0)
                sideMenuViewController.contentViewShadowOpacity = 0.4
                sideMenuViewController.contentViewShadowRadius = 12
                sideMenuViewController.contentViewShadowEnabled = true
                self.window!.rootViewController = sideMenuViewController
                self.window!.backgroundColor = .white
                self.window?.makeKeyAndVisible()
                succeeded = true
            }
            else if( shortcutItem.type == "Helps" ) {
                
                var navigationController = UINavigationController()
                
                let layoutChat = UICollectionViewFlowLayout.init()
                layoutChat.sectionInset = UIEdgeInsetsMake(8, 0, 0, 0)
                layoutChat.itemSize = CGSize(width: GlobalSize().widthScreen, height: 100)
                let emergency = EmergencyController(collectionViewLayout: layoutChat)
                navigationController = UINavigationController(rootViewController: emergency)
                
                let leftMenuViewController = LeftMenuViewController()
                let rightMenuViewController = LeftMenuViewController()
                let sideMenuViewController: AKSideMenu = AKSideMenu(contentViewController: navigationController, leftMenuViewController: leftMenuViewController, rightMenuViewController: rightMenuViewController)
                sideMenuViewController.setContentViewController(UINavigationController.init(rootViewController: emergency), animated: true)
                
                sideMenuViewController.panGestureRightEnabled = false
                sideMenuViewController.menuPreferredStatusBarStyle = .lightContent
                sideMenuViewController.delegate = self
                sideMenuViewController.contentViewShadowColor = .darkGray
                sideMenuViewController.contentViewShadowOffset = CGSize(width: 0, height: 0)
                sideMenuViewController.contentViewShadowOpacity = 0.4
                sideMenuViewController.contentViewShadowRadius = 12
                sideMenuViewController.contentViewShadowEnabled = true
                self.window!.rootViewController = sideMenuViewController
                self.window!.backgroundColor = .white
                self.window?.makeKeyAndVisible()
                succeeded = true
            }
            else if( shortcutItem.type == "Teaching" ) {
                
                var navigationController = UINavigationController()
                
                let layoutChat = UICollectionViewFlowLayout.init()
                layoutChat.sectionInset = UIEdgeInsetsMake(8, 0, 0, 0)
                layoutChat.itemSize = CGSize(width: GlobalSize().widthScreen, height: 100)
                let emergency = TeachingController()
                navigationController = UINavigationController(rootViewController: emergency)
                
                let leftMenuViewController = LeftMenuViewController()
                let rightMenuViewController = LeftMenuViewController()
                let sideMenuViewController: AKSideMenu = AKSideMenu(contentViewController: navigationController, leftMenuViewController: leftMenuViewController, rightMenuViewController: rightMenuViewController)
                sideMenuViewController.setContentViewController(UINavigationController.init(rootViewController: emergency), animated: true)
                
                sideMenuViewController.panGestureRightEnabled = false
                sideMenuViewController.menuPreferredStatusBarStyle = .lightContent
                sideMenuViewController.delegate = self
                sideMenuViewController.contentViewShadowColor = .darkGray
                sideMenuViewController.contentViewShadowOffset = CGSize(width: 0, height: 0)
                sideMenuViewController.contentViewShadowOpacity = 0.4
                sideMenuViewController.contentViewShadowRadius = 12
                sideMenuViewController.contentViewShadowEnabled = true
                self.window!.rootViewController = sideMenuViewController
                self.window!.backgroundColor = .white
                self.window?.makeKeyAndVisible()
                succeeded = true
            }
        }
        return succeeded
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        guard shortcutItem != nil else { return }
        handleShortcut(shortcutItem!)
        self.shortcutItem = nil
    }
    
}

