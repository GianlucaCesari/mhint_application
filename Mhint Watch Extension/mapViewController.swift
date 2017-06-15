//
//  mapViewController.swift
//  Mhint
//
//  Created by Gianluca Cesari on 6/15/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import WatchKit
import MapKit


class mapViewController: WKInterfaceController {

    @IBOutlet var mapKit: WKInterfaceMap!

    override func didAppear() {
        let index = saveData.integer(forKey: "need_index")
        let lat = latNeeds[index]
        let lon = lonNeeds[index]
        mapKit.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
        mapKit.addAnnotation(CLLocationCoordinate2D(latitude: lat, longitude: lon), with: .red)
    }
}
