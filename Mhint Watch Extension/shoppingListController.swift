//
//  shoppingListController.swift
//  Mhint Watch Extension
//
//  Created by Andrea Merli on 14/06/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

var itemShoppingList = [String]()
var idShoppingList = [String]()
var checkShoppingList = [Int]()
var quantityShoppingList = [String]()

class shoppingListController: WKInterfaceController {
    
    @IBOutlet var tableShoppingList: WKInterfaceTable!
    @IBOutlet var loading: WKInterfaceGroup!
    @IBOutlet var enambleGroup: WKInterfaceGroup!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        enambleGroup.setHidden(true)
        if saveData.bool(forKey: "food") {
            loadingIcon()
            getShoppingList()
        } else {
            enambleGroup.setHidden(false)
            loading.setHidden(true)
        }
    }
    
    func loadingIcon() {
        loading.startAnimating()
        loading.startAnimatingWithImages(in: NSRange(location: 1, length: 31), duration: 7, repeatCount: 10)
    }
    
    func tableListShopping() {
        loading.setVerticalAlignment(.top)
        loading.setHidden(true)
        
        itemShoppingList.reverse()
        quantityShoppingList.reverse()
        checkShoppingList.reverse()
        idShoppingList.reverse()
        
        tableShoppingList.setNumberOfRows(itemShoppingList.count, withRowType: "TableRowController")
        for (index, _) in itemShoppingList.enumerated() {
            let row = tableShoppingList.rowController(at: index) as! TableRowController
            let name = itemShoppingList[index].capitalized
            let quantity = quantityShoppingList[index]
            let myString:String = name + "\n" + quantity
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: myString, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 11, weight: .regular)])
            let rangeSubtitle = NSString(string: myString).range(of: quantity)
            myMutableString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 10, weight: .light), range: rangeSubtitle)
            if checkShoppingList[index] == 1 {
                row.image.setImageNamed("check-true")
                row.group.setBackgroundColor(.black)
                row.lbl.setTextColor(.white)
            } else {
                row.image.setImageNamed("check-false")
                row.group.setBackgroundColor(UIColor.init(red: 80/255, green: 227/255, blue: 194/255, alpha: 1))
                row.lbl.setTextColor(.black)
            }
            row.lbl.setAttributedText(myMutableString)
        }
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        return rowIndex
    }
    
    func getShoppingList() {
        let urlString = "https://api.mhint.eu/shoppinglist?mail=\(String(describing: saveData.string(forKey: "email")!))"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: urlString)!
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                var x = 0
                if error == nil {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                            if let items = json["items"] as? [[String: Any]] {
                                for item in items {
                                    
                                    var value = ""
                                    if let v = item["value"] {
                                        value = v as! String
                                        if value.characters.count > 5 {
                                            let index = value.index(value.startIndex, offsetBy: 5)
                                            value = value.substring(to: index)
                                        }
                                    }
                                    var unit = ""
                                    if let u = item["unit"] {
                                        unit = u as! String
                                    }
                                    x += 1
                                    itemShoppingList.append(item["name"]! as! String)
                                    idShoppingList.append(item["_id"]! as! String)
                                    checkShoppingList.append(item["checked"]! as! Int)
                                    quantityShoppingList.append("\(value) \(unit)")
                                    if items.count == x {
                                        self.tableListShopping()
                                    }
                                }
                            }
                        } else {
                            print("error 1")
                        }
                    } catch {
                        print("error 2")
                    }
                } else {
                    print("error 3")
                }
            }
        })
        task.resume()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let row = tableShoppingList.rowController(at: rowIndex) as! TableRowController
        var boolImage:Bool = true
        
        if checkShoppingList[rowIndex] == 1 {
            boolImage = false
            row.image.setImageNamed("check-false")
            checkShoppingList[rowIndex] = 0
            row.group.setBackgroundColor(UIColor.init(red: 80/255, green: 227/255, blue: 194/255, alpha: 1))
            row.lbl.setTextColor(.black)
        } else {
            boolImage = true
            row.image.setImageNamed("check-true")
            checkShoppingList[rowIndex] = 1
            row.group.setBackgroundColor(.black)
            row.lbl.setTextColor(.white)
        }
        
        let urlString = "https://api.mhint.eu/itemchecked"
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        let postString = "item_id=\(idShoppingList[rowIndex])&checked=\(boolImage)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if error == nil {
                    do {
                    } catch {
                        print("error 2")
                    }
                } else {
                    print("error 3")
                }
            }
        }
        task.resume()
    }
    
    override func willActivate() {
        super.willActivate()
        enambleGroup.setHidden(true)
        if saveData.bool(forKey: "food") {
            if itemShoppingList.count != 0 {
                tableShoppingList.setNumberOfRows(itemShoppingList.count, withRowType: "TableRowController")
                for (index, _) in itemShoppingList.enumerated() {
                    let row = tableShoppingList.rowController(at: index) as! TableRowController
                    row.lbl.setText("Loading...")
                    row.image.setImageNamed("check-false")
                    if index == itemShoppingList.count-1 {
                        itemShoppingList.removeAll()
                        idShoppingList.removeAll()
                        checkShoppingList.removeAll()
                        quantityShoppingList.removeAll()
                        itemShoppingList = [String]()
                        idShoppingList = [String]()
                        checkShoppingList = [Int]()
                        quantityShoppingList = [String]()
                        getShoppingList()
                    }
                }
            }
        } else {
            enambleGroup.setHidden(false)
            loading.setHidden(true)
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
}
