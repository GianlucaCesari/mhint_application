//
//  listRecipes.swift
//  
//
//  Created by Andrea Merli on 22/05/17.
//
//

import Foundation
import UIKit
import Alamofire

class ListRecipesController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    let cellId = "cellListRecipes"
    
    var weeklyDay = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    let dailyMeal = ["Breakfast", "Lunch", "Dinner"]
    
    var dailyMealRecipes = [""]
    var dailyMealRecipesId = [""]
    var dailyMealRecipesImage = [""]
    
    let heightCell = GlobalSize().widthScreen*0.25
    let heightDayCell = GlobalSize().widthScreen*0.1
    let widthCollectionView = GlobalSize().widthScreen*0.8
    let btnNextPage = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        getRecipes()
        
        GlobalFunc().navBarSubView(nav: navigationItem, s: self, title: "WEEKLY RECIPES")
        setWeek()
        GlobalFunc().loadingChat(s: self, frame: CGRect(x: GlobalSize().widthScreen*0.25, y: GlobalSize().heightScreen*0.4, width: GlobalSize().widthScreen*0.5, height: GlobalSize().widthScreen*0.5), nameGif: "load")
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 2
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: widthCollectionView, height: heightCell)
        collectionView?.collectionViewLayout = layout
        collectionView?.backgroundColor = .white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.frame = CGRect(x: GlobalSize().widthScreen*0.1, y: GlobalSize().heightScreen*0.25, width: widthCollectionView, height: GlobalSize().heightScreen*0.62)
        collectionView?.register(CustomCellChooseListRecipes.self, forCellWithReuseIdentifier: cellId)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        
        let backCollectionViewBack = UIView()
        backCollectionViewBack.backgroundColor = .white
        backCollectionViewBack.frame = CGRect(x: 0, y: 0, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.32)
        self.view.addSubview(backCollectionViewBack)
        header()
        
        let btnMenu = UIButton.init(type: .custom)
        let imgMenu = UIImage(named: "arrowLeft")
        btnMenu.frame = CGRect(x: 0, y: 0, width: GlobalSize().sizeIconMenuBar, height: GlobalSize().sizeIconMenuBar)
        btnMenu.setImage(imgMenu, for: .normal)
        btnMenu.addTarget(self, action: #selector(self.back(sender:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnMenu)
    }
    
    func getRecipes() {
        self.collectionView?.alpha = 0
        btnNextPage.setTitle("I'm planning your diet for this week.", for: .normal)
        btnNextPage.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.92, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.05)
        btnNextPage.setTitleColor(.black, for: .normal)
        btnNextPage.titleLabel?.font = UIFont(name: "AvenirLTStd-Heavy", size: GlobalSize().widthScreen*0.03)
        btnNextPage.titleLabel?.textAlignment = .center
        self.view.addSubview(btnNextPage)
        Alamofire.request("https://api.mhint.eu/weeklyplan?mail=\(GlobalUser.email)", encoding: JSONEncoding.default).responseJSON { JSON in
            if let response = JSON.result.value as? [String: Any] {
                idList = response["shopping_list"] as! String
                if let items = response["items"] as? [[String: Any]] {
                    var x = 0
                    var y = 0
                    for item in items {
                        if x == 3 {
                            self.dailyMealRecipes.append("")
                            self.dailyMealRecipesId.append("")
                            self.dailyMealRecipesImage.append("")
                            x = 0
                            y += 1
                        }
                        self.dailyMealRecipes.append(item["title"] as! String)
                        self.dailyMealRecipesId.append(item["recipe_id"] as! String)
                        self.dailyMealRecipesImage.append(item["img_url"] as! String)
                        x += 1
                        if (items.count+y) == self.dailyMealRecipesId.count-1 {
                            GlobalFunc().removeLoadingChat(s: self)
                            self.nextPage()
                            self.collectionView?.alpha = 1
                            self.collectionView?.reloadData()
                            saveData.set(idList, forKey: "shopping_list")
                            saveData.set(self.dailyMealRecipes, forKey: "recipesTitle")
                            saveData.set(self.dailyMealRecipesId, forKey: "recipesId")
                            saveData.set(self.dailyMealRecipesImage, forKey: "recipesImage")
                            saveData.set(7, forKey: "dayToShoppingList")
                        }
                    }
                }
            }
        }
    }
    
    func setWeek() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        let today:Int = getDayOfWeek(result)!
        weeklyDay.removeAll()
        switch (today) {
        case 1:
            weeklyDay = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
            break
        case 2:
            weeklyDay = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
            break
        case 3:
            weeklyDay = ["Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday","Monday"]
            break
        case 4:
            weeklyDay = ["Wednesday","Thursday","Friday","Saturday","Sunday","Monday","Tuesday"]
            break
        case 5:
            weeklyDay = ["Thursday","Friday","Saturday","Sunday","Monday","Tuesday","Wednesday"]
            break
        case 6:
            weeklyDay = ["Friday","Saturday","Sunday","Monday","Tuesday","Wednesday","Thursday"]
            break
        case 7:
            weeklyDay = ["Saturday","Sunday","Monday","Tuesday","Wednesday","Thursday","Friday"]
            break
        default:
            weeklyDay = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
            break
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        let section = (dailyMealRecipes.count/4)
        return section
    }
    
    //COLLECTIONVIEW
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCellChooseListRecipes
        let sizeImage = CGRect(x: 0, y: heightCell*0.1, width: heightCell*1.2, height: heightCell*0.8)
        
        cell.titleDay.text = ""
        cell.imageRecipes.alpha = 0
        cell.loadingBackground.alpha = 0
        cell.typeMeal.text = ""
        cell.descriptionRecipes.text = ""
        
        let indexImage = indexPath.row+(indexPath.section*4)
        
        cell.titleDay.text = ""
        cell.imageRecipes.alpha = 0
        cell.loadingBackground.alpha = 0
        cell.typeMeal.text = ""
        cell.descriptionRecipes.text = ""
        
        if indexPath.row == 0 {
            cell.titleDay.frame = CGRect(x: 0, y: heightDayCell*0.5, width: widthCollectionView, height: heightDayCell*0.5)
            cell.titleDay.text = (weeklyDay[indexPath.section] + " Recipes").uppercased()
        } else if indexPath.row == 1 {
            cell.imageRecipes.alpha = 1
            cell.loadingBackground.alpha = 1
            
            cell.loadingBackground.frame = sizeImage
            
            cell.imageRecipes.frame = sizeImage
            cell.typeMeal.frame = CGRect(x: heightCell*0.7*2+5, y: 30, width: widthCollectionView/2, height: heightCell*0.12)
            cell.descriptionRecipes.frame = CGRect(x: heightCell*0.7*2+5, y: 55, width: widthCollectionView/2, height: heightCell*0.12)
            
            cell.typeMeal.text = "breakfast".uppercased()
            cell.imageRecipes.sd_setImage(with: URL(string: dailyMealRecipesImage[indexImage]), placeholderImage: UIImage(gifName: "load"))
            cell.descriptionRecipes.text = dailyMealRecipes[indexImage].capitalized
        } else if indexPath.row == 2 {
            cell.imageRecipes.alpha = 1
            cell.loadingBackground.alpha = 1
            
            cell.loadingBackground.frame = sizeImage
            
            cell.imageRecipes.frame = sizeImage
            cell.typeMeal.frame = CGRect(x: heightCell*0.7*2+5, y: 30, width: widthCollectionView/2, height: heightCell*0.12)
            cell.descriptionRecipes.frame = CGRect(x: heightCell*0.7*2+5, y: 55, width: widthCollectionView/2, height: heightCell*0.12)
            
            cell.typeMeal.text = "lunch".uppercased()
            cell.imageRecipes.sd_setImage(with: URL(string: dailyMealRecipesImage[indexImage]), placeholderImage: UIImage(gifName: "load"))
            cell.descriptionRecipes.text = dailyMealRecipes[indexImage].capitalized
        } else if indexPath.row == 3 {
            cell.imageRecipes.alpha = 1
            cell.loadingBackground.alpha = 1
            
            cell.loadingBackground.frame = sizeImage
            
            cell.imageRecipes.frame = sizeImage
            cell.typeMeal.frame = CGRect(x: heightCell*0.7*2+5, y: 30, width: widthCollectionView/2, height: heightCell*0.12)
            cell.descriptionRecipes.frame = CGRect(x: heightCell*0.7*2+5, y: 55, width: widthCollectionView/2, height: heightCell*0.12)
            
            cell.typeMeal.text = "dinner".uppercased()
            cell.imageRecipes.sd_setImage(with: URL(string: dailyMealRecipesImage[indexImage]), placeholderImage: UIImage(gifName: "load"))
            cell.descriptionRecipes.text = dailyMealRecipes[indexImage].capitalized
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: widthCollectionView, height: heightDayCell)
        } else {
            return CGSize(width: widthCollectionView, height: heightCell)
        }
    }
    //COLLECTIONVIEW
    
    //BOTTONE NEXT PAGE
    func nextPage() {
        btnNextPage.addTarget(self, action: #selector(goToDiet), for: .touchUpInside)
        btnNextPage.setTitle("Go to the next page", for: .normal)
        btnNextPage.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.92, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.05)
        btnNextPage.setTitleColor(.black, for: .normal)
        btnNextPage.titleLabel?.font = UIFont(name: "AvenirLTStd-Heavy", size: GlobalSize().widthScreen*0.03)
        btnNextPage.titleLabel?.textAlignment = .center
        self.view.addSubview(btnNextPage)
    }
    
    func goToDiet() {
        let newViewController = ShoppingListController(collectionViewLayout: layout)
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    //HEADER
    func header() {
        GlobalFunc().titlePage(titlePage: "Food & Diet.", s: self)
        
        let description = UITextView()
        description.text = "Here's your weekly plan\nIt should fit you perfectly!"
        description.textColor = GlobalColor().colorBlack
        description.isEditable = false
        description.isScrollEnabled = false
        description.isUserInteractionEnabled = false
        description.font = UIFont(name: "AvenirLTStd-Medium", size: GlobalSize().widthScreen*0.04)
        description.frame = CGRect(x: GlobalSize().widthScreen*0.04, y: GlobalSize().heightScreen*0.18, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.15)
        self.view.addSubview(description)
        
        
        let titleListView = UILabel()
        titleListView.text = "these are your weekly recipes".uppercased()
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
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        var weekDay = myCalendar.component(.weekday, from: todayDate)
        if weekDay == 0 { weekDay = 7 }
        return weekDay
    }
}
