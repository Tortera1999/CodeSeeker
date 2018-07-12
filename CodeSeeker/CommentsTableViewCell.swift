//
//  CommentsTableViewCell.swift
//  CodeSeeker
//
//  Created by Nikhil Iyer on 7/2/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backgroundCardView: UIView!
    
    let overcastBlueColor = UIColor(red: 0/255, green: 64/255, blue: 204/255, alpha: 1.0)
    let overcastGreenColor = UIColor(red: 2/255, green: 165/255, blue: 0/255, alpha: 1.0)
    
    var comment: Comments!{
        didSet{
            nameLabel.text = comment.name
            descriptionLabel.text = comment.descript
            dateLabel.text = comment.time
            
            nameLabel.textColor = overcastBlueColor
            descriptionLabel.textColor = overcastBlueColor
            dateLabel.textColor = overcastBlueColor
            
            backgroundCardView.backgroundColor = overcastGreenColor
            contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
            backgroundCardView.layer.cornerRadius = 3.0
            backgroundCardView.layer.masksToBounds = false
            backgroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
            backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
            backgroundCardView.layer.shadowOpacity = 0.8
            
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
