//
//  Diet.swift
//  Mhint
//
//  Created by Andrea Merli on 20/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import UIKit
import Alamofire

class DietController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    let cellId = "cellDiet"
    let heightCell = GlobalSize().widthScreen*0.44
    var arrayImageHidden = [Bool]()
    let btnNextPage = UIButton()
    
    var idClick = ""
    
    var arrayImageUrl = [String]()
    var arrayId = [String]()
    var arrayName = [String]()
    var arrayDescription = [String]()
    var arrayKcal = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        GlobalFunc().navBarSubView(nav: navigationItem, s: self, title: "DIET")
        header()
        getImage()
        
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
    
    
    func getImage() {
        Alamofire.request("https://api.mhint.eu/getdiets", encoding: JSONEncoding.default).responseJSON { response in
            if let items = response.result.value as? [[String: Any]] {
                for item in items {
                    self.arrayImageUrl.append(item["img_url"]! as! String)
                    self.arrayId.append(item["_id"]! as! String)
                    self.arrayName.append(item["name"]! as! String)
                    self.arrayDescription.append(item["description"]! as! String)
                    self.arrayKcal.append(item["kcal"]! as! String)
                    if items.count == self.arrayImageUrl.count {
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
    }
    
    //COLLECTIONVIEW
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayImageUrl.count
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
        
        cell.titleDiet.text = arrayName[indexPath.row].uppercased()
        cell.titleDiet.addTextSpacing()
        cell.titleDiet.frame = CGRect(x: marginPhoto/2, y: GlobalSize().widthScreen*0.225, width: heightCell-marginPhoto, height: GlobalSize().widthScreen*0.04)
        
        cell.calorieDiet.text = (arrayKcal[indexPath.row]).capitalized
        cell.calorieDiet.frame = CGRect(x: marginPhoto/2, y: GlobalSize().widthScreen*0.27, width: heightCell-marginPhoto, height: GlobalSize().widthScreen*0.04)
        
        cell.ingridientDiet.numberOfLines = 2
        cell.ingridientDiet.text = arrayDescription[indexPath.row]
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
        
        for x in 0..<arrayImageHidden.count {
            if let cell = collectionView.cellForItem(at: IndexPath(row: x, section: 0)) as? CustomCellChooseDiet {
                let imageGreen = UIImage(named: "overlayIngredientImage0")
                cell.overlayImageButton.image = imageGreen
            }
            arrayImageHidden[x] = false
        }
        
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
        idClick = arrayId[indexPath.row]
        
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
        let parameter = [
            "mail": GlobalUser.email
            , "diet_id": idClick
        ] as [String : Any]
        Alamofire.request("https://api.mhint.eu/userdiet", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in }
        let newViewController = EatOutController(collectionViewLayout: layout)
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    func header() {
        GlobalFunc().titlePage(titlePage: "Food & Diet.", s: self)
        
        let description = UITextView()
        description.text = "Everybody has different tastes...\nWhat do you like to eat?"
        description.textColor = GlobalColor().colorBlack
        description.isEditable = false
        description.isUserInteractionEnabled = false
        description.isScrollEnabled = false
        description.font = UIFont(name: "AvenirLTStd-Medium", size: GlobalSize().widthScreen*0.04)
        description.frame = CGRect(x: GlobalSize().widthScreen*0.04, y: GlobalSize().heightScreen*0.18, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.15)
        self.view.addSubview(description)
        
        
        let titleListView = UILabel()
        titleListView.text = "SELECT A DIET"
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
