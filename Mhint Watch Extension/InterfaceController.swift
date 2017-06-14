//
//  InterfaceController.swift
//  Mhint Watch Extension
//
//  Created by Andrea Merli on 13/06/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

let saveData = UserDefaults.standard //DATA SAVE IN CACHE

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var session : WCSession?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        session = WCSession.default
        session?.delegate = self
        session?.activate()
        sleep(2)
        //CONNESSIONE
        session?.sendMessage(["request": "email"], replyHandler: { (response) in
            saveData.set(response["email"], forKey: "email")
            saveData.set(response["foodActivate"], forKey: "food")
            saveData.set(response["needActivate"], forKey: "need")
            print("Response: \(response)")
        }, errorHandler: { (error) in
            print("Error: \(error)")
        })
    }
    
    override func willActivate() {
        super.willActivate()
        
        //CONNESSIONE
        session?.sendMessage(["request": "email"], replyHandler: { (response) in
            saveData.set(response["email"], forKey: "email")
            saveData.set(response["foodActivate"], forKey: "food")
            saveData.set(response["needActivate"], forKey: "need")
            print("Response: \(response)")
        }, errorHandler: { (error) in
            print("Error: \(error)")
        })
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session: \(session) error: \(String(describing: error))")
    }
    
}


