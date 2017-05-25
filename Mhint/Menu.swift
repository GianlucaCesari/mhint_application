//
//  Menu.swift
//  Mhint
//
//  Created by Andrea Merli on 19/04/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//
import UIKit

open class LeftMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let globalColor = GlobalColor()
    let user = GlobalUser()
    
    var tableView: UITableView?
    var titles: [String] = ["Food & Diet", "Needs & Emergency", "Teaching", "Settings", "Privacy Policy"]
    
    init() {
        super.init(nibName:nil, bundle:nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        navbar()
        
        imageBackgroundSet()
        
        let tableView: UITableView = UITableView.init(frame: CGRect(x: 0, y: (self.view.frame.size.height - 54 * 5) / 2.0, width: self.view.frame.size.width, height: 54 * 5), style: UITableViewStyle.plain)
        tableView.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin, UIViewAutoresizing.flexibleWidth]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isOpaque = false
        tableView.backgroundColor = .clear
        tableView.backgroundView = nil
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.bounces = false

        self.tableView = tableView
        self.tableView?.backgroundColor = .clear
        self.view.addSubview(self.tableView!)
    }
    
    func navbar() {
        
        let name = UILabel()
        name.text = saveData.value(forKey: "nameProfile") as! String?
        name.textColor = .black
        name.textAlignment = .left
        name.font = UIFont(name: "AvenirLTStd-Medium", size: 14)
        name.frame = CGRect(x:self.view.frame.width*0.05, y:0, width:self.view.frame.width, height: self.view.frame.height*0.1)
        self.view.addSubview(name)
        
        let btnChat = UIButton()
        btnChat.setTitle("v.a.", for: .normal)
        btnChat.setTitleColor(UIColor.black, for: .normal)
        btnChat.titleLabel?.font = UIFont(name: "AvenirLTStd-Medium", size: 12)
        btnChat.frame = CGRect(x: self.view.frame.width-(self.view.frame.width*0.14), y: 0, width: self.view.frame.width*0.12, height: self.view.frame.height*0.1)
        btnChat.addTarget(self, action: #selector(goToChat), for: .touchUpInside)
        self.view.addSubview(btnChat)
        
    }
    
    func goToChat() {
        self.sideMenuViewController!.setContentViewController(UINavigationController.init(rootViewController: ChatController(collectionViewLayout: layout)), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
    
    open func imageBackgroundSet() {
        var imgWave: UIImageView!
        let imgUrlLogo = UIImage(named: "wave")
        imgWave = UIImageView (image: imgUrlLogo)
        let marginTopImage = (view.frame.height*0.6)
        imgWave.frame = CGRect(x: 0, y: marginTopImage, width: view.frame.width, height: view.frame.width/2)
        imgWave.alpha = 0.3
        self.view.addSubview(imgWave)
    }
    
    // MARK: - <UITableViewDelegate>
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0: //HOME
            
                let foodView:UIViewController?
//                if saveData.bool(forKey: "HomeFood") == true {
//                    foodView = HomeFoodController(collectionViewLayout: layout)
//                } else {
                    foodView = FoodController(collectionViewLayout: layout)
//                }
                self.sideMenuViewController!.setContentViewController(UINavigationController.init(rootViewController: foodView!), animated: true)
                self.sideMenuViewController!.hideMenuViewController()
            
            case 1:
                self.sideMenuViewController!.setContentViewController(UINavigationController.init(rootViewController: EmergencyController()), animated: true)
                self.sideMenuViewController!.hideMenuViewController()
            
            case 2:
                self.sideMenuViewController!.setContentViewController(UINavigationController.init(rootViewController: TeachingController()), animated: true)
                self.sideMenuViewController!.hideMenuViewController()
            
            case 3:
                let settingsView = SettingsController(collectionViewLayout: layout)
                self.sideMenuViewController!.setContentViewController(UINavigationController.init(rootViewController: settingsView), animated: true)
                self.sideMenuViewController!.hideMenuViewController()
            
            case 4:
                self.sideMenuViewController!.setContentViewController(UINavigationController.init(rootViewController: MhintController()), animated: true)
                self.sideMenuViewController!.hideMenuViewController()
            
            default:
                break
        }
    }
    
    // MARK: - <UITableViewDataSource>
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54 //HEIGHT LIST ITEM
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        return titles.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier: String = "Cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
            cell!.backgroundColor = UIColor.clear
            cell!.textLabel?.font = UIFont.init(name: "AvenirLTStd-Heavy", size: 18)
            cell!.textLabel?.textColor = .black
            cell!.textLabel?.highlightedTextColor = UIColor.black
            cell!.selectedBackgroundView = UIView.init()
        }
        
        cell!.textLabel?.text = titles[(indexPath as NSIndexPath).row]
        return cell!
    }
}
