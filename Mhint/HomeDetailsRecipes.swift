//
//  DetailsRecipes.swift
//  Mhint
//
//  Created by Andrea Merli on 26/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import UIKit

//GIF
import SwiftyGif
import Alamofire

class DetailsRecipesController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate{
    
    let cellId = "cellDetailsRecipes"
    
    var titleRecipesAPI = ""
    var descriptionRecipes = ""
    var imageRecipes = ""
    var sectionTitlearray = ["Nutritional value", "ingredients", "Description"]
    
    var descriptionNutritionalValue = [String]()
    var quantityNutritionalValue = [String]()
    
    var descriptionIngredients = [String]()
    var quantityIngredients = [String]()
    
    let heightCellSection = GlobalSize().widthScreen*0.1
    var heightCellDescription = GlobalSize().widthScreen*0.98
    let heightCell = GlobalSize().widthScreen*0.15
    let widthCollectionView = GlobalSize().widthScreen
    
    override func viewDidLoad() {
        
        let btnMenu = UIButton.init(type: .custom)
        let imgMenu = UIImage(named: "arrowLeftWhite")
        btnMenu.frame = CGRect(x: 0, y: 20, width: GlobalSize().sizeIconMenuBar, height: GlobalSize().sizeIconMenuBar)
        btnMenu.setImage(imgMenu, for: .normal)
        btnMenu.addTarget(self, action: #selector(self.back(sender:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnMenu)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.navigationController?.navigationBar.barTintColor = .clear
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        self.view.backgroundColor = GlobalColor().backgroundCollectionView
        UIApplication.shared.statusBarView?.backgroundColor = .clear
        UIApplication.shared.statusBarView?.tintColor = .white
        self.modalPresentationCapturesStatusBarAppearance = true
        UIApplication.shared.statusBarStyle = .lightContent
        
        getDetails()
        
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
        
    }
    
    func getDetails() {
        Alamofire.request("https://api.mhint.eu/recipe?id=\(idDetailsRecipes)", encoding: JSONEncoding.default).responseJSON { JSON in
            if let result = JSON.result.value as? [String: Any] {
                
                print("Result: ", result)
                
                self.imageRecipes = result["img_url"] as! String
                self.titleRecipesAPI = result["title"] as! String
                self.descriptionRecipes = result["instructions"] as! String
                
                
                if let items = result["ingredients"] as? [[String: Any]] {
                    for item in items {
                        print(item)
                        self.quantityIngredients.append("\(String(describing: item["amount"]!)) \(String(describing: item["unit"]!))")
                        if let name = item["food"] as? [String: Any] {
                            self.descriptionIngredients.append(name["name"] as! String)
                        }
                    }
                }
                
                if let items = result["nutrients"] as? [[String: Any]] {
                    for item in items {
                        self.descriptionNutritionalValue.append(item["title"] as! String)
                        self.quantityNutritionalValue.append("\(String(describing: item["amount"]!)) \(String(describing: item["unit"]!))")
                    }
                }
                
                self.sectionTitlearray = ["Nutritional value", "ingredients", "Description"]
                
                self.videoRecipes()
                self.collectionView?.reloadData()
            }
        }
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
            cell.titleSection.frame = CGRect(x: GlobalSize().widthScreen*0.06, y: (heightCell-GlobalSize().heightScreen*0.07)/2, width: GlobalSize().widthScreen*0.36, height: GlobalSize().heightScreen*0.07)
        } else if indexPath.row == 1 {
            cell.lineTitleSection.alpha = 0
            cell.titleSection.alpha = 0
            
            let marginRow = GlobalSize().widthScreen*0.01
            let widthRow = widthCollectionView/4 - (marginRow)
            
            var row1 = String()
            var row2 = String()
            var row3 = String()
            var row4 = String()
            
            for x in 0..<descriptionNutritionalValue.count {
                if x % 2 != 0 {
                    row3 = "\(row3) \(descriptionNutritionalValue[x])\n"
                    row4 = "\(row4) \(quantityNutritionalValue[x])\n"
                } else {
                    row1 = "\(row1) \(descriptionNutritionalValue[x])\n"
                    row2 = "\(row2) \(quantityNutritionalValue[x])\n"
                }
            }
            
            cell.labelRow1.text = row1
            cell.labelRow2.text = row2
            cell.labelRow3.text = row3
            cell.labelRow4.text = row4
            
            let heightFrameRow1 = NSString(string: row1).boundingRect(with: CGSize(width: widthRow, height: GlobalSize().heightScreen*10), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20)], context: nil)
            let heightFrameRow2 = NSString(string: row2).boundingRect(with: CGSize(width: widthRow, height: GlobalSize().heightScreen*10), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20)], context: nil)
            let heightFrameRow3 = NSString(string: row3).boundingRect(with: CGSize(width: widthRow, height: GlobalSize().heightScreen*10), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20)], context: nil)
            let heightFrameRow4 = NSString(string: row4).boundingRect(with: CGSize(width: widthRow, height: GlobalSize().heightScreen*10), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20)], context: nil)
            
            cell.labelRow1.frame = CGRect(x: marginRow*2, y: 20, width: widthRow, height: heightFrameRow1.height+marginRow*2)
            cell.labelRow2.frame = CGRect(x: widthRow+marginRow*2, y: 20, width: widthRow, height: heightFrameRow2.height+marginRow*2)
            cell.labelRow3.frame = CGRect(x: widthRow*2+marginRow*2, y: 20, width: widthRow, height: heightFrameRow3.height+marginRow*2)
            cell.labelRow4.frame = CGRect(x: widthRow*3+marginRow*2, y: 20, width: widthRow, height: heightFrameRow4.height+marginRow*2)
            
        } else if indexPath.row == 2 {
            cell.titleSection.text = sectionTitlearray[1].uppercased()
            cell.lineTitleSection.frame = CGRect(x: 0, y: (heightCell-2)/2, width: GlobalSize().widthScreen, height: 2)
            cell.lineTitleSection.backgroundColor = .black
            cell.lineTitleSection.alpha = 0.4
            cell.titleSection.frame = CGRect(x: GlobalSize().widthScreen*0.06, y: (heightCell-GlobalSize().heightScreen*0.07)/2, width: GlobalSize().widthScreen*0.26, height: GlobalSize().heightScreen*0.07)
        } else if indexPath.row == 3 {
            cell.lineTitleSection.alpha = 0
            cell.titleSection.alpha = 0
            
            let marginRow = GlobalSize().widthScreen*0.01
            let widthRow = widthCollectionView/4 - (marginRow)
            
            var row1 = String()
            var row2 = String()
            var row3 = String()
            var row4 = String()
            
            for x in 0..<descriptionIngredients.count {
                if x % 2 != 0 {
                    row3 = "\(row3) \(descriptionIngredients[x])\n"
                    row4 = "\(row4) \(quantityIngredients[x])\n"
                } else {
                    row1 = "\(row1) \(descriptionIngredients[x])\n"
                    row2 = "\(row2) \(quantityIngredients[x])\n"
                }
            }
            
            cell.labelRow1.text = row1
            cell.labelRow2.text = row2
            cell.labelRow3.text = row3
            cell.labelRow4.text = row4
            
            let heightFrameRow1 = NSString(string: row1).boundingRect(with: CGSize(width: widthRow, height: GlobalSize().heightScreen*10), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20)], context: nil)
            let heightFrameRow2 = NSString(string: row2).boundingRect(with: CGSize(width: widthRow, height: GlobalSize().heightScreen*10), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20)], context: nil)
            let heightFrameRow3 = NSString(string: row3).boundingRect(with: CGSize(width: widthRow, height: GlobalSize().heightScreen*10), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20)], context: nil)
            let heightFrameRow4 = NSString(string: row4).boundingRect(with: CGSize(width: widthRow, height: GlobalSize().heightScreen*10), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20)], context: nil)
            
            cell.labelRow1.frame = CGRect(x: marginRow*2, y: 20, width: widthRow, height: heightFrameRow1.height+marginRow*2)
            cell.labelRow2.frame = CGRect(x: widthRow+marginRow*2, y: 20, width: widthRow, height: heightFrameRow2.height+marginRow*2)
            cell.labelRow3.frame = CGRect(x: widthRow*2+marginRow*2, y: 20, width: widthRow, height: heightFrameRow3.height+marginRow*2)
            cell.labelRow4.frame = CGRect(x: widthRow*3+marginRow*2, y: 20, width: widthRow, height: heightFrameRow4.height+marginRow*2)
            
        } else if indexPath.row == 4 {
            cell.titleSection.text = sectionTitlearray[2].uppercased()
            cell.lineTitleSection.frame = CGRect(x: 0, y: (heightCell-2)/2, width: GlobalSize().widthScreen, height: 2)
            cell.lineTitleSection.backgroundColor = .black
            cell.lineTitleSection.alpha = 0.4
            cell.titleSection.frame = CGRect(x: GlobalSize().widthScreen*0.06, y: (heightCell-GlobalSize().heightScreen*0.07)/2, width: GlobalSize().widthScreen*0.26, height: GlobalSize().heightScreen*0.07)
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
        } else if indexPath.row == 1 || indexPath.row == 3 {
            
            var row1 = String()
            
            for x in 0..<descriptionNutritionalValue.count {
                if x % 2 == 0 {
                    row1 = "\(row1) \(descriptionNutritionalValue[x])\n"
                }
            }
            
            let heightFrameRow1 = NSString(string: row1).boundingRect(with: CGSize(width: widthCollectionView/4, height: GlobalSize().heightScreen*10), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)], context: nil)
            
            return CGSize(width: widthCollectionView, height: (heightFrameRow1.height + GlobalSize().heightScreen*0.03))
            
        } else if indexPath.row == 5 {
            let heightFrame = NSString(string: descriptionRecipes).boundingRect(with: CGSize(width: GlobalSize().widthScreen*0.88, height: GlobalSize().heightScreen*10), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)], context: nil)
            return CGSize(width: widthCollectionView, height: (heightFrame.height + GlobalSize().heightScreen*0.07))
        } else {
            return CGSize(width: widthCollectionView, height: heightCell)
        }
    }
    
    func videoRecipes() {
        
        let imageLoadingView = UIImageView(gifImage: UIImage(gifName: "load"), manager: SwiftyGifManager(memoryLimit:20))
        imageLoadingView.frame = CGRect(x: GlobalSize().widthScreen-GlobalSize().widthScreen*0.561/2, y: 0, width: GlobalSize().widthScreen*0.561, height: GlobalSize().widthScreen*0.561)
        self.view.addSubview(imageLoadingView)
        
        let previewVideo = UIImageView()
        previewVideo.sd_setImage(with: URL(string: imageRecipes), placeholderImage: nil)
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
        titleRecipes.text = titleRecipesAPI
        titleRecipes.textAlignment = .center
        titleRecipes.font = UIFont(name: "AvenirLTStd-Heavy", size: GlobalSize().widthScreen*0.05)
        titleRecipes.textColor = .white
        titleRecipes.frame = CGRect(x: 0, y: GlobalSize().widthScreen*0.15, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.1)
        self.view.addSubview(titleRecipes)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
    
    
    func back(sender: UIBarButtonItem) {
        
        UIApplication.shared.statusBarView?.backgroundColor = .white
        UIApplication.shared.statusBarView?.tintColor = .black
        self.modalPresentationCapturesStatusBarAppearance = false
        UIApplication.shared.statusBarStyle = .default
        
        _ = navigationController?.popViewController(animated: true)
    }
}
