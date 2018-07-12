//
//  RatingsViewController.swift
//  CodeSeeker
//
//  Created by Nikhil Iyer on 7/1/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import Cosmos
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class RatingsViewController: UIViewController {

    @IBOutlet weak var ratingsView: CosmosView!
    @IBOutlet weak var rateButton: UIButton!
    
    let overcastBlueColor = UIColor(red: 0/255, green: 64/255, blue: 204/255, alpha: 1.0)
    let overcastGreenColor = UIColor(red: 2/255, green: 165/255, blue: 0/255, alpha: 1.0)
    
    var event: Event!
    
    var ref: DatabaseReference!
    
    var theRating = 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        rateButton.backgroundColor = overcastGreenColor
        rateButton.setTitleColor(overcastBlueColor, for: .normal)
        
        navigationItem.title = "Rate the Event"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func rate(_ sender: Any) {
        let rates = (ratingsView.rating + (Double(event.rating)! * Double(event.numberOfRating)!)) / (Double(event.numberOfRating)! + 1)
        let Srate = String(format:"%f", rates)
        
        let values = ["title" : event.title, "by" : event.by, "date" : event.date, "location" : event.location, "concepts" : event.concepts, "imageUrl" : event.image!.absoluteString, "latitude" : event.latitude, "longitude" : event.longitude, "from" : event.from, "to" : event.to, "category" : event.category, "details" : event.details, "price" : event.price, "type" : event.type, "rating" : Srate, "numberOfRating" : String(Double(event.numberOfRating)! + 1)] as [String: Any]
        self.ref.child("Events").child(event.eventId).setValue(values)
        self.ref.child(event.concepts).child(event.eventId).setValue(values)
        self.ref.child("Users").child((Auth.auth().currentUser?.uid)!).child("Events").child(event.eventId).setValue(values)
        self.performSegue(withIdentifier: "goAlllTheWayBack", sender: self)
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
