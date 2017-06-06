//
//  Food.swift
//  Mhint
//
//  Created by Andrea Merli on 20/04/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import UIKit

class FoodController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    //CLASSI ESTERNE
    let globalColor = GlobalColor()
    let globalFunction = GlobalFunc()
    let cellId = "cellFood"
    var arrayImageHidden = [Bool]()
    let btnNextPage = UIButton()
    var arrayImageUrl = ["https://static.webshopapp.com/shops/117992/files/074289974/fragola-sciroppo-di-frutta.jpg", "http://2.bp.blogspot.com/-io5eUZyG3r4/UVsHVJE1m5I/AAAAAAAAAB0/TS6rpkOefuI/s1600/apples.jpg", "https://cdn.shopify.com/s/files/1/1266/3527/products/pears-imported_1024x1024.jpg?v=1464591452","https://cdn.shopify.com/s/files/1/1294/9917/products/mysore_bananas_-_miami_fruit_Cropped_1024x1024.jpg?v=1473362182", "https://static.webshopapp.com/shops/117992/files/074295791/mango-fruit-syrup.jpg", "http://cdn.shopify.com/s/files/1/0320/6761/products/vanilla_98d03448-4699-4754-b275-9d211246cd7c_1024x1024.jpeg?v=1459328219", "http://www.labottegadiviola.it/img_up/big/20161104134546-504.jpg", "https://cdn.shopify.com/s/files/1/1090/0504/products/shutterstock_189958823-OldCheddar.jpg?v=1457202813", "http://blogs.kcrw.com/goodfood/wp-content/uploads/2013/04/Avocado-1024x1024.jpg", "https://cdn.shopify.com/s/files/1/1143/3886/products/cucumber_1024x1024.jpg?v=1485981121", "https://cdn.shopify.com/s/files/1/0999/8746/products/brizilian10x10_1024x1024.jpg?v=1454165753", "http://static3.depositphotos.com/1005951/225/i/950/depositphotos_2252831-stock-photo-potato-pattern.jpg","https://static.webshopapp.com/shops/117992/files/074289974/fragola-sciroppo-di-frutta.jpg", "http://2.bp.blogspot.com/-io5eUZyG3r4/UVsHVJE1m5I/AAAAAAAAAB0/TS6rpkOefuI/s1600/apples.jpg", "https://static.webshopapp.com/shops/117992/files/074291696/pineapple-fruit-syrup.jpg", "https://cdn.shopify.com/s/files/1/1266/3527/products/pears-imported_1024x1024.jpg?v=1464591452","https://cdn.shopify.com/s/files/1/1294/9917/products/mysore_bananas_-_miami_fruit_Cropped_1024x1024.jpg?v=1473362182", "https://static.webshopapp.com/shops/117992/files/074295791/mango-fruit-syrup.jpg", "http://cdn.shopify.com/s/files/1/0320/6761/products/vanilla_98d03448-4699-4754-b275-9d211246cd7c_1024x1024.jpeg?v=1459328219", "http://www.labottegadiviola.it/img_up/big/20161104134546-504.jpg", "https://cdn.shopify.com/s/files/1/1090/0504/products/shutterstock_189958823-OldCheddar.jpg?v=1457202813", "http://blogs.kcrw.com/goodfood/wp-content/uploads/2013/04/Avocado-1024x1024.jpg", "https://cdn.shopify.com/s/files/1/1143/3886/products/cucumber_1024x1024.jpg?v=1485981121", "https://cdn.shopify.com/s/files/1/0999/8746/products/brizilian10x10_1024x1024.jpg?v=1454165753","https://cdn.shopify.com/s/files/1/1294/9917/products/mysore_bananas_-_miami_fruit_Cropped_1024x1024.jpg?v=1473362182", "https://static.webshopapp.com/shops/117992/files/074295791/mango-fruit-syrup.jpg", "http://cdn.shopify.com/s/files/1/0320/6761/products/vanilla_98d03448-4699-4754-b275-9d211246cd7c_1024x1024.jpeg?v=1459328219", "http://www.labottegadiviola.it/img_up/big/20161104134546-504.jpg", "https://cdn.shopify.com/s/files/1/1090/0504/products/shutterstock_189958823-OldCheddar.jpg?v=1457202813", "http://blogs.kcrw.com/goodfood/wp-content/uploads/2013/04/Avocado-1024x1024.jpg", "https://cdn.shopify.com/s/files/1/1143/3886/products/cucumber_1024x1024.jpg?v=1485981121", "https://cdn.shopify.com/s/files/1/0999/8746/products/brizilian10x10_1024x1024.jpg?v=1454165753","https://cdn.shopify.com/s/files/1/1294/9917/products/mysore_bananas_-_miami_fruit_Cropped_1024x1024.jpg?v=1473362182", "https://static.webshopapp.com/shops/117992/files/074295791/mango-fruit-syrup.jpg", "http://cdn.shopify.com/s/files/1/0320/6761/products/vanilla_98d03448-4699-4754-b275-9d211246cd7c_1024x1024.jpeg?v=1459328219", "http://www.labottegadiviola.it/img_up/big/20161104134546-504.jpg", "https://cdn.shopify.com/s/files/1/1090/0504/products/shutterstock_189958823-OldCheddar.jpg?v=1457202813", "http://blogs.kcrw.com/goodfood/wp-content/uploads/2013/04/Avocado-1024x1024.jpg", "https://cdn.shopify.com/s/files/1/1143/3886/products/cucumber_1024x1024.jpg?v=1485981121", "https://cdn.shopify.com/s/files/1/0999/8746/products/brizilian10x10_1024x1024.jpg?v=1454165753","https://cdn.shopify.com/s/files/1/1294/9917/products/mysore_bananas_-_miami_fruit_Cropped_1024x1024.jpg?v=1473362182", "https://static.webshopapp.com/shops/117992/files/074295791/mango-fruit-syrup.jpg", "http://cdn.shopify.com/s/files/1/0320/6761/products/vanilla_98d03448-4699-4754-b275-9d211246cd7c_1024x1024.jpeg?v=1459328219", "http://www.labottegadiviola.it/img_up/big/20161104134546-504.jpg", "https://cdn.shopify.com/s/files/1/1090/0504/products/shutterstock_189958823-OldCheddar.jpg?v=1457202813", "http://blogs.kcrw.com/goodfood/wp-content/uploads/2013/04/Avocado-1024x1024.jpg", "https://cdn.shopify.com/s/files/1/1143/3886/products/cucumber_1024x1024.jpg?v=1485981121", "https://cdn.shopify.com/s/files/1/0999/8746/products/brizilian10x10_1024x1024.jpg?v=1454165753","https://cdn.shopify.com/s/files/1/1294/9917/products/mysore_bananas_-_miami_fruit_Cropped_1024x1024.jpg?v=1473362182", "https://static.webshopapp.com/shops/117992/files/074295791/mango-fruit-syrup.jpg", "http://cdn.shopify.com/s/files/1/0320/6761/products/vanilla_98d03448-4699-4754-b275-9d211246cd7c_1024x1024.jpeg?v=1459328219", "http://www.labottegadiviola.it/img_up/big/20161104134546-504.jpg", "https://cdn.shopify.com/s/files/1/1090/0504/products/shutterstock_189958823-OldCheddar.jpg?v=1457202813", "http://blogs.kcrw.com/goodfood/wp-content/uploads/2013/04/Avocado-1024x1024.jpg", "https://cdn.shopify.com/s/files/1/1143/3886/products/cucumber_1024x1024.jpg?v=1485981121", "https://cdn.shopify.com/s/files/1/0999/8746/products/brizilian10x10_1024x1024.jpg?v=1454165753"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        globalFunction.navBar(nav: navigationItem, s: self, show: true) //navigation bar
        
        header()
        collectionViewFunc()
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
        return 30
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
        print("L'utente: ", GlobalUser.email, " ha gradito: ", arrayImageHidden)
        let newViewController = DietController(collectionViewLayout: layout)
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func header() {
        GlobalFunc().titlePage(titlePage: "Food & Diet.", s: self)
        
        let description = UILabel()
        description.text = "Welcome on Food & Diet section\nHelp you to make\nCiao!"
        description.textColor = self.globalColor.colorBlack
        description.numberOfLines = 3
        description.font = UIFont(name: "AvenirLTStd-Medium", size: GlobalSize().widthScreen*0.04)
        description.frame = CGRect(x: GlobalSize().widthScreen*0.06, y: GlobalSize().heightScreen*0.18, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.1)
        self.view.addSubview(description)
        
        let titleListView = UILabel()
        titleListView.text = "SELEZIONA I TUOI CIBI PREFERITI"
        titleListView.textColor = self.globalColor.colorBlack
        titleListView.textAlignment = .center
        titleListView.addTextSpacing()
        titleListView.font = UIFont(name: "AvenirLTStd-Black", size: GlobalSize().widthScreen*0.035)
        titleListView.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.27, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.1)
        self.view.addSubview(titleListView)
    }
    
}
