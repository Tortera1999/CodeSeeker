//
//  MapViewController.swift
//  CodeSeeker
//
//  Created by Nikhil Iyer on 6/24/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

final class SchoolAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var event: Event?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, event: Event?){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.event = event
        
        super.init()
    }
    
    var region: MKCoordinateRegion{
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        return MKCoordinateRegion(center: coordinate, span: span)
    }
}

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    var events2: [Event] = []
    //var oneEvent: Event?
    //var oneEventUpdatedOrNo: Int = 0
    
    var selectedView: MKAnnotationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Map"

        map.delegate = self
        map.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        for event in events2{
            let eventCoordinate = CLLocationCoordinate2D(latitude: Double(event.latitude)!, longitude: Double(event.longitude)!)
            let propertyAnnotation = SchoolAnnotation(coordinate: eventCoordinate, title: event.title, subtitle: event.concepts, event: event)
            map.addAnnotation(propertyAnnotation)
            map.setRegion(propertyAnnotation.region, animated: true)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let schoolAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView{
            schoolAnnotationView.animatesWhenAdded = true
            schoolAnnotationView.titleVisibility = .adaptive
            schoolAnnotationView.titleVisibility = .adaptive
            
            return schoolAnnotationView
        }
        else{
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        var prop = (view.annotation as! SchoolAnnotation).event
        selectedView = view
        //self.performSegue(withIdentifier: "annSegue", sender: prop)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
