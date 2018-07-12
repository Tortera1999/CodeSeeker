//
//  SignUpViewController.swift
//  CodeSeeker
//
//  Created by Nikhil Iyer on 6/20/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import SkyFloatingLabelTextField

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var reEnterPasswordTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var phoneNumberTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var placeOfWorkTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var jobTypeTextField: SkyFloatingLabelTextField!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    var ref: DatabaseReference!
    
    let overcastBlueColor = UIColor(red: 0/255, green: 64/255, blue: 204/255, alpha: 1.0)
    let overcastGreenColor = UIColor(red: 2/255, green: 165/255, blue: 0/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        usernameTextField.placeholderColor = overcastBlueColor
        usernameTextField.titleColor = overcastBlueColor
        usernameTextField.textColor = overcastGreenColor
        usernameTextField.selectedTitleColor = overcastBlueColor
        
        emailTextField.placeholderColor = overcastBlueColor
        emailTextField.titleColor = overcastBlueColor
        emailTextField.textColor = overcastGreenColor
        emailTextField.selectedTitleColor = overcastBlueColor
        
        passwordTextField.placeholderColor = overcastBlueColor
        passwordTextField.titleColor = overcastBlueColor
        passwordTextField.textColor = overcastGreenColor
        passwordTextField.selectedTitleColor = overcastBlueColor
        
        reEnterPasswordTextField.placeholderColor = overcastBlueColor
        reEnterPasswordTextField.titleColor = overcastBlueColor
        reEnterPasswordTextField.textColor = overcastGreenColor
        reEnterPasswordTextField.selectedTitleColor = overcastBlueColor
        
        nameTextField.placeholderColor = overcastBlueColor
        nameTextField.titleColor = overcastBlueColor
        nameTextField.textColor = overcastGreenColor
        nameTextField.selectedTitleColor = overcastBlueColor
        
        phoneNumberTextField.placeholderColor = overcastBlueColor
        phoneNumberTextField.titleColor = overcastBlueColor
        phoneNumberTextField.textColor = overcastGreenColor
        phoneNumberTextField.selectedTitleColor = overcastBlueColor
        
        placeOfWorkTextField.placeholderColor = overcastBlueColor
        placeOfWorkTextField.titleColor = overcastBlueColor
        placeOfWorkTextField.textColor = overcastGreenColor
        placeOfWorkTextField.selectedTitleColor = overcastBlueColor
        
        jobTypeTextField.placeholderColor = overcastBlueColor
        jobTypeTextField.titleColor = overcastBlueColor
        jobTypeTextField.textColor = overcastGreenColor
        jobTypeTextField.selectedTitleColor = overcastBlueColor
        
        registerButton.backgroundColor = overcastGreenColor
        registerButton.setTitleColor(overcastBlueColor, for: .normal)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(_ sender: UIButton) {
        
        var stringEmail = emailTextField.text as! String
        let character: Character = "@"
        if(emailTextField.text == nil) {
            let alertController = UIAlertController(title: "Error", message: "Please enter email", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else if(!stringEmail.characters.contains(character)) {
            let alertController = UIAlertController(title: "Error", message: "Email must be valid", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else if(passwordTextField.text == nil) {
            let alertController = UIAlertController(title: "Error", message: "Please enter password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else if(nameTextField.text == nil) {
            let alertController = UIAlertController(title: "Error", message: "Please enter a name", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else if(phoneNumberTextField.text == nil) {
            let alertController = UIAlertController(title: "Error", message: "Please enter a phone number", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else if(jobTypeTextField.text == nil) {
            let alertController = UIAlertController(title: "Error", message: "Please enter a job type", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else if(placeOfWorkTextField.text == nil) {
            let alertController = UIAlertController(title: "Error", message: "Please enter place of work", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else if((passwordTextField.text?.count)! < 6) {
            print("Password is not appropriate length")
            let alertController = UIAlertController(title: "Error", message: "Password must be six characters long", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else if(passwordTextField.text != reEnterPasswordTextField.text) {
            let alertController = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else{
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if let error = error {
                    print(error)
                    let alertController = UIAlertController(title: "Error", message: "Cannot register user", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                        
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                else{
                    guard let uid = user?.uid else { return }
                    
                    let changeRequest = user?.createProfileChangeRequest()
                    
                    changeRequest?.displayName = self.nameTextField.text
                    changeRequest?.commitChanges(completion: { (error) in
                        if let error = error {
                            print("Error has occured")
                        } else{
                            
                            let toPutHere = self.ref.child("Users").child(uid)
                            toPutHere.child("Profile").child("number").setValue(self.phoneNumberTextField.text)
                            toPutHere.child("Profile").child("workPlace").setValue(self.placeOfWorkTextField.text)
                            toPutHere.child("Profile").child("jobType").setValue(self.jobTypeTextField.text)
                            
                            self.performSegue(withIdentifier: "confirmSignUp", sender: self)
                        }
                    })
                }
            })
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
