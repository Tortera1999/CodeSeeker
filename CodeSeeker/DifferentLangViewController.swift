//
//  DifferentLangViewController.swift
//  CodeSeeker
//
//  Created by Nikhil Iyer on 6/28/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class DifferentLangViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var diffLangCollView: UICollectionView!
    
    var diffLanguages: [String] = []
    
    var events: [Event] = []
    
    var ref: DatabaseReference!
    
    let overcastBlueColor = UIColor(red: 0/255, green: 64/255, blue: 204/255, alpha: 1.0)
    let overcastGreenColor = UIColor(red: 2/255, green: 165/255, blue: 0/255, alpha: 1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        diffLangCollView.delegate = self
        diffLangCollView.dataSource = self
        
        navigationItem.title = "Select a Language"
        
        diffLangCollView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diffLanguages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiffLangCollectionViewCell", for: indexPath) as! DiffLangCollectionViewCell
        cell.backgroundColor = overcastGreenColor
        cell.differentLanguageLabel.textColor = overcastBlueColor
        cell.differentLanguageLabel.text = diffLanguages[indexPath.row]
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = diffLangCollView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.gray.cgColor
        cell?.layer.borderWidth = 2
        getProperties(lang: diffLanguages[indexPath.row], segueId: "toEventsSegue")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = diffLangCollView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.lightGray.cgColor
        cell?.layer.borderWidth = 0.5
    }
    
    func getProperties(lang: String, segueId: String) {
        print("inGetProperties function in diffVC")
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
        if(segue.identifier == "toEventsSegue"){
            let vc = segue.destination as! EventsViewController
            vc.events1 = events
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
