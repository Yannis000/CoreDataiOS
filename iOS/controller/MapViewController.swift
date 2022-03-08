//
//  MapViewController.swift
//  iOS
//
//  Created by lpiem on 08/03/2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMarkers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setMarkers()
    }
    
    func setMarkers(){
        for annotation in mapView.annotations
        {
            mapView.removeAnnotation(annotation)
        }
        let landmarks = DataManager.sharedDataManager.fetchAllLandmarks()
        for landmark in landmarks {
            if(landmark.coordinate?.latitude != nil && landmark.coordinate?.longitude != nil){
                let annotation = MKPointAnnotation()
                annotation.title = landmark.title
                if(landmark.category != nil){
                    annotation.subtitle = landmark.category!.name
                }
                
                annotation.coordinate = CLLocationCoordinate2D(latitude: landmark.coordinate!.latitude, longitude: landmark.coordinate!.longitude)
                mapView.addAnnotation(annotation)
            }
          }
    }

}
