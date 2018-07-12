//
//  AddEventViewController.swift
//  
//
//  Created by Nikhil Iyer on 6/25/18.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyUUID
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import CoreLocation
import Photos
import MobileCoreServices

class AddEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var titleTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var byTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var dateTextLabel: SkyFloatingLabelTextField!
    
    @IBOutlet weak var locationTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var conceptTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var fromTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var toTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var categoryTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var detailTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var priceTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var typeTextField: SkyFloatingLabelTextField!
    
    
    let datePicker = UIDatePicker();
    let datePicker2 = UIDatePicker();
    let datePicker3 = UIDatePicker();
    
    var ref: DatabaseReference!
    var pref: StorageReference!
    
    var categoryPickerView : UIPickerView!
    var langPickerView: UIPickerView!
    
    
    var pickerData = ["IOS", "ANDROID", "JS", "TYPESCRIPT", "JULIA", "C", "C++", "PYTHON"]
    
    var categoriesPickerData = ["Inspiring the next big thing","AI & Machine Learning", "Most In Demand" ,"DevOps", "Cloud Computing", "Mobile App Development", "Web Development", "Emerging Languages", "Code in a Day"]
    
    var languagesPickerData: [String] = []
    
    var itnbt = ["Go", "Rust", "Clojure", "Elixir", "Kotlin", "F", "Typescript", "Swift", "Lua", "Haskell", "Groovy", "Arduino", "D", "Julia", "C++ 11-17", "Modern Java 9", "Boost c++", "Dart", "Scala", "Coffeescript"]
    
    var ai = ["Data Analyst", "Data Engineer", "Date Scientist", "Big Data", "Machine Learning", "AI", "Virtual Reality", "SAS Analytics", "Python Analytics", "QLikview", "Tableau", "Hadoop", "Cassandra", "MongoDB", "OpenStack", "Sqlite", "Pig", "Self-drive Car", "R Data Mining", "R", "SAS", "Advanced SAS","Python", "Apache Spark", "Hive", "Stata", "Tensorflow", "R Analytics", "R Data Visuals"]
    
    var cc = ["AWS Cloud", "Cloud Comput", "MS Azure Dev", "Raspberry Pi", "OpenStack", "Salesforce", "Azure", "SL Computing"]
    
    var appDev = ["Android", "Swift", "React Native", "Xamarin Application", "PhoneGap", "Firebase", "JQuery", "Windows App", "Spring Frame", "Flash & Air"]
    
    
    var programming = ["JS", "Angular"]
    
    let overcastBlueColor = UIColor(red: 0/255, green: 64/255, blue: 204/255, alpha: 1.0)
    let overcastGreenColor = UIColor(red: 2/255, green: 165/255, blue: 0/255, alpha: 1.0)
    
    let vc = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermission()
        
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = .photoLibrary
        
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            print("Camera is available 📸")
//            vc.sourceType = UIImagePickerControllerSourceType.camera
//        } else {
//            print("Camera 🚫 available so we will use photo library instead")
//            vc.sourceType = .photoLibrary
//        }
        
        createDatePicker()
        
        createFromTimePicker()
        createToTimePicker()
        
        createCategoryPicker()
        createLanguagePicker()
        
        ref = Database.database().reference()
        pref = Storage.storage().reference()

        titleTextField.placeholderColor = overcastBlueColor
        titleTextField.titleColor = overcastBlueColor
        titleTextField.textColor = overcastGreenColor
        titleTextField.selectedTitleColor = overcastBlueColor
        titleTextField.delegate = self
        
        byTextField.placeholderColor = overcastBlueColor
        byTextField.titleColor = overcastBlueColor
        byTextField.textColor = overcastGreenColor
        byTextField.selectedTitleColor = overcastBlueColor
        byTextField.delegate = self
        
        dateTextLabel.placeholderColor = overcastBlueColor
        dateTextLabel.titleColor = overcastBlueColor
        dateTextLabel.textColor = overcastGreenColor
        dateTextLabel.selectedTitleColor = overcastBlueColor
        byTextField.delegate = self
        
        locationTextField.placeholderColor = overcastBlueColor
        locationTextField.titleColor = overcastBlueColor
        locationTextField.textColor = overcastGreenColor
        locationTextField.selectedTitleColor = overcastBlueColor
        locationTextField.delegate = self
        
        conceptTextField.placeholderColor = overcastBlueColor
        conceptTextField.titleColor = overcastBlueColor
        conceptTextField.textColor = overcastGreenColor
        conceptTextField.selectedTitleColor = overcastBlueColor
        conceptTextField.delegate = self
        
        fromTextField.placeholderColor = overcastBlueColor
        fromTextField.titleColor = overcastBlueColor
        fromTextField.textColor = overcastGreenColor
        fromTextField.selectedTitleColor = overcastBlueColor
        fromTextField.delegate = self
        
        toTextField.placeholderColor = overcastBlueColor
        toTextField.titleColor = overcastBlueColor
        toTextField.textColor = overcastGreenColor
        toTextField.selectedTitleColor = overcastBlueColor
        toTextField.delegate = self
        
        categoryTextField.placeholderColor = overcastBlueColor
        categoryTextField.titleColor = overcastBlueColor
        categoryTextField.textColor = overcastGreenColor
        categoryTextField.selectedTitleColor = overcastBlueColor
        categoryTextField.delegate = self
        
        detailTextField.placeholderColor = overcastBlueColor
        detailTextField.titleColor = overcastBlueColor
        detailTextField.textColor = overcastGreenColor
        detailTextField.selectedTitleColor = overcastBlueColor
        detailTextField.delegate = self
        
        priceTextField.placeholderColor = overcastBlueColor
        priceTextField.titleColor = overcastBlueColor
        priceTextField.textColor = overcastGreenColor
        priceTextField.selectedTitleColor = overcastBlueColor
        priceTextField.delegate = self
        
        typeTextField.placeholderColor = overcastBlueColor
        typeTextField.titleColor = overcastBlueColor
        typeTextField.textColor = overcastGreenColor
        typeTextField.selectedTitleColor = overcastBlueColor
        typeTextField.delegate = self
        
        navigationItem.title = "Add an Event"
        
        doneButton.backgroundColor = overcastGreenColor
        doneButton.setTitleColor(overcastBlueColor, for: .normal)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func getLocation(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "getAddress", sender: self)
    }
    
    @IBAction func addTheImage(_ sender: UITapGestureRecognizer) {
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        eventImage.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
//    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        eventImage.image = image
//        self.dismiss(animated: true, completion: nil)
//    }
    
//     @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//
//        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        eventImage.image = image
//        self.dismiss(animated: true, completion: nil)
//
////        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
////        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
////
////        let size = CGSize(width: 288, height: 288)
////        let newImage = resize(image: editedImage, newSize: size)
////
////        eventImage.image = newImage
////        //propertImageView.image = currentImage
////
////        picker.dismiss(animated: true, completion: nil)
//
//        //performSegue(withIdentifier: "tagSegue", sender: nil)
//    }
    
//    func resize(image: UIImage, newSize: CGSize) -> UIImage {
//        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
//        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
//        resizeImageView.image = image
//
//        UIGraphicsBeginImageContext(resizeImageView.frame.size)
//        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage!
//    }
    
    func createDatePicker(){
        
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit();
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(Done))
        toolbar.setItems([doneButton], animated: false)
        
        dateTextLabel.inputAccessoryView = toolbar;
        
        dateTextLabel.inputView = datePicker;
        
        dateTextLabel.delegate = self
    }
    
    func createFromTimePicker(){
        datePicker2.datePickerMode = .time
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit();
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(Done2))
        toolbar.setItems([doneButton], animated: false)
        
        fromTextField.inputAccessoryView = toolbar;
        
        fromTextField.inputView = datePicker2;
        
        fromTextField.delegate = self
    }
    
    func createToTimePicker(){
        datePicker3.datePickerMode = .time
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit();
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(Done3))
        toolbar.setItems([doneButton], animated: false)
        
        toTextField.inputAccessoryView = toolbar;
        
        toTextField.inputView = datePicker3;
        
        toTextField.delegate = self
    }
    
    @objc func Done(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateTextLabel.text = "\(dateFormatter.string(from: datePicker.date))"
        self.view.endEditing(true)
    }
    
    @objc func Done2(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        fromTextField.text = "\(dateFormatter.string(from: datePicker2.date))"
        self.view.endEditing(true)
    }
    
    @objc func Done3(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        toTextField.text = "\(dateFormatter.string(from: datePicker3.date))"
        self.view.endEditing(true)
    }
    
    func createCategoryPicker(){
        // UIPickerView
        self.categoryPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.categoryPickerView.delegate = self
        self.categoryPickerView.dataSource = self
        self.categoryPickerView.backgroundColor = UIColor.white
        categoryTextField.inputView = self.categoryPickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = overcastBlueColor
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddEventViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(AddEventViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        categoryTextField.inputAccessoryView = toolBar
    }
    
    func createLanguagePicker(){
        // UIPickerView
        self.langPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.langPickerView.delegate = self
        self.langPickerView.dataSource = self
        self.langPickerView.backgroundColor = UIColor.white
        conceptTextField.inputView = self.langPickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = overcastBlueColor
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddEventViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(AddEventViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        conceptTextField.inputAccessoryView = toolBar
    }
    
    @objc func doneClick() {
        conceptTextField.resignFirstResponder()
        categoryTextField.resignFirstResponder()
    }
    @objc func cancelClick() {
        conceptTextField.resignFirstResponder()
        categoryTextField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.createCategoryPicker()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == categoryPickerView){
            return categoriesPickerData.count
        } else if(pickerView == langPickerView){
            return languagesPickerData.count
        }
        return 0
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == categoryPickerView){
            return categoriesPickerData[row]
        } else if(pickerView == langPickerView){
            return languagesPickerData[row]
        }
        return "yo"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == categoryPickerView){
            switch row {
            case 0:
                languagesPickerData = itnbt
                break
            case 1:
                languagesPickerData = ai
                break
            case 4:
                languagesPickerData = cc
                break
            case 5:
                languagesPickerData = appDev
                break
            default:
                languagesPickerData = []
                break
            }
            self.categoryTextField.text = categoriesPickerData[row]
            self.conceptTextField.text = ""
            langPickerView.reloadAllComponents()
        } else if(pickerView == langPickerView){
            self.conceptTextField.text = languagesPickerData[row]
        }
        
    }
    
    @IBAction func uploadToFirebase(_ sender: UIButton) {
        print("inside here")
        guard let title = titleTextField.text, !title.isEmpty else {
            let alertController = UIAlertController(title: "Error", message: "Please enter a title", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let by = byTextField.text, !by.isEmpty else {
            let alertController = UIAlertController(title: "Error", message: "Please enter the name of a person", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let date = dateTextLabel.text, !date.isEmpty else {
            let alertController = UIAlertController(title: "Error", message: "Please enter a date", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let from = fromTextField.text, !from.isEmpty else {
            let alertController = UIAlertController(title: "Error", message: "Please enter the start time", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let to = toTextField.text, !to.isEmpty else {
            let alertController = UIAlertController(title: "Error", message: "Please enter the end time", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let location = locationTextField.text, !location.isEmpty else {
            let alertController = UIAlertController(title: "Error", message: "Please enter a location", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let category = categoryTextField.text, !category.isEmpty else {
            let alertController = UIAlertController(title: "Error", message: "Please enter the category", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let concepts = conceptTextField.text, !concepts.isEmpty else {
            let alertController = UIAlertController(title: "Error", message: "Please enter the concept", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let details = detailTextField.text, !details.isEmpty else {
            let alertController = UIAlertController(title: "Error", message: "Please enter the details", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let price = priceTextField.text, !price.isEmpty else {
            let alertController = UIAlertController(title: "Error", message: "Please enter the price", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let type = typeTextField.text, !type.isEmpty else {
            let alertController = UIAlertController(title: "Error", message: "Please enter the type", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let eventPic = eventImage.image else {
            let alertController = UIAlertController(title: "Error", message: "Please put a picture", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let uploadData = UIImagePNGRepresentation(eventPic)
        
        let uuid = SwiftyUUID.UUID()
        
        let uuidString = uuid.CanonicalString()
        
        pref.child(uuidString).putData(uploadData!, metadata: nil) { (metadata, error) in
            let imageUrl = metadata?.downloadURL()?.absoluteString
            
            DispatchQueue.main.async {
                var geocoder = CLGeocoder()
                geocoder.geocodeAddressString(location, completionHandler: { (placemarks, error) in
                    var lat:CLLocationDegrees
                    var lon:CLLocationDegrees
                    
                    let placemark = placemarks?.first
                    guard let latTemp = (placemark?.location?.coordinate.latitude) else { return }
                    guard let lonTemp = (placemark?.location?.coordinate.longitude) else { return }
                    lat = latTemp
                    lon = lonTemp
                    
                    let rating = "0.0"
                    
                    
                    
                    let uuid2 = SwiftyUUID.UUID()
                    
                    let uuidString2 = uuid2.CanonicalString()
                    
                    let values = ["title" : title, "by" : by, "date" : date, "location" : location, "concepts" : concepts, "imageUrl" : imageUrl, "latitude" : String(lat), "longitude" : String(lon), "from" : from, "to" : to, "category" : category, "details" : details, "price" : price, "type" : type, "rating" : rating, "numberOfRating" : "0"] as [String : Any]
                    
                    print("Adding to firebase now")
                    
                    //self.ref.child("Users").child((Auth.auth().currentUser?.uid)!).child(uuidString2).setValue(values)
                    self.ref.child("Events").child(uuidString2).setValue(values)
                    self.ref.child(concepts).child(uuidString2).setValue(values)
                    
                    print("Finally done uploading to firebase")
                    
                    self.performSegue(withIdentifier: "goBackToLanguages", sender: self)
                    
                })
            }
        }
    }
    
    func checkPermission() {
        print("In connection func")
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "getAddress"){
            let viewController = segue.destination as! LocationSearchTable
            viewController.vc = self
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
