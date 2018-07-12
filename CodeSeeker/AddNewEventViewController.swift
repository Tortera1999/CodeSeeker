//
//  AddNewEventViewController.swift
//  CodeSeeker
//
//  Created by Nikhil Iyer on 6/19/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SwiftyUUID
import RSKPlaceholderTextView
import CoreLocation
import MapKit

class AddNewEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var byLabel: UITextField!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var dateTextView: RSKPlaceholderTextView!
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var conceptsLabel: UITextField!
    @IBOutlet weak var eventPicture: UIImageView!
    
    var ref: DatabaseReference!
    var pref: StorageReference!
    
    var languages = ["IOS", "ANDROID", "JS", "TYPESCRIPT", "JULIA", "C", "C++", "PYTHON"]
    
    var properAddress = "";
    
    let datePicker = UIDatePicker();
    var languagePicker = UIPickerView()
    
    var currentArr: [Event] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        pref = Storage.storage().reference()
        
        createDatePicker();
        
        conceptsLabel.inputView = languagePicker
        languagePicker.delegate = self
        languagePicker.dataSource = self
        conceptsLabel.textAlignment = .center
        
        locationLabel.text = properAddress
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createDatePicker(){
        
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit();
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(Done))
        toolbar.setItems([doneButton], animated: false)
        
        dateTextView.inputAccessoryView = toolbar;
        
        dateTextView.inputView = datePicker;
        
        dateTextView.delegate = self
    }
    
    @objc func Done(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateTextView.text = "\(dateFormatter.string(from: datePicker.date))"
        self.view.endEditing(true)
    }
    
    @IBAction func submit(_ sender: UIButton) {
        guard let title =  titleLabel.text, !title.isEmpty else{
            errorMessages(themessage: "Enter a title")
            return
        }
        guard let by =  byLabel.text, !by.isEmpty else{
            errorMessages(themessage: "Enter who is presenting the presentation")
            return
        }
        guard let date =  dateTextView.text, !date.isEmpty else{
            errorMessages(themessage: "Enter a date")
            return
        }
        guard let location =  locationLabel.text, !location.isEmpty else{
            errorMessages(themessage: "Enter a location")
            return
        }
        guard let concepts =  conceptsLabel.text, !concepts.isEmpty else{
            errorMessages(themessage: "Enter a concept")
            return
        }
        guard let img =  eventPicture.image else{
            errorMessages(themessage: "Add an image")
            return
        }
        
        let uploadData = UIImagePNGRepresentation(img)
        
        let uuid = SwiftyUUID.UUID()
        
        let uuidString = uuid.CanonicalString()
        
        pref.child(uuidString).putData(uploadData!, metadata: nil) { (metadata, error) in
            let imageUrl = metadata?.downloadURL()?.absoluteString
            
            DispatchQueue.main.async {
                
                let geocoder = CLGeocoder()
                
                geocoder.geocodeAddressString(location, completionHandler: { (placemarks, error) in
                    var lat:CLLocationDegrees
                    var lon:CLLocationDegrees
                    
                    let placemark = placemarks?.first
                    
                    guard let latTemp = (placemark?.location?.coordinate.latitude) else { return }
                    guard let lonTemp = (placemark?.location?.coordinate.longitude) else { return }
                    
                    lat = latTemp
                    lon = lonTemp
                    
                    print(String(lat))
                    print(String(lon))
                    
                    
                    let values = ["title" : title, "by" : by, "date" : date, "location" : location, "concepts" : concepts, "imageUrl" : imageUrl!, "latitude" : String(lat), "longitude" : String(lon)] as [String: Any]
                    
                    let ID = SwiftyUUID.UUID()
                    let idString = ID.CanonicalString()
                    
                    self.ref.child("Events").child(idString).setValue(values)
                    self.ref.child(concepts).child(idString).setValue(values)
                    
                    self.performSegue(withIdentifier: "goBackToLanguages", sender: self)
                    
                })
                
            }
        }        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getAddress" {
            let viewController = segue.destination as! LocationSearchTable
            viewController.vc = self
        }
    }
    
    @IBAction func uploadImage(_ sender: UITapGestureRecognizer) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = UIImagePickerControllerSourceType.camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        let size = CGSize(width: 288, height: 288)
        let newImage = resize(image: editedImage, newSize: size)
        
        eventPicture.image = newImage
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func errorMessages(themessage: String){
        let alertController = UIAlertController(title: "Error", message: themessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        conceptsLabel.text = languages[row]
        conceptsLabel.resignFirstResponder()
    }
    
    @IBAction func getLocation(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "getAddress", sender: self)
    }
    
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        print("Proper address:")
//        print(properAddress)
//        self.locationLabel.text = properAddress
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
