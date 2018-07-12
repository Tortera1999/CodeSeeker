//
//  CommentsViewController.swift
//  CodeSeeker
//
//  Created by Nikhil Iyer on 7/2/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import SwiftyUUID

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    
    var ref: DatabaseReference!
    
    var allComments: [Comments] = []
    
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        
        navigationItem.title = "Comments"
        
        loadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell") as! CommentsTableViewCell
        cell.comment = allComments[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @IBAction func post(_ sender: Any) {
        print("yeer1111")
        print(event.eventId)
        
        let uuid2 = SwiftyUUID.UUID()
        let uuidString2 = uuid2.CanonicalString()
        
        if let name = Auth.auth().currentUser?.displayName, let post = commentTextField.text {
            //let time = "12/03/1999"
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let time = formatter.string(from: date)
            let values = ["name": name, "descript": post, "time" : time] as [String : Any]
            let comment = Comments(name: "yogesh", descript: commentTextField.text!, time: "12/03/1999")
            allComments.append(comment)
            self.commentsTableView.reloadData()
            commentTextField.text = ""
            self.ref.child("Comments").child(event.eventId).child(uuidString2).setValue(values)
        } else{
            print("error in display name")
        }
    }
    
    func loadData(){
        ref.child("Comments").child(event.eventId).observe(.value, with:
            { (snapshot) in
                guard let value = snapshot.value as? NSDictionary else { return }
                
                self.allComments = []
                for (id, obj) in value {
                    let commentId = id as! String
                    let dictVals = obj as! [String: Any]
                    let c = Comments(commentId: commentId, dictionary: dictVals)
                    self.allComments.append(c)
                }
                self.commentsTableView.reloadData()
                //self.performSegue(withIdentifier: segueId, sender: self)
                
        })
        { (error) in
            print(error.localizedDescription)
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
