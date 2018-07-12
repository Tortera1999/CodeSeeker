//
//  LoginViewController.swift
//  CodeSeeker
//
//  Created by Nikhil Iyer on 6/19/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import FirebaseAuth
import SkyFloatingLabelTextField

class LoginViewController: UIViewController {

    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    
    let overcastBlueColor = UIColor(red: 0/255, green: 64/255, blue: 204/255, alpha: 1.0)
    let overcastGreenColor = UIColor(red: 2/255, green: 165/255, blue: 0/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.placeholderColor = overcastBlueColor
        usernameTextField.titleColor = overcastBlueColor
        usernameTextField.textColor = overcastGreenColor
        usernameTextField.selectedTitleColor = overcastBlueColor
        
        passwordTextField.placeholderColor = overcastBlueColor
        passwordTextField.titleColor = overcastBlueColor
        passwordTextField.textColor = overcastGreenColor
        passwordTextField.selectedTitleColor = overcastBlueColor
        
        signInButton.backgroundColor = overcastGreenColor
        signInButton.setTitleColor(overcastBlueColor, for: .normal)
        
        signUpButton.backgroundColor = overcastGreenColor
        signUpButton.setTitleColor(overcastBlueColor, for: .normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(_ sender: Any) {
        self.performSegue(withIdentifier: "signUp", sender: self)
    }
    @IBAction func signIn(_ sender: UIButton) {
        print(usernameTextField.text)
        print(passwordTextField.text)
        if(usernameTextField.text != "" && passwordTextField.text != "")
        {
            Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if let error = error {
                    let alertController = UIAlertController(title: "Error", message: "Could not sign in. Please make sure your email and password are correct", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                else{
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            })
        }
        else{
            let alertController = UIAlertController(title: "Error", message: "Please enter username or password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
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
