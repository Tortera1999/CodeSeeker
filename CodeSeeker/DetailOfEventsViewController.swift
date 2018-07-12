//
//  DetailOfEventsViewController.swift
//  CodeSeeker
//
//  Created by Nikhil Iyer on 6/23/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import AlamofireImage
import Cosmos

class DetailOfEventsViewController: UIViewController {

    @IBOutlet weak var eventPicture: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventBy: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventAt: UILabel!
    @IBOutlet weak var eventConcept: UILabel!
    @IBOutlet weak var eventGoingButton: UIButton!
    @IBOutlet weak var eventDetail: UILabel!
    @IBOutlet weak var ratingsView: CosmosView!
    @IBOutlet weak var commentsButton: UIButton!
    
    let overcastBlueColor = UIColor(red: 0/255, green: 64/255, blue: 204/255, alpha: 1.0)
    let overcastGreenColor = UIColor(red: 2/255, green: 165/255, blue: 0/255, alpha: 1.0)
    
    var event: Event!
    
    var ref: DatabaseReference!
    
    var showRatings = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        eventPicture.af_setImage(withURL: event.image!)
        eventTitle.text = event.title
        eventAt.text = "At: " + event.location
        eventBy.text = "By: " + event.by
        eventDate.text = "On: " + event.date  + " " + event.from + "-" + event.to
        eventConcept.text = "Concept: " + event.concepts
        eventDetail.text = "Details: " + event.details
        
        print(event.details)
        
        eventTitle.textColor = overcastBlueColor
        eventBy.textColor = overcastBlueColor
        eventDate.textColor = overcastBlueColor
        eventAt.textColor = overcastBlueColor
        eventConcept.textColor = overcastBlueColor
        eventDetail.textColor = overcastBlueColor
        
        eventGoingButton.backgroundColor = overcastGreenColor
        eventGoingButton.setTitleColor(overcastBlueColor, for: .normal)
        
        commentsButton.backgroundColor = overcastGreenColor
        commentsButton.setTitleColor(overcastBlueColor, for: .normal)
        
        //ratingsView.didFinishTouchingCosmos = {rating in print(self.ratingsView.rating)}
        
        ratingsView.settings.updateOnTouch = false
        ratingsView.settings.fillMode = .precise
        ratingsView.rating = Double(event.rating)!
        
        navigationItem.title = "Detail of the Event"
        
        if(showRatings){
            eventGoingButton.setTitle("Rate", for: .normal)
        } else{
            eventGoingButton.setTitle("Reserve", for: .normal)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func myFav(_ sender: UIButton){
        if(showRatings){
            self.performSegue(withIdentifier: "ratingsegue", sender: self)
        } else{
            self.performSegue(withIdentifier: "paymentSegue", sender: self)
        }
        
    }
    
    @IBAction func goToMap(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "goToTheMap", sender: self)
    }
    
    @IBAction func goToComments(_ sender: Any) {
        self.performSegue(withIdentifier: "commentsSegue", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "paymentSegue"){
            let vc = segue.destination as! BookEventViewController
            vc.event = event
        } else if(segue.identifier == "goToTheMap"){
            let vc = segue.destination as! MapViewController
            var eve: [Event] = []
            eve.append(event)
            vc.events2 = eve
            //vc.oneEvent = event
            //vc.oneEventUpdatedOrNo = 1
        } else if(segue.identifier == "ratingsegue"){
            let vc = segue.destination as! RatingsViewController
            vc.event = event
        } else if(segue.identifier == "commentsSegue"){
            let vc = segue.destination as! CommentsViewController
            vc.event = event
        }
        
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
