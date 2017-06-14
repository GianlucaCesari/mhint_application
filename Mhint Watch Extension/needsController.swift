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
var latNeeds = [Int]()
var lonNeeds = [String]()

class needsController: WKInterfaceController {
    
    @IBOutlet var enableNeed: WKInterfaceGroup!
    @IBOutlet var loading: WKInterfaceGroup!
    @IBOutlet var tableNeed: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
}
