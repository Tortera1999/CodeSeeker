//
//  AboutCodeSeekerViewController.swift
//  CodeSeeker
//
//  Created by Nikhil Iyer on 6/29/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit

class AboutCodeSeekerViewController: UIViewController {
    @IBOutlet weak var aboutCS: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aboutCS.text = "Code Seeker is a family of meetups & tech conferences. A brand that consolidates all the meetups &conferences that we’ve been organizing since 2016 retaining their individual personalities. The creation of the Code Seeker family of meetups & tech conferences is part of the commitment we have made to open our conferences to a wider audience and to spread the culture of Learn. Share. Inspire. globally. And our long-run goal to enhance the value and overall experience when attending any of the conferences belonging to the Code Seeker family. Apart from great speakers, inspiring talks, battle stories and plenty of coffee, our conferences bring developers together as a community, to learn; share knowledge and ideas; and to inspire one another. See below which conference is next and don’t just take our word for it, check it for yourself!"

        // Do any additional setup after loading the view.
    }
    @IBAction func dismissB(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
