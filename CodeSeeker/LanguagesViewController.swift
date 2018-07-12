//
//  LanguagesViewController.swift
//  CodeSeeker
//
//  Created by Nikhil Iyer on 6/23/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import SkyFloatingLabelTextField

class LanguagesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var events: [Event] = []
    var languages = ["Inspiring the next big thing","AI & Machine Learning", "Most In Demand" ,"DevOps", "Cloud Computing", "Mobile App Development", "Web Development", "Emerging Languages", "Code in a Day"]
    
    var itnbt = ["Go", "Rust", "Clojure", "Elixir", "Kotlin", "F", "Typescript", "Swift", "Lua", "Haskell", "Groovy", "Arduino", "D", "Julia", "C++ 11-17", "Modern Java 9", "Boost c++", "Dart", "Scala", "Coffeescript"]
    
    var ai = ["Data Analyst", "Data Engineer", "Date Scientist", "Big Data", "Machine Learning", "AI", "Virtual Reality", "SAS Analytics", "Python Analytics", "QLikview", "Tableau", "Hadoop", "Cassandra", "MongoDB", "OpenStack", "Sqlite", "Pig", "Self-drive Car", "R Data Mining", "R", "SAS", "Advanced SAS","Python", "Apache Spark", "Hive", "Stata", "Tensorflow", "R Analytics", "R Data Visuals"]
    
    var cc = ["AWS Cloud", "Cloud Comput", "MS Azure Dev", "Raspberry Pi", "OpenStack", "Salesforce", "Azure", "SL Computing"]
    
    var appDev = ["Android", "Swift", "React Native", "Xamarin Application", "PhoneGap", "Firebase", "JQuery", "Windows App", "Spring Frame", "Flash & Air"]
    
    
    var programming = ["JS", "Angular"]
    
    var courses = ["C", "Python", "Flutter", "React", "Julia", "Typescript"]
    
    var languagesOrNo = true
    
    var sendArr: [String] = []
    
    var hidden: Bool = false
    let overcastBlueColor = UIColor(red: 0/255, green: 64/255, blue: 204/255, alpha: 1.0)
    let overcastGreenColor = UIColor(red: 2/255, green: 165/255, blue: 0/255, alpha: 1.0)
    
    var ref: DatabaseReference!

    @IBOutlet weak var languageCollectionView: UICollectionView!
    
    @IBOutlet weak var coursesButton: UIButton!
    
    var slideMenuVC: SlideMenuViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        languageCollectionView.delegate = self
        languageCollectionView.dataSource = self
        
        
        
        var layout = self.languageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.languageCollectionView.frame.width - 20)/2, height: self.languageCollectionView.frame.width/3)
        
        navigationItem.title = "Select a Category"
        
        slideMenuVC = self.storyboard?.instantiateViewController(withIdentifier: "SlideMenuViewController") as! SlideMenuViewController
        
        languageCollectionView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func loadList(notification: NSNotification){
    //load data here
        print("Came here")
        print(languagesOrNo)
        languagesOrNo = !languagesOrNo
        AppDelegate.menuShowing = !AppDelegate.menuShowing
        self.languageCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(self.languagesOrNo){
           return languages.count
        } else{
            return courses.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "languageCell", for: indexPath) as! LanguagesCollectionViewCell
        cell.backgroundColor = overcastGreenColor
        cell.languageLabel.textColor = overcastBlueColor
        if(self.languagesOrNo){
            cell.languageLabel.text = languages[indexPath.row]
        } else{
            cell.languageLabel.text = courses[indexPath.row]
        }
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = languageCollectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.gray.cgColor
        cell?.layer.borderWidth = 2
        if(self.languagesOrNo){
            if(indexPath.row == 0){
                self.sendArr = itnbt
            } else if(indexPath.row == 1){
                self.sendArr = ai
            } else if(indexPath.row == 4){
                self.sendArr = cc
            } else if(indexPath.row == 5){
                self.sendArr = appDev
            } else{
                self.sendArr = programming
            }
            
            self.performSegue(withIdentifier: "toDiffLangSegue", sender: self)
        } else{
            if let requestUrl = NSURL(string: "https://www.codeseeker.co/"){
                UIApplication.shared.open(requestUrl as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = languageCollectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.lightGray.cgColor
        cell?.layer.borderWidth = 0.5
    }
    
    
    
    @IBAction func myFavorites(_ sender: UIBarButtonItem) {
        
        if(AppDelegate.menuShowing){
            
            UIView.animate(withDuration: 0.3, animations: { ()-> Void in
                self.slideMenuVC.view.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                self.slideMenuVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                self.addChildViewController(self.slideMenuVC)
                self.view.addSubview(self.slideMenuVC.view)
                AppDelegate.menuShowing = false
            })
            
            
        } else{
            UIView.animate(withDuration: 0.3, animations: { ()-> Void in
                self.slideMenuVC.view.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            }) { (finished) in
                self.slideMenuVC.view.removeFromSuperview()
            }
            
            AppDelegate.menuShowing = true
        }
        
    }

    @IBAction func courses(_ sender: Any) {
        
        
//        if(LanguagesViewController.languagesOrNo){
//            coursesButton.setTitle("Courses", for: .normal)
//        } else{
//            coursesButton.setTitle("Events", for: .normal)
//        }
//        
//        LanguagesViewController.languagesOrNo = !LanguagesViewController.languagesOrNo
//        
//        self.languageCollectionView.reloadData()
    }
    
    
    @IBAction func addAnEvent(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "addEvent", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toDiffLangSegue"){
            let vc = segue.destination as! DifferentLangViewController
            vc.diffLanguages = sendArr
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3, animations: { ()-> Void in
            self.slideMenuVC.view.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }) { (finished) in
            self.slideMenuVC.view.removeFromSuperview()
        }
        
        AppDelegate.menuShowing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //languagesOrNo = !languagesOrNo
        //self.languageCollectionView.reloadData()
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
