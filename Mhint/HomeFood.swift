//
//  HomeFood.swift
//  
//
//  Created by Andrea Merli on 24/05/17.
//
//

import Foundation
import UIKit
import Alamofire

var idList:String = ""
var idDetailsRecipes:String = "1"

class HomeFoodController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate{
    
    //CLASSI ESTERNE
    let globalColor = GlobalColor()
    let globalFunction = GlobalFunc()
    
    var idRecipesClick:Int!
    
    let cellId = "cellHomeFood"
    
    var weeklyDay = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    let dailyMeal = ["Breakfast", "Lunch", "Dinner"]
    
    var dailyMealRecipes = [""]
    var dailyMealRecipesId = [""]
    var dailyMealRecipesImage = [""]
    
    let heightCell = GlobalSize().widthScreen*0.25
    let heightDayCell = GlobalSize().widthScreen*0.15
    let widthCollectionView = GlobalSize().widthScreen*0.84
    
    let loadingShoppingBar = UIProgressView()
    var progressBarTimer:Timer!
    static var progressBarStop:Float! = 0.0
    
    static var dayToGo:Float = 0.0
    static var dateToGo:String = ""
    static var weekToGo:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setWeek()
        self.view.backgroundColor = .white
        UIApplication.shared.statusBarView?.backgroundColor = .white
        
