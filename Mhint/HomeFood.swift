//
//  HomeFood.swift
//  
//
//  Created by Andrea Merli on 24/05/17.
//
//

import Foundation
import UIKit

class HomeFoodController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate{
    
    //CLASSI ESTERNE
    let globalColor = GlobalColor()
    let globalFunction = GlobalFunc()
    
    var idRecipesClick:Int!
    
    let cellId = "cellHomeFood"
    
    var weeklyDay = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    let dailyMeal = ["Breakfast", "Lunch", "Dinner"]
    let dailyMealRecipes = ["", "Pasta alla scoglio", "Riso patate e cozze", "Pesto alla genovese", "Riso cantonese", "Briosche", "Frullato al miele", "Gold milk", "Barbecue di Fabrizio", "Pasta al ragu", "Mango stiky rice", "Riso patate e cozze", "fettuccine", "riso", "ad", "adfadfda", "afadfafaf", "gsgsgf", "adfafd","Mango stiky rice", "Riso patate e cozze", "fettuccine", "riso", "ad", "adfadfda", "afadfafaf", "gsgsgf", "adfafd","Mango stiky rice", "Riso patate e cozze", "fettuccine", "riso", "ad", "adfadfda"]
    let dailyMealRecipesImage = ["", "https://spoonacular.com/recipeImages/pear-walnut-burger-801738.jpg", "https://spoonacular.com/recipeImages/healthy-deep-dish-pizza-574315.jpg","https://spoonacular.com/recipeImages/homemade-breakfast-sausage-536620.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg"]
    
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
        
        self.view.backgroundColor = .white
        
        GlobalFunc().loadingChat(s: self, frame: CGRect(x: GlobalSize().widthScreen*0.25, y: GlobalSize().heightScreen*0.4, width: GlobalSize().widthScreen*0.5, height: GlobalSize().widthScreen*0.5), nameGif: "load-long")
        setWeek()
        globalFunction.navBar(nav: navigationItem, s: self, show: true) //navigation bar
        
        let btnMenu = UIButton.init(type: .custom)
        let imgMenu = UIImage(named: "cart")
        btnMenu.frame = CGRect(x: 0, y: 0, width: GlobalSize().sizeIconMenuBar, height: GlobalSize().sizeIconMenuBar)
        btnMenu.setImage(imgMenu, for: .normal)
        btnMenu.addTarget(self, action: #selector(self.goToShoppingList), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnMenu)
        
        
        let backCollectionView = UIView()
        backCollectionView.backgroundColor = GlobalColor().backgroundCollectionView
        backCollectionView.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.28, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.72)
        self.view.addSubview(backCollectionView)
        
        getDayAtShopping()
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
        self.view.addSubview(collectionView!)
        
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
    
    func setWeek() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        let today:Int = getDayOfWeek(result)!
        let index = today
        var correctWeek = [String]()
        for x in (index-2)...(weeklyDay.count-1) {
            correctWeek.append(weeklyDay[x])
        }
        for x in 0...(index-3) {
            correctWeek.append(weeklyDay[x])
        }
        weeklyDay.removeAll()
        weeklyDay.append(contentsOf: correctWeek)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
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
            cell.titleDay.frame = CGRect(x: 0, y: 0, width: widthCollectionView, height: heightDayCell)
            cell.titleDay.text = (weeklyDay[indexPath.section] + " Recipes").uppercased()
        } else if indexPath.row == 1 {
            cell.imageRecipes.alpha = 1
            cell.loadingBackground.alpha = 1
            
            cell.loadingBackground.frame = sizeImage
            
            cell.imageRecipes.frame = sizeImage
            cell.typeMeal.frame = CGRect(x: heightCell*0.7*2+10, y: 30, width: widthCollectionView/2, height: heightCell*0.12)
            cell.descriptionRecipes.frame = CGRect(x: heightCell*0.7*2+10, y: 55, width: widthCollectionView/2, height: heightCell*0.12)
            
            cell.typeMeal.text = "breakfast".uppercased()
            cell.imageRecipes.sd_setImage(with: URL(string: dailyMealRecipesImage[indexImage]), placeholderImage: UIImage(named: "twitter.png"))
            cell.descriptionRecipes.text = dailyMealRecipes[indexImage].capitalized
        } else if indexPath.row == 2 {
            cell.imageRecipes.alpha = 1
            cell.loadingBackground.alpha = 1
            
            cell.loadingBackground.frame = sizeImage
            
            cell.imageRecipes.frame = sizeImage
            cell.typeMeal.frame = CGRect(x: heightCell*0.7*2+10, y: 30, width: widthCollectionView/2, height: heightCell*0.12)
            cell.descriptionRecipes.frame = CGRect(x: heightCell*0.7*2+10, y: 55, width: widthCollectionView/2, height: heightCell*0.12)
            
            cell.typeMeal.text = "lunch".uppercased()
            cell.imageRecipes.sd_setImage(with: URL(string: dailyMealRecipesImage[indexImage]), placeholderImage: UIImage(named: "twitter.png"))
            cell.descriptionRecipes.text = dailyMealRecipes[indexImage].capitalized
        } else if indexPath.row == 3 {
            cell.imageRecipes.alpha = 1
            cell.loadingBackground.alpha = 1
            
            cell.loadingBackground.frame = sizeImage
            
            cell.imageRecipes.frame = sizeImage
            cell.typeMeal.frame = CGRect(x: heightCell*0.7*2+10, y: 30, width: widthCollectionView/2, height: heightCell*0.12)
            cell.descriptionRecipes.frame = CGRect(x: heightCell*0.7*2+10, y: 55, width: widthCollectionView/2, height: heightCell*0.12)
            
            cell.typeMeal.text = "dinner".uppercased()
            cell.imageRecipes.sd_setImage(with: URL(string: dailyMealRecipesImage[indexImage]), placeholderImage: UIImage(named: "twitter.png"))
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
        idRecipesClick = indexPath.row
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        view.window?.layer.add(transition, forKey: kCATransition)
        let newViewController = DetailsRecipesController(collectionViewLayout: layout)
        self.present(newViewController, animated: false, completion: nil)
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
