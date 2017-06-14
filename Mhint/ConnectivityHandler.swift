//
//  ConnectivityHandler.swift
//  Mhint
//
//  Created by Andrea Merli on 14/06/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import WatchConnectivity

class ConnectivityHandler : NSObject, WCSessionDelegate {
    
    var session = WCSession.default()
    
    override init() {
        super.init()
        
        session.delegate = self
        session.activate()
        
        print("%@", "Paired Watch: \(session.isPaired), Watch App Installed: \(session.isWatchAppInstalled)")
    }
    
    // MARK: - WCSessionDelegate
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("%@", "activationDidCompleteWith activationState:\(activationState) error:\(error)")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("%@", "sessionDidBecomeInactive: \(session)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("%@", "sessionDidDeactivate: \(session)")
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        print("%@", "sessionWatchStateDidChange: \(session)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("didReceiveMessage: %@", message)
        if message["request"] as? String == "email" {
            replyHandler(["email" : GlobalUser.email, "foodActivate" : saveData.bool(forKey: "HomeFood"), "needActivate" : saveData.bool(forKey: "need")])
        }
    }
    
}
