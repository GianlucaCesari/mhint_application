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
        mapKit.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 45.9, longitude: 9.45), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)))
        mapKit.addAnnotation(CLLocationCoordinate2D(latitude: 45.9, longitude: 9.45), with: .red)
    }

}
