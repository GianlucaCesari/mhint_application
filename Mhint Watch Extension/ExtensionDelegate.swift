//
//  ExtensionDelegate.swift
//  Mhint Watch Extension
//
//  Created by Andrea Merli on 13/06/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import WatchKit
//import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    
//    var session : WCSession?
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
//        session = WCSession.default
//        session?.delegate = self
//        session?.activate()
//
//
//        //CONNESSIONE
//        session?.sendMessage(["request": "email"], replyHandler: { (response) in
//            print("Response: \(response)")
//        }, errorHandler: { (error) in
//            print("Error: \(error)")
//        })
        
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
//        for task in backgroundTasks {
//            // Use a switch statement to check the task type
//            switch task {
//            case let backgroundTask as WKApplicationRefreshBackgroundTask:
//                // Be sure to complete the background task once you’re done.
//                if #available(watchOSApplicationExtension 4.0, *) {
//                    backgroundTask.setTaskCompletedWithSnapshot(false)
//                } else {
//                    // Fallback on earlier versions
//                }
//            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
//                // Snapshot tasks have a unique completion call, make sure to set your expiration date
//                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
//            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
//                // Be sure to complete the connectivity task once you’re done.
//                if #available(watchOSApplicationExtension 4.0, *) {
//                    connectivityTask.setTaskCompletedWithSnapshot(false)
//                } else {
//                    // Fallback on earlier versions
//                }
//            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
//                // Be sure to complete the URL session task once you’re done.
//                if #available(watchOSApplicationExtension 4.0, *) {
//                    urlSessionTask.setTaskCompletedWithSnapshot(false)
//                } else {
//                    // Fallback on earlier versions
//                }
//            default:
//                // make sure to complete unhandled task types
//                if #available(watchOSApplicationExtension 4.0, *) {
//                    task.setTaskCompletedWithSnapshot(false)
//                } else {
//                    // Fallback on earlier versions
//                }
//            }
//        }
    }
    
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        print("Session: \(session) error: \(error)")
//    }
}
