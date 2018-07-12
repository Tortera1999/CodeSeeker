//
//  Event.swift
//  CodeSeeker
//
//  Created by Nikhil Iyer on 6/19/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import Foundation
import UIKit

class Event {
    var title: String
    var by: String
    var date: String
    var location: String
    var concepts: String
    var image: URL?
    var eventId: String
    var latitude: String
    var longitude: String
    var from: String
    var to: String
    var category: String
    var details: String
    var price: String
    var type: String
    var rating: String
    var numberOfRating: String
    
//    init(title: String, by: String, date: String, location: String, concepts: String, image: UIImage){
//        self.title = title
//        self.by = by
//        self.date = date
//        self.location = location
//        self.concepts = concepts
//        self.image = image
//        self.eventId = "yo"
//    }
    
    init(eventId: Any, dictionary: [String: Any]){
        self.eventId = eventId as! String
        self.title = dictionary["title"] as! String
        self.by = dictionary["by"] as! String
        self.date = dictionary["date"] as! String
        self.location = dictionary["location"] as! String
        self.concepts = dictionary["concepts"] as! String
        self.image = URL(string: dictionary["imageUrl"] as! String)!
        self.latitude = dictionary["latitude"] as! String
        self.longitude = dictionary["longitude"] as! String
        self.from = dictionary["from"] as! String
        self.to = dictionary["to"] as! String
        self.details = dictionary["details"] as! String
        self.category = dictionary["category"] as! String
        self.price = dictionary["price"] as! String
        self.type = dictionary["type"] as! String
        self.rating = dictionary["rating"] as! String
        self.numberOfRating = dictionary["numberOfRating"] as! String
    }
    
    func toString() -> String {
        return "\(title), \(by), \(date), \(location), \(concepts), \(eventId)"
    }
}
