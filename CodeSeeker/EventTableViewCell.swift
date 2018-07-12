//
//  EventTableViewCell.swift
//  CodeSeeker
//
//  Created by Nikhil Iyer on 6/19/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import AlamofireImage

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var byTextLabel: UILabel!
    @IBOutlet weak var dateTextLabel: UILabel!
    //@IBOutlet weak var locationTextLabel: UILabel!
    @IBOutlet weak var conceptsTextLabel: UILabel!
    @IBOutlet weak var eventPic: UIImageView!
    @IBOutlet weak var backgroundCardView: UIView!
    
    let cyan = UIColor(red: 2/255, green: 235/255, blue: 247/255, alpha: 1.0)
    let overcastBlueColor = UIColor(red: 0/255, green: 64/255, blue: 204/255, alpha: 1.0)
    let overcastGreenColor = UIColor(red: 2/255, green: 165/255, blue: 0/255, alpha: 1.0)
    
    
    var event: Event!{
        didSet{
            
            let from = event.from
            let index = from.index(from.startIndex, offsetBy: 5)
            let myFromSubstring = from[..<index]
            
            titleTextLabel.text = event.title
            byTextLabel.text = "By: " + event.by
            dateTextLabel.text = "On: " + event.date + " " + myFromSubstring + "-" + event.to
            //locationTextLabel.text = event.location
            conceptsTextLabel.text = "Concept: " + event.concepts
            eventPic.af_setImage(withURL: event.image!)
            //eventPic.image = event.image
            
            titleTextLabel.textColor = overcastBlueColor
            byTextLabel.textColor = overcastBlueColor
            dateTextLabel.textColor = overcastBlueColor
            //locationTextLabel.textColor = overcastBlueColor
            conceptsTextLabel.textColor = overcastBlueColor
            
            
            backgroundCardView.backgroundColor = overcastGreenColor
            contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
            backgroundCardView.layer.cornerRadius = 3.0
            backgroundCardView.layer.masksToBounds = false
            backgroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
            backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
            backgroundCardView.layer.shadowOpacity = 0.8
            eventPic.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
