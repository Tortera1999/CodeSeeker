//
//  SlideMenuViewController.swift
//  CodeSeeker
//
//  Created by Nikhil Iyer on 6/30/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth


class SlideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var slideMenuTV: UITableView!
    
    var slideMenuArr = ["My Favs", "Map", "About Us", "Sign Out", "Courses", "Share", "Rate Our Events", "Profile"]
    
    var events: [Event] = []
    
    var ref: DatabaseReference!
    
    var vc: LanguagesViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        slideMenuTV.delegate = self
        slideMenuTV.dataSource = self
        
        vc = self.storyboard?.instantiateViewController(withIdentifier: "LanguagesViewController") as! LanguagesViewController
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return slideMenuArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SlideMenuTableViewCell
        cell.slideMenuOptionLabel.text = slideMenuArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            getMyFavProperties()
        } else if(indexPath.row == 1){
            getProperties(lang: "Events", segueId: "mapView")
        } else if(indexPath.row == 2){
            self.performSegue(withIdentifier: "aboutCS", sender: self)
        } else if(indexPath.row == 3){
            do {
                let firebaseAuth = Auth.auth()
                
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            self.dismiss(animated: true, completion: nil)
        } else if(indexPath.row == 4){
            if(slideMenuArr[4] == "Courses"){
                print("In this crazy if statement")
                slideMenuArr[4] = "Events"
                print(slideMenuArr)
            } else{
                slideMenuArr[4] = "Courses"
            }
            slideMenuTV.reloadData()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            self.view.removeFromSuperview()
        } else if(indexPath.row == 5){
            if let requestUrl = NSURL(string: "https://www.facebook.com/codeseeker.co/"){
                UIApplication.shared.open(requestUrl as URL, options: [:], completionHandler: nil)
            }
        } else if(indexPath.row == 6){
            getRateProperties()
            //getProperties(lang: "Events", segueId: "directToEvents2")
        } else if(indexPath.row == 7){
            self.performSegue(withIdentifier: "profileSegue", sender: self)
        }
    }
    
    func getRateProperties(){
        print("In getMyRateProperties")
        ref.child("Users").child((Auth.auth().currentUser?.uid)!).child("Events").observe(.value, with:
            { (snapshot) in
                guard let value = snapshot.value as? NSDictionary else { return }
                
                self.events = []
                
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                let time = formatter.string(from: date)
                
                for (id, obj) in value {
                    let eventId = id as! String
                    let dictVals = obj as! [String: Any]
                    let event = Event(eventId: eventId, dictionary: dictVals)
                    if(event.date == time){
                        self.events.append(event)
                    }
                }
                
                print("gonna perform the segue")
                self.performSegue(withIdentifier: "directToEvents2", sender: self)
                
        })
        { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    
    func getMyFavProperties(){
        print("In getMyFavProperties")
        ref.child("Users").child((Auth.auth().currentUser?.uid)!).child("Events").observe(.value, with:
            { (snapshot) in
                guard let value = snapshot.value as? NSDictionary else { return }
                
                self.events = []
                for (id, obj) in value {
                    let eventId = id as! String
                    let dictVals = obj as! [String: Any]
                    let event = Event(eventId: eventId, dictionary: dictVals)
                    self.events.append(event)
                }
                print("gonna perform the segue")
                self.performSegue(withIdentifier: "directToEvents", sender: self)
                
        })
        { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getProperties(lang: String, segueId: String) {
        print("inGetProperties function")
        ref.child(lang).observe(.value, with:
            { (snapshot) in
                guard let value = snapshot.value as? NSDictionary else { return }
                
                self.events = []
                for (id, obj) in value {
                    let eventId = id as! String
                    let dictVals = obj as! [String: Any]
                    let event = Event(eventId: eventId, dictionary: dictVals)
                    self.events.append(event)
                }
                self.performSegue(withIdentifier: segueId, sender: self)
                
        })
        { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "directToEvents"){
            let vc = segue.destination as! EventsViewController
            vc.events1 = events
            vc.ratingOptionEnabled = false
        } else if(segue.identifier == "mapView"){
            let vc = segue.destination as! MapViewController
            vc.events2 = events
        } else if(segue.identifier == "directToEvents2"){
            let vc = segue.destination as! EventsViewController
            vc.events1 = events
            vc.ratingOptionEnabled = true
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
