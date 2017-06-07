//
//  EatOut.swift
//  Mhint
//
//  Created by Andrea Merli on 22/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import UIKit

class EatOutController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    let cellId = "cellEatOut"
    
    let heightCell = GlobalSize().widthScreen*0.15
    let widthCollectionView = GlobalSize().widthScreen*0.8
    
    let daysInWeek = ["1-2 days", "3-4 days", "5-6 days", "Every lunch", "week-end dinners", "Breakfast out"]
    
    var arrayImageHidden = [Bool]()
    let btnNextPage = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        GlobalFunc().navBarSubView(nav: navigationItem, s: self, title: "EAT OUT")
        header()
        
        let btnMenu = UIButton.init(type: .custom)
        let imgMenu = UIImage(named: "arrowLeft")
        btnMenu.frame = CGRect(x: 0, y: 0, width: GlobalSize().sizeIconMenuBar, height: GlobalSize().sizeIconMenuBar)
        btnMenu.setImage(imgMenu, for: .normal)
        btnMenu.addTarget(self, action: #selector(self.back(sender:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnMenu)
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 2
        layout.sectionInset = UIEdgeInsetsMake(-50, 0, 0, 0)
        layout.itemSize = CGSize(width: widthCollectionView, height: heightCell)
        collectionView?.collectionViewLayout = layout
        collectionView?.backgroundColor = .white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.frame = CGRect(x: GlobalSize().widthScreen*0.1, y: GlobalSize().heightScreen*0.33, width: widthCollectionView, height: GlobalSize().heightScreen*0.52)
        collectionView?.register(CustomCellChooseEatOut.self, forCellWithReuseIdentifier: cellId)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
    
    
    //COLLECTIONVIEW
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInWeek.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCellChooseEatOut
        
        cell.titleDiet.text = daysInWeek[indexPath.row].capitalized
        cell.titleDiet.frame = CGRect(x: heightCell+(heightCell/2)-20, y: 0, width: widthCollectionView, height: heightCell)
        
        cell.checkImageBtn.frame = CGRect(x: heightCell*0.1, y: heightCell*0.15, width: heightCell*0.8, height: heightCell*0.8)
        
        if arrayImageHidden.count < (indexPath.row + 1) {
            arrayImageHidden.append(false)
        }
        var stringImage = String()
        stringImage = "check-false"
        if arrayImageHidden.count > indexPath.row {
            if arrayImageHidden[indexPath.row] == true {
                stringImage = "check-true"
            }
        }

        let imageGreen = UIImage(named: stringImage)
        cell.checkImageBtn.image = imageGreen
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: widthCollectionView, height: heightCell)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for x in 0..<arrayImageHidden.count {
            if let cell = collectionView.cellForItem(at: IndexPath(row: x, section: 0)) as? CustomCellChooseEatOut {
                let imageGreen = UIImage(named: "check-false")
                cell.checkImageBtn.image = imageGreen
            }
            arrayImageHidden[x] = false
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCellChooseEatOut
        
        var boolImage = Bool()
        if arrayImageHidden[indexPath.row] == true {
            boolImage = false
        } else {
            boolImage = true
        }
        
        
        let imageGreen = UIImage(named: "check-true")
        cell.checkImageBtn.image = imageGreen
        
        arrayImageHidden[indexPath.row] = boolImage
        
        nextPage()
        
    }
    //COLLECTIONVIEW
    
    //BOTTONE NEXT PAGE
    func nextPage() {
        var boolNextPage = false
        for x in arrayImageHidden {
            if x {
                btnNextPage.setTitle("Go to the next page", for: .normal)
                btnNextPage.setTitleColor(.black, for: .normal)
                btnNextPage.titleLabel?.font = UIFont(name: "AvenirLTStd-Heavy", size: GlobalSize().widthScreen*0.03)
                btnNextPage.titleLabel?.textAlignment = .center
                btnNextPage.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.92, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.05)
                btnNextPage.addTarget(self, action: #selector(goToDiet), for: .touchUpInside)
                self.view.addSubview(btnNextPage)
                boolNextPage = true
            }
        }
        if !boolNextPage {
            btnNextPage.removeFromSuperview()
        }
    }
    
    func goToDiet() {
        print("L'utente: ", GlobalUser.email, " ha gradito: ", arrayImageHidden)
        let newViewController = ListRecipesController(collectionViewLayout: layout)
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    //HEADER
    func header() {
        GlobalFunc().titlePage(titlePage: "Food & Diet.", s: self)
        
        let description = UITextView()
        description.text = "You can't possibly eat everyday at home."
        description.textColor = GlobalColor().colorBlack
        description.isEditable = false
        description.font = UIFont(name: "AvenirLTStd-Medium", size: GlobalSize().widthScreen*0.04)
        description.frame = CGRect(x: GlobalSize().widthScreen*0.06, y: GlobalSize().heightScreen*0.18, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.1)
        self.view.addSubview(description)
        
        
        let titleListView = UILabel()
        titleListView.text = "How many days do you eat out?".uppercased()
        titleListView.textColor = GlobalColor().colorBlack
        titleListView.textAlignment = .center
        titleListView.addTextSpacing()
        titleListView.font = UIFont(name: "AvenirLTStd-Black", size: GlobalSize().widthScreen*0.035)
        titleListView.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.27, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.1)
        self.view.addSubview(titleListView)
    }
    
    func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
