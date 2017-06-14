//
//  needsController.swift
//  Mhint Watch Extension
//
//  Created by Andrea Merli on 14/06/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//


import Foundation
import WatchKit
import WatchConnectivity

var imageNeeds = [String]()
var titleNeeds = [String]()
var latNeeds = [Double]()
var lonNeeds = [Double]()

class needsController: WKInterfaceController {
    
    @IBOutlet var enableNeed: WKInterfaceGroup!
    @IBOutlet var loading: WKInterfaceGroup!
    @IBOutlet var tableNeed: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        enableNeed.setHidden(true)
        if saveData.bool(forKey: "need") {
            loadingIcon()
            getShoppingList()
        } else {
            enableNeed.setHidden(false)
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
        tableNeed.setNumberOfRows(titleNeeds.count, withRowType: "TableRowNeedController")
        for (index, _) in titleNeeds.enumerated() {
            let row = tableNeed.rowController(at: index) as! TableRowNeedController
            row.img.setImageWithUrl(url: imageNeeds[index], scale: 2.0)
            row.lbl.setTextColor(.black)
            row.group.setBackgroundColor(UIColor.init(red: 80/255, green: 227/255, blue: 194/255, alpha: 1))
            row.lbl.setText(titleNeeds[index])
        }
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        return rowIndex
    }
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        print(rowIndex)
    }
    
    func getShoppingList() {
        let urlString = "https://api.mhint.eu/requests?mail=\(String(describing: saveData.string(forKey: "email")!))"
        print(urlString)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: urlString)!
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                print("quidentro")
                if error == nil {
                    print("qui dentro")
                    do {
                        var x = 0
                        if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                            if let items = json["value"] as? [[String: Any]] {
                                if items.count > 0 {
                                    for item in items {
                                        print("ITEM: ", item)
                                        x += 1
                                        if String(describing: item["status"]!) == "accepted" {
                                            titleNeeds.append(item["name"] as! String)
                                            if let user = item["user_sender"] as? [String: Any] {
                                                imageNeeds.append(user["image_profile"] as! String)
                                            }
                                            if let position = item["display_position"] as? [String: Double] {
                                                latNeeds.append(position["lat"]!)
                                                lonNeeds.append(position["long"]!)
                                            }
                                        }
                                        if x == items.count {
                                            print("finito")
                                            self.tableListShopping()
                                        }
                                    }
                                }
                            }
                        } else {
                            self.enableNeed.setHidden(false)
                            self.loading.setHidden(true)
                            print("erro1")
                        }
                    } catch {
                        self.enableNeed.setHidden(false)
                        self.loading.setHidden(true)
                        print("erro2")
                    }
                } else {
                    self.enableNeed.setHidden(false)
                    self.loading.setHidden(true)
                    print("erro3")
                }
            }
        })
        task.resume()
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
}

public extension WKInterfaceImage {
    public func setImageWithUrl(url:String, scale: CGFloat = 1.0) -> WKInterfaceImage? {
        URLSession.shared.dataTask(with: NSURL(string: url)! as URL) { data, response, error in
            if (data != nil && error == nil) {
                let image = UIImage(data: data!, scale: scale)
                DispatchQueue.main.async() {
                    self.setImage(image)
                }
            }
        }.resume()
        return self
    }
}
