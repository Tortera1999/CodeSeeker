//
//  EventsViewController.swift
//  CodeSeeker
//
//  Created by Nikhil Iyer on 6/19/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import SkyFloatingLabelTextField

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var eventsTableView: UITableView!
    
    var events1: [Event] = []
    //var convertedEvents1: [Event] = []
    var allvents: [Event] = []
    
    var meetupEvents: [Event] = []
    var workshopEvents: [Event] = []
    var conferenceEvents: [Event] = []
    
    var todayEvents: [Event] = []
    var tomorrowEvents: [Event] = []
    
    @IBOutlet weak var whenSC: UISegmentedControl!
    @IBOutlet weak var whatSc: UISegmentedControl!
    @IBOutlet weak var citiesTextField: SkyFloatingLabelTextField!
    
    var whatString: String = ""
    var whenString: String = ""
    
    let todaysDate = Date()
    let tomdate = Date().tomorrow
    
    var dateFormatter = DateFormatter()
    
    var index = 0
    var index2 = 0
    
    var ratingOptionEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        citiesTextField.delegate = self
        
        navigationItem.title = "Events"
        
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let convertedEvents1 = events1.sorted { dateFormatter.date(from: $0.date)! < dateFormatter.date(from: $1.date)! }
        
        events1 = convertedEvents1
        allvents = events1
        
        print("Today events -- ")
        print(dateFormatter.string(from: todaysDate))
        print("Tomorrow events --")
        print(tomdate)
        for e in events1{
            if(e.type.lowercased().contains("meetup")){
                meetupEvents.append(e)
            } else if(e.type.lowercased().contains("workshop")){
                workshopEvents.append(e)
            } else if(e.type.lowercased().contains("conference")){
                conferenceEvents.append(e)
            }
            
            if(e.date == dateFormatter.string(from: todaysDate)){
                todayEvents.append(e)
            } else if(e.date == dateFormatter.string(from: tomdate)){
                tomorrowEvents.append(e)
            }
        }
        
        
        self.eventsTableView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //textField code
        
        textField.resignFirstResponder()  //if desired
        performAction()
        return true
    }
    
    func performAction() {
        var events2:[Event] = []
        print("Editing func")
        let loc = (String(describing: citiesTextField.text!))
        if(loc == ""){
            
        } else{
            for e in events1{
                print("Elemnt:")
                print(e.location)
                print(loc)
                if(e.location.lowercased().contains(loc)){
                    events2.append(e)
                }
            }
            print("Editing func arr")
            print(events2)
            events1 = events2
        }
        
        self.eventsTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "event") as! EventTableViewCell
        
        cell.event = events1[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toEventDetail", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.eventsTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.eventsTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.eventsTableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.eventsTableView.reloadData()
    }
    
    @IBAction func whatSCTapped(_ sender: Any) {
        index2 = whatSc.selectedSegmentIndex
        if(index2 == 1){
            print("Came here")
            sortWithDate(arr: meetupEvents)
        }
        else if(index2 == 2){
            
            sortWithDate(arr: workshopEvents)
        }
        else if(index2 == 3){
            sortWithDate(arr: conferenceEvents)
        } else if(index2 == 0){
            sortWithDate(arr: allvents)
        }
    }
    
    @IBAction func whenSCTapped(_ sender: Any) {
        index = whenSC.selectedSegmentIndex
        print("when tapped-->")
        print(index)
        print("Today events-->")
        for e in todayEvents{
            print(e.toString())
        }
        
        if(index == 1){
            sortWithEvent(arr: todayEvents)
        }
        else if(index == 2){
            sortWithEvent(arr: tomorrowEvents)
        }
        else if(index == 3){
            whenString = "Next Week"
        }
        else if(index == 0){
            sortWithEvent(arr: allvents)
        }
    }
    
    func sortWithDate(arr : [Event]){
        events1 = []
        if(index == 0){
            events1 = arr
        } else if(index == 1){
            print(dateFormatter.string(from: todaysDate))
            for e in arr{
                if(e.date == dateFormatter.string(from: todaysDate)){
                    print(dateFormatter.string(from: todaysDate))
                    print(e.date)
                    events1.append(e)
                }
            }
        } else if(index == 2){
            for e in arr{
                if(e.date == dateFormatter.string(from: tomdate)){
                    events1.append(e)
                }
            }
        } else if(index == 3){
            
        }
        
        self.eventsTableView.reloadData()
    }
    
    func sortWithEvent(arr : [Event]){
        events1 = []
        if(index2 == 0){
            
        } else if(index2 == 1){
            for e in arr{
                if(e.type.lowercased().contains("meetup")){
                    events1.append(e)
                }
            }
        } else if(index2 == 2){
            for e in arr{
                if(e.type.lowercased().contains("workshop")){
                    events1.append(e)
                }
            }
        } else if(index2 == 3){
            for e in arr{
                if(e.type.lowercased().contains("conference")){
                    events1.append(e)
                }
            }
        }
        self.eventsTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toEventDetail"){
            let vc = segue.destination as! DetailOfEventsViewController
            vc.event = events1[(eventsTableView.indexPathForSelectedRow?.row)!]
            vc.showRatings = ratingOptionEnabled
        }
        
    }

    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let vc = segue.destination as! AddNewEventViewController
//        vc.currentArr = events
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

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
}
