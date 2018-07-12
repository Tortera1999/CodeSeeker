//
//  ProfileViewController.swift
//  CodeSeeker
//
//  Created by Nikhil Iyer on 7/3/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import AlamofireImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var emailTextLabel: UILabel!
    @IBOutlet weak var rsvpsTextLabel: UILabel!
    
    var ref: DatabaseReference!
    
    var events: [Event] = []
    
    var numberOfRsvps = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        getMyFavProperties()
        
        //numberOfRsvps = events.count
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    print("HEEEERRRREEE")
                    self.numberOfRsvps = self.numberOfRsvps + 1
                    print(self.numberOfRsvps)
                    self.events.append(event)
                }
                
                if let profileImage = Auth.auth().currentUser?.photoURL{
                    self.profilePic.af_setImage(withURL: profileImage)
                } else{
                    //profilePic.af_setImage(withURL: URL(string: "http://ufindibuy.com/public/img/profile/_no_profile.jpg")!)
                }
                
                if let name = Auth.auth().currentUser?.displayName{
                    self.nameTextLabel.text = name
                } else{
                    self.nameTextLabel.text = "Unknown"
                }
                
                if let email = Auth.auth().currentUser?.email{
                    self.emailTextLabel.text = email
                } else{
                    self.emailTextLabel.text = "Unknown"
                }
                
                self.rsvpsTextLabel.text = String(self.numberOfRsvps)
                
                //self.numberOfRsvps = count
                
        })
        { (error) in
            print(error.localizedDescription)
        }
    }
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
