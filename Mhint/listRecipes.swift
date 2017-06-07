//
//  listRecipes.swift
//  
//
//  Created by Andrea Merli on 22/05/17.
//
//

import Foundation
import UIKit

class ListRecipesController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    let cellId = "cellListRecipes"
    
    let weeklyDay = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    let dailyMeal = ["Breakfast", "Lunch", "Dinner"]
    let dailyMealRecipes = ["Mango stiky rice", "Riso patate e cozze", "fettuccine", "riso", "ad", "adfadfda", "afadfafaf", "gsgsgf", "adfafd","Mango stiky rice", "Riso patate e cozze", "fettuccine", "riso", "ad", "adfadfda", "afadfafaf", "gsgsgf", "adfafd","Mango stiky rice", "Riso patate e cozze", "fettuccine", "riso", "ad", "adfadfda", "afadfafaf", "gsgsgf", "adfafd","Mango stiky rice", "Riso patate e cozze", "fettuccine", "riso", "ad", "adfadfda"]
    let dailyMealRecipesImage = ["https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg","https://webknox.com/recipeImages/9879-556x370.jpg", "https://8bnztmont6-flywheel.netdna-ssl.com/wp-content/uploads/2016/03/foodiesfeed.com_vegetable-party-snacks-e1459624020156.jpg"]
    
    var indexDailyMeal = -1
    
    
    let heightCell = GlobalSize().widthScreen*0.25
    let heightDayCell = GlobalSize().widthScreen*0.1
    let widthCollectionView = GlobalSize().widthScreen*0.8
    let btnNextPage = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        GlobalFunc().navBarSubView(nav: navigationItem, s: self, title: "WEEKLY RECIPES")
        header()
        nextPage()
        
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
        collectionView?.register(CustomCellChooseListRecipes.self, forCellWithReuseIdentifier: cellId)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
    
    
    //COLLECTIONVIEW
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCellChooseListRecipes
        
        let sizeImage = CGRect(x: 0, y: heightCell*0.1, width: heightCell*1.2, height: heightCell*0.8)
        
        if indexPath.row == 0 || indexPath.row % 4 == 0 {
            cell.titleDay.frame = CGRect(x: 0, y: 0, width: widthCollectionView, height: heightDayCell)
            indexDailyMeal = indexPath.row/4
            cell.titleDay.text = (weeklyDay[indexPath.row/4] + " Recipes").uppercased()
            cell.imageRecipes.alpha = 0
            cell.typeMeal.text = ""
            cell.descriptionRecipes.text = ""
        } else if indexPath.row == 1 || (indexPath.row-1) % 4 == 0{
            
            //LOADING
            cell.loadingBackground.frame = sizeImage
            
            cell.titleDay.text = ""
            cell.imageRecipes.frame = sizeImage
            cell.typeMeal.frame = CGRect(x: heightCell*0.7*2+5, y: 30, width: widthCollectionView/2, height: heightCell*0.12)
            cell.descriptionRecipes.frame = CGRect(x: heightCell*0.7*2+5, y: 55, width: widthCollectionView/2, height: heightCell*0.12)
            
            cell.typeMeal.text = "breakfast".uppercased()
            
            let indexImage = indexPath.row - indexDailyMeal
            
            cell.imageRecipes.sd_setImage(with: URL(string: dailyMealRecipesImage[indexImage]), placeholderImage: nil)
            cell.descriptionRecipes.text = dailyMealRecipes[indexImage].capitalized
            
            
        } else if indexPath.row == 2 || (indexPath.row-2) % 4 == 0{
            
            //LOADING
            cell.loadingBackground.frame = sizeImage
            
            cell.titleDay.text = ""
            cell.imageRecipes.frame = sizeImage
            cell.typeMeal.frame = CGRect(x: heightCell*0.7*2+5, y: 30, width: widthCollectionView/2, height: heightCell*0.12)
            cell.descriptionRecipes.frame = CGRect(x: heightCell*0.7*2+5, y: 55, width: widthCollectionView/2, height: heightCell*0.12)
            
            cell.typeMeal.text = "lunch".uppercased()
            
            let indexImage = indexPath.row - indexDailyMeal
            
            cell.imageRecipes.sd_setImage(with: URL(string: dailyMealRecipesImage[indexImage]), placeholderImage: nil)
            cell.descriptionRecipes.text = dailyMealRecipes[indexImage].capitalized
            
        } else if indexPath.row == 3 || (indexPath.row-3) % 4 == 0{
            
            //LOADING
            cell.loadingBackground.frame = sizeImage
            
            cell.titleDay.text = ""
            cell.imageRecipes.frame = sizeImage
            cell.typeMeal.frame = CGRect(x: heightCell*0.7*2+5, y: 30, width: widthCollectionView/2, height: heightCell*0.12)
            cell.descriptionRecipes.frame = CGRect(x: heightCell*0.7*2+5, y: 55, width: widthCollectionView/2, height: heightCell*0.12)
            
            cell.typeMeal.text = "dinner".uppercased()
            
            let indexImage = indexPath.row - indexDailyMeal
            
            cell.imageRecipes.sd_setImage(with: URL(string: dailyMealRecipesImage[indexImage]), placeholderImage: nil)
            cell.descriptionRecipes.text = dailyMealRecipes[indexImage].capitalized
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 || indexPath.row % 4 == 0{
            return CGSize(width: widthCollectionView, height: heightDayCell)
        }
        return CGSize(width: widthCollectionView, height: heightCell)
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
    
}
