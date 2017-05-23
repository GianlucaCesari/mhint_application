//
//  Diet.swift
//  Mhint
//
//  Created by Andrea Merli on 20/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import UIKit

class DietController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    let cellId = "cellDiet"
    let heightCell = GlobalSize().widthScreen*0.44
    var arrayImageHidden = [Bool]()
    let btnNextPage = UIButton()
    var arrayImageUrl = ["http://www.zcscompany.com/images/uploads/news/Food_Social.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg", "http://www.getintofitnesstoday.net/wp-content/uploads/2016/12/Food-for-thought-1024x512.jpg","http://www.zcscompany.com/images/uploads/news/Food_Social.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg", "http://www.getintofitnesstoday.net/wp-content/uploads/2016/12/Food-for-thought-1024x512.jpg","http://www.zcscompany.com/images/uploads/news/Food_Social.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg", "http://www.getintofitnesstoday.net/wp-content/uploads/2016/12/Food-for-thought-1024x512.jpg", "http://www.getintofitnesstoday.net/wp-content/uploads/2016/12/Food-for-thought-1024x512.jpg","http://www.zcscompany.com/images/uploads/news/Food_Social.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg", "http://www.getintofitnesstoday.net/wp-content/uploads/2016/12/Food-for-thought-1024x512.jpg","http://www.zcscompany.com/images/uploads/news/Food_Social.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg", "http://www.getintofitnesstoday.net/wp-content/uploads/2016/12/Food-for-thought-1024x512.jpg", "http://www.getintofitnesstoday.net/wp-content/uploads/2016/12/Food-for-thought-1024x512.jpg","http://www.zcscompany.com/images/uploads/news/Food_Social.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg", "http://www.getintofitnesstoday.net/wp-content/uploads/2016/12/Food-for-thought-1024x512.jpg","http://www.zcscompany.com/images/uploads/news/Food_Social.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg", "http://www.getintofitnesstoday.net/wp-content/uploads/2016/12/Food-for-thought-1024x512.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        GlobalFunc().navBarSubView(nav: navigationItem, s: self, title: "DIET")
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
        layout.itemSize = CGSize(width: heightCell, height: heightCell)
        collectionView?.collectionViewLayout = layout
        collectionView?.backgroundColor = .white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.frame = CGRect(x: GlobalSize().widthScreen*0.05, y: GlobalSize().heightScreen*0.33, width: GlobalSize().widthScreen*0.9, height: GlobalSize().heightScreen*0.52)
        collectionView?.register(CustomCellChooseDiet.self, forCellWithReuseIdentifier: cellId)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
    
    //COLLECTIONVIEW
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCellChooseDiet
        
        let marginPhoto:CGFloat = 10
        
        //LOADING
        let marginLoading:CGFloat = ((heightCell-marginPhoto)-GlobalSize().widthScreen*0.2)/2 + (marginPhoto/2)
        cell.loadingBackground.frame = CGRect(x: marginLoading, y: 0, width: GlobalSize().widthScreen*0.2, height: GlobalSize().widthScreen*0.2)
        
        cell.imageIngredientBackground.sd_setImage(with: URL(string: arrayImageUrl[indexPath.row]), placeholderImage: nil)
        cell.imageIngredientBackground.frame = CGRect(x: marginPhoto/2, y: 0, width: heightCell-marginPhoto, height: GlobalSize().widthScreen*0.2)
        cell.overlayImageButton.frame = CGRect(x: marginPhoto/2, y: 0, width: heightCell-marginPhoto, height: GlobalSize().widthScreen*0.2)
        
        cell.titleDiet.text = "italian style".uppercased()
        cell.titleDiet.addTextSpacing()
        cell.titleDiet.frame = CGRect(x: marginPhoto/2, y: GlobalSize().widthScreen*0.225, width: heightCell-marginPhoto, height: GlobalSize().widthScreen*0.04)
        
        cell.calorieDiet.text = ("Calorie medie: 45kcal").capitalized
        cell.calorieDiet.frame = CGRect(x: marginPhoto/2, y: GlobalSize().widthScreen*0.27, width: heightCell-marginPhoto, height: GlobalSize().widthScreen*0.04)
        
        cell.ingridientDiet.numberOfLines = 2
        cell.ingridientDiet.text = "Latte, Yogurt, Cereali,\nCaffe, Te..."
        cell.ingridientDiet.frame = CGRect(x: marginPhoto/2, y: GlobalSize().widthScreen*0.315, width: heightCell-marginPhoto, height: GlobalSize().widthScreen*0.1)
        
        if arrayImageHidden.count < (indexPath.row + 1) {
            arrayImageHidden.append(false)
        }
        var stringImage = String()
        if arrayImageHidden[indexPath.row] == true {
            stringImage = "overlayDietImage"
        } else {
            stringImage = "overlayIngredientImage0"
        }
        
        let imageGreen = UIImage(named: stringImage)
        cell.overlayImageButton.image = imageGreen
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: heightCell, height: heightCell)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCellChooseDiet
        
        var boolImage = Bool()
        var stringImage = String()
        if arrayImageHidden[indexPath.row] == true {
            boolImage = false
            stringImage = "overlayIngredientImage0"
        } else {
            boolImage = true
            stringImage = "overlayDietImage"
        }
        
        let imageGreen = UIImage(named: stringImage)
        cell.overlayImageButton.image = imageGreen
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
        let newViewController = EatOutController(collectionViewLayout: layout)
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    func header() {
        GlobalFunc().titlePage(titlePage: "Food & Diet.", s: self)
        
        let description = UILabel()
        description.text = "Welcome on Food & Diet section\nHelp you to make\nCiao!"
        description.textColor = GlobalColor().colorBlack
        description.numberOfLines = 3
        description.font = UIFont(name: "AvenirLTStd-Medium", size: GlobalSize().widthScreen*0.04)
        description.frame = CGRect(x: GlobalSize().widthScreen*0.06, y: GlobalSize().heightScreen*0.18, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.1)
        self.view.addSubview(description)
        
        
        let titleListView = UILabel()
        titleListView.text = "SELECT SOME DIET"
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
