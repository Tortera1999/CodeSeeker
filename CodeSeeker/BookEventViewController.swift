//
//  BookEventViewController.swift
//  CodeSeeker
//
//  Created by Nikhil Iyer on 6/29/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class BookEventViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var eventPrice: UILabel!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var cardTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var expirationTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var cvcTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var zipCodeTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var bookEvent: UIButton!
    
    let overcastBlueColor = UIColor(red: 0/255, green: 64/255, blue: 204/255, alpha: 1.0)
    let overcastGreenColor = UIColor(red: 2/255, green: 165/255, blue: 0/255, alpha: 1.0)
    
    var ref: DatabaseReference!
    
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventPrice.text = "Price: $" + event.price
        
        nameTextField.placeholderColor = overcastBlueColor
        nameTextField.titleColor = overcastBlueColor
        nameTextField.textColor = overcastGreenColor
        nameTextField.selectedTitleColor = overcastBlueColor
        nameTextField.delegate = self
        
        cardTextField.placeholderColor = overcastBlueColor
        cardTextField.titleColor = overcastBlueColor
        cardTextField.textColor = overcastGreenColor
        cardTextField.selectedTitleColor = overcastBlueColor
        cardTextField.delegate = self
        
        expirationTextField.placeholderColor = overcastBlueColor
        expirationTextField.titleColor = overcastBlueColor
        expirationTextField.textColor = overcastGreenColor
        expirationTextField.selectedTitleColor = overcastBlueColor
        expirationTextField.delegate = self
        
        cvcTextField.placeholderColor = overcastBlueColor
        cvcTextField.titleColor = overcastBlueColor
        cvcTextField.textColor = overcastGreenColor
        cvcTextField.selectedTitleColor = overcastBlueColor
        cvcTextField.delegate = self
        
        zipCodeTextField.placeholderColor = overcastBlueColor
        zipCodeTextField.titleColor = overcastBlueColor
        zipCodeTextField.textColor = overcastGreenColor
        zipCodeTextField.selectedTitleColor = overcastBlueColor
        zipCodeTextField.delegate = self
        
        eventPrice.textColor = overcastBlueColor
        detailsLabel.textColor = overcastBlueColor
        
        bookEvent.backgroundColor = overcastGreenColor
        bookEvent.setTitleColor(overcastBlueColor, for: .normal)
        
        navigationItem.title = "Add a payment method"

        
        ref = Database.database().reference()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bookIt(_ sender: Any) {
        let values = ["title" : event.title, "by" : event.by, "date" : event.date, "location" : event.location, "concepts" : event.concepts, "imageUrl" : event.image!.absoluteString, "latitude" : event.latitude, "longitude" : event.longitude, "from" : event.from, "to" : event.to, "category" : event.category, "details" : event.details, "price" : event.price, "type" : event.type, "rating" : event.rating, "numberOfRating" : event.numberOfRating] as [String: Any]
        self.ref.child("Users").child((Auth.auth().currentUser?.uid)!).child("Events").child(event.eventId).setValue(values)
        print("Added it properly")
        self.performSegue(withIdentifier: "goTotallyBack", sender: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
