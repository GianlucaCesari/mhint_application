//
//  Food.swift
//  Mhint
//
//  Created by Andrea Merli on 20/04/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import UIKit
import Alamofire

class FoodController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    //CLASSI ESTERNE
    let globalColor = GlobalColor()
    let globalFunction = GlobalFunc()
    let cellId = "cellFood"
    var arrayImageHidden = [Bool]()
    let btnNextPage = UIButton()
    var arrayImageUrl = [String]()
    var arrayId = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        globalFunction.navBar(nav: navigationItem, s: self, show: true) //navigation bar
        GlobalFunc().navBarSubView(nav: navigationItem, s: self, title: "ALLERGIES")
        
        getImage()
        header()
        collectionViewFunc()
        
    }
    
    //GET IMAGE
    func getImage() {
        Alamofire.request("https://api.mhint.eu/getallergens", encoding: JSONEncoding.default).responseJSON { response in
            if let items = response.result.value as? [[String: Any]] {
                for item in items {
                    self.arrayImageUrl.append(item["img_url"]! as! String)
                    self.arrayId.append(item["_id"]! as! String)
                    if items.count == self.arrayImageUrl.count {
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
    }
    
    //COLLECTIONVIEW
    func collectionViewFunc() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
        let layoutHeight:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layoutHeight.sectionInset = UIEdgeInsetsMake(-50, 5, 0, 5)
        layoutHeight.scrollDirection = .vertical
        layoutHeight.itemSize = CGSize(width: GlobalSize().heightScreen*0.1, height: GlobalSize().heightScreen*0.1)
        collectionView?.collectionViewLayout = layoutHeight
        collectionView?.backgroundColor = .clear
        collectionView?.frame = CGRect(x: GlobalSize().widthScreen*0.1, y: GlobalSize().heightScreen*0.33, width: GlobalSize().widthScreen*0.8, height: GlobalSize().heightScreen*0.55)
        collectionView?.register(CustomCellChooseIngredient.self, forCellWithReuseIdentifier: cellId)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        nextPage()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayImageUrl.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCellChooseIngredient
        
        //LOADING
        cell.loadingBackground.frame = CGRect(x: 0, y: 0, width: GlobalSize().widthScreen*0.235-5, height: GlobalSize().widthScreen*0.2352-5)
        
        //IMMAGINE INGREDIENTI
        cell.imageIngredientBackground.frame = CGRect(x: 0, y: 0, width: GlobalSize().widthScreen*0.235-5, height: GlobalSize().widthScreen*0.235-5)
        cell.imageIngredientBackground.sd_setImage(with: URL(string: arrayImageUrl[indexPath.row]), placeholderImage: nil)
        
        //OVERLAY
        cell.overlayImageButton.frame = CGRect(x: 0, y: 0, width: GlobalSize().widthScreen*0.235-5, height: GlobalSize().widthScreen*0.235-5)

        if arrayImageHidden.count < (indexPath.row + 1) {
            arrayImageHidden.append(false)
        }
        
        var stringImage = String()
        stringImage = "overlayIngredientImage0"
        if arrayImageHidden.count > indexPath.row {
            if arrayImageHidden[indexPath.row] == true {
                stringImage = "overlayIngredientImage"
            }
        }
        
        let imageGreen = UIImage(named: stringImage)
        cell.overlayImageButton.image = imageGreen
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: GlobalSize().heightScreen*0.13, height: GlobalSize().heightScreen*0.13)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCellChooseIngredient
        
        var boolImage = Bool()
        var stringImage = String()
        if arrayImageHidden[indexPath.row] == true {
            boolImage = false
            stringImage = "overlayIngredientImage0"
        } else {
            boolImage = true
            stringImage = "overlayIngredientImage"
        }
        
        let imageGreen = UIImage(named: stringImage)
        cell.overlayImageButton.image = imageGreen
        arrayImageHidden[indexPath.row] = boolImage
        
    }
    //COLLECTIONVIEW
    
    //BOTTONE NEXT PAGE
    func nextPage() {
        btnNextPage.setTitle("Go to the next page", for: .normal)
        btnNextPage.setTitleColor(.black, for: .normal)
        btnNextPage.titleLabel?.font = UIFont(name: "AvenirLTStd-Heavy", size: GlobalSize().widthScreen*0.03)
        btnNextPage.titleLabel?.textAlignment = .center
        btnNextPage.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.92, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.05)
        btnNextPage.addTarget(self, action: #selector(goToDiet), for: .touchUpInside)
        self.view.addSubview(btnNextPage)
    }
    
    func goToDiet() {
        var arrayOk = [String]()
        var x:Int = 0
        for _ in arrayImageHidden {
            if arrayImageHidden[x] == true {
                arrayOk.append(arrayId[x])
            }
            x += 1
        }
        let parameter = [
            "mail": GlobalUser.email
            , "allergens": arrayOk
        ] as [String : Any]
        Alamofire.request("https://api.mhint.eu/userallergens", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in }
        
        let newViewController = DietController(collectionViewLayout: layout)
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func header() {
        GlobalFunc().titlePage(titlePage: "Food & Diet.", s: self)
        
        let description = UITextView()
        description.text = "We need to know if you are allergic to something.\nYou know, so we won't hurt you."
        description.textColor = self.globalColor.colorBlack
        description.isEditable = false
        description.font = UIFont(name: "AvenirLTStd-Medium", size: GlobalSize().widthScreen*0.04)
        description.frame = CGRect(x: GlobalSize().widthScreen*0.06, y: GlobalSize().heightScreen*0.18, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.1)
        self.view.addSubview(description)
        
        let titleListView = UILabel()
        titleListView.text = "CHOOSE THE ALLERGENS"
        titleListView.textColor = self.globalColor.colorBlack
        titleListView.textAlignment = .center
        titleListView.addTextSpacing()
        titleListView.font = UIFont(name: "AvenirLTStd-Black", size: GlobalSize().widthScreen*0.035)
        titleListView.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.27, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.1)
        self.view.addSubview(titleListView)
    }
    
}