        GlobalFunc().navBar(nav: navigationItem, s: self, show: true) //navigation bar
        let btnMenu = UIButton.init(type: .custom)
        let imgMenu = UIImage(named: "cart")
        btnMenu.frame = CGRect(x: 0, y: 0, width: GlobalSize().sizeIconMenuBar, height: GlobalSize().sizeIconMenuBar)
        btnMenu.setImage(imgMenu, for: .normal)
        btnMenu.addTarget(self, action: #selector(self.goToShoppingList), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnMenu)
        
        GlobalFunc().loadingChat(s: self, frame: CGRect(x: GlobalSize().widthScreen*0.25, y: GlobalSize().heightScreen*0.4, width: GlobalSize().widthScreen*0.5, height: GlobalSize().widthScreen*0.5), nameGif: "load")
        getRecipes()
        
        let backCollectionView = UIView()
        backCollectionView.backgroundColor = GlobalColor().backgroundCollectionView
        backCollectionView.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.28, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.72)
        self.view.addSubview(backCollectionView)
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 2
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: widthCollectionView, height: heightCell)
        collectionView?.collectionViewLayout = layout
        collectionView?.backgroundColor = GlobalColor().backgroundCollectionView
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.frame = CGRect(x: GlobalSize().widthScreen*0.08, y: GlobalSize().heightScreen*0.2, width: widthCollectionView, height: GlobalSize().heightScreen*0.8)
        collectionView?.register(CustomCellChooseHomeFood.self, forCellWithReuseIdentifier: cellId)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        self.view.addSubview(self.collectionView!)
        
        let backCollectionViewBack = UIView()
        backCollectionViewBack.backgroundColor = .white
        backCollectionViewBack.frame = CGRect(x: 0, y: 0, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.28)
        self.view.addSubview(backCollectionViewBack)
        header()
        
        loadingShoppingBar.trackTintColor = UIColor.init(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.04)
        loadingShoppingBar.progressTintColor = GlobalColor().greenSea
        loadingShoppingBar.frame = CGRect(x:GlobalSize().widthScreen*0.05, y: GlobalSize().heightScreen*0.21, width:GlobalSize().widthScreen*0.9, height:GlobalSize().widthScreen*0.02)
        progressBarTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(HomeFoodController.loadingShopping), userInfo: nil, repeats: true)
        self.view.addSubview(loadingShoppingBar)
    }
    
    func getRecipes() {
        
        getDayAtShopping()
        
        if saveData.array(forKey: "recipesTitle") == nil {
            self.collectionView?.alpha = 0
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
        } else {
            
            print("Mancano ", Int(HomeFoodController.dayToGo), " giorni alla lista della spesa.")
            print("Mancavano ", saveData.integer(forKey: "dayToShoppingList"), " giorni alla lista della spesa.")
            
            if Int(HomeFoodController.dayToGo) == 0 {
                
                GlobalFunc().removeLoadingChat(s: self)
                dailyMealRecipes = saveData.array(forKey: "recipesTitle") as! [String]
                dailyMealRecipesId = saveData.array(forKey: "recipesId") as! [String]
                dailyMealRecipesImage = saveData.array(forKey: "recipesImage") as! [String]
                idList = saveData.string(forKey: "shopping_list")!
                saveData.set(Int(HomeFoodController.dayToGo), forKey: "dayToShoppingList")
                
                self.collectionView?.alpha = 1
                self.collectionView?.reloadData()
                
            } else if saveData.integer(forKey: "dayToShoppingList") == Int(HomeFoodController.dayToGo) {
                print("STESSO GIORNO NON FARE NIENTE")
                
                GlobalFunc().removeLoadingChat(s: self)
                dailyMealRecipes = saveData.array(forKey: "recipesTitle") as! [String]
                dailyMealRecipesId = saveData.array(forKey: "recipesId") as! [String]
                dailyMealRecipesImage = saveData.array(forKey: "recipesImage") as! [String]
                idList = saveData.string(forKey: "shopping_list")!
                saveData.set(Int(HomeFoodController.dayToGo), forKey: "dayToShoppingList")
                
                self.collectionView?.alpha = 1
                self.collectionView?.reloadData()
                
            } else if saveData.integer(forKey: "dayToShoppingList") < Int(HomeFoodController.dayToGo) {
                saveData.set(nil, forKey: "recipesTitle")
                saveData.set(nil, forKey: "recipesId")
                saveData.set(nil, forKey: "recipesImage")
                saveData.set(nil, forKey: "shopping_list")
                getRecipes()
            } else if saveData.integer(forKey: "dayToShoppingList") > Int(HomeFoodController.dayToGo) {
                
                GlobalFunc().removeLoadingChat(s: self)
                print("Elimina le prime ", ((dailyMealRecipes.count/4)-Int(HomeFoodController.dayToGo)), " ricette.")
                
                dailyMealRecipes = saveData.array(forKey: "recipesTitle") as! [String]
                dailyMealRecipesId = saveData.array(forKey: "recipesId") as! [String]
                dailyMealRecipesImage = saveData.array(forKey: "recipesImage") as! [String]
                
                for x in 0..<(((dailyMealRecipes.count/4)-Int(HomeFoodController.dayToGo))*4) {
                    print(x)
                    print(dailyMealRecipes[0])
                    dailyMealRecipes.remove(at: 0)
                    dailyMealRecipesId.remove(at: 0)
                    dailyMealRecipesImage.remove(at: 0)
                }
                idList = saveData.string(forKey: "shopping_list")!
                saveData.set(Int(HomeFoodController.dayToGo), forKey: "dayToShoppingList")
                
                self.collectionView?.alpha = 1
                self.collectionView?.reloadData()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCellChooseHomeFood
        let sizeImage = CGRect(x: 10, y: heightCell*0.1, width: heightCell*1.2, height: heightCell*0.8)
        
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
            cell.typeMeal.frame = CGRect(x: heightCell*0.7*2+10, y: 30, width: widthCollectionView/2, height: heightCell*0.12)
            cell.descriptionRecipes.frame = CGRect(x: heightCell*0.7*2+10, y: 55, width: widthCollectionView/2, height: heightCell*0.12)
            
            cell.typeMeal.text = "breakfast".uppercased()
            cell.imageRecipes.sd_setImage(with: URL(string: dailyMealRecipesImage[indexImage]), placeholderImage: UIImage(gifName: "load"))
            cell.descriptionRecipes.text = dailyMealRecipes[indexImage].capitalized
        } else if indexPath.row == 2 {
            cell.imageRecipes.alpha = 1
            cell.loadingBackground.alpha = 1
            
            cell.loadingBackground.frame = sizeImage
            
            cell.imageRecipes.frame = sizeImage
            cell.typeMeal.frame = CGRect(x: heightCell*0.7*2+10, y: 30, width: widthCollectionView/2, height: heightCell*0.12)
            cell.descriptionRecipes.frame = CGRect(x: heightCell*0.7*2+10, y: 55, width: widthCollectionView/2, height: heightCell*0.12)
            
            cell.typeMeal.text = "lunch".uppercased()
            cell.imageRecipes.sd_setImage(with: URL(string: dailyMealRecipesImage[indexImage]), placeholderImage: UIImage(gifName: "load"))
            cell.descriptionRecipes.text = dailyMealRecipes[indexImage].capitalized
        } else if indexPath.row == 3 {
            cell.imageRecipes.alpha = 1
            cell.loadingBackground.alpha = 1
            
            cell.loadingBackground.frame = sizeImage
            
            cell.imageRecipes.frame = sizeImage
            cell.typeMeal.frame = CGRect(x: heightCell*0.7*2+10, y: 30, width: widthCollectionView/2, height: heightCell*0.12)
            cell.descriptionRecipes.frame = CGRect(x: heightCell*0.7*2+10, y: 55, width: widthCollectionView/2, height: heightCell*0.12)
            
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
    
    
    //COLLECTIONVIEW CLICK
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        idDetailsRecipes = dailyMealRecipesId[indexPath.row]
        
        let newViewController = DetailsRecipesController(collectionViewLayout: layout)
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    //COLLECTIONVIEW CLICK
    
    
    func header() {
        GlobalFunc().titlePage(titlePage: "Food & Diet.", s: self)
        
        let description = UILabel()
        description.text = "Next shop"
        description.textColor = self.globalColor.colorBlack
        description.font = UIFont(name: "AvenirLTStd-Medium", size: GlobalSize().widthScreen*0.04)
        description.frame = CGRect(x: GlobalSize().widthScreen*0.06, y: GlobalSize().heightScreen*0.15, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.1)
        self.view.addSubview(description)
        
        let titleListView = UILabel()
        titleListView.text = "\(Int(HomeFoodController.dayToGo)) days to go | \(HomeFoodController.dateToGo)"
        titleListView.textColor = self.globalColor.colorBlack
        titleListView.textAlignment = .left
        titleListView.font = UIFont(name: "AvenirLTStd-Medium", size: GlobalSize().widthScreen*0.028)
        titleListView.frame = CGRect(x: GlobalSize().widthScreen*0.06, y: GlobalSize().heightScreen*0.22, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.1)
        self.view.addSubview(titleListView)
        
//        let btnShopNow = UIButton()
//        btnShopNow.setTitle("Shopping List".uppercased(), for: .normal)
//        btnShopNow.setTitleColor(.black, for: .normal)
//        btnShopNow.titleLabel?.font = UIFont(name: "AvenirLTStd-Heavy", size: GlobalSize().widthScreen*0.028)
//        btnShopNow.frame = CGRect(x: GlobalSize().widthScreen*0.72, y: GlobalSize().heightScreen*0.22, width: GlobalSize().widthScreen*0.25, height: GlobalSize().widthScreen*0.1)
//        btnShopNow.addTarget(self, action: #selector(goToShoppingList), for: .touchUpInside)
//        self.view.addSubview(btnShopNow)
    }
    
    func goToShoppingList() {
        let newViewController = HomeShoppingListController(collectionViewLayout: layout)
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func loadingShopping() {
        if loadingShoppingBar.progress > HomeFoodController.progressBarStop {
            progressBarTimer.invalidate()
            progressBarTimer = nil
        } else {
            loadingShoppingBar.progress += 0.01
        }
    }
    
    
    //GET DAY SHOPPING
    func getDayAtShopping() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
    
        let today:Float = Float(getDayOfWeek(result)!)
        let notification:Float = Float(saveData.integer(forKey: "notificationDay"))
        
        if today > notification {
            HomeFoodController.dayToGo = (7 - today) + notification
        } else if today < notification {
            HomeFoodController.dayToGo = notification - today
        } else if today == notification {
            HomeFoodController.dayToGo = 0
        }
        
        HomeFoodController.progressBarStop = 1-(HomeFoodController.dayToGo/7)
        
        var dayToShopping: Date {
            return (Calendar.current as NSCalendar).date(byAdding: .day, value: Int(HomeFoodController.dayToGo), to: Date(), options: [])!
        }
        let calendar = Calendar.current
        let month = calendar.component(.month, from: dayToShopping)
        let day = calendar.component(.day, from: dayToShopping)
        var weekDay = ["", "Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
        var monthDay = ["", "Jan.", "Feb.", "Mar.", "Apr.", "May", "Jun.", "Jul.", "Aug.", "Sep.", "Oct.", "Nov.", "Dec."]
        
        HomeFoodController.dateToGo = "\(day) \(monthDay[month])"
        HomeFoodController.weekToGo = weekDay[Int(notification-1)]
        
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
