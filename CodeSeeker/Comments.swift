//
//  Comments.swift
//  CodeSeeker
//
//  Created by Nikhil Iyer on 7/2/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import Foundation

class Comments{
    var name: String
    var descript: String
    var time: String
    
    init(commentId: Any, dictionary: [String: Any]){
        //self.eventId = eventId as! String
        self.name = dictionary["name"] as! String
        self.descript = dictionary["descript"] as! String
        self.time = dictionary["time"] as! String
    }
    
    init(name : String, descript : String, time : String){
        self.name = name
        self.descript = descript
        self.time = time
    }
}
