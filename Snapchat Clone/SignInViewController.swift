//
//  SignInViewController.swift
//  Snapchat Clone
//
//  Created by Ken Krippeler on 03.09.16.
//  Copyright © 2016 Lichtverbunden. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignInViewController: UIViewController
{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func turnUpTapped(_ sender: AnyObject)
    {
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion:{(user, error) in print("We tried to sign in.")
            if error != nil
            {
                print("We have an error: \(error)")
                
                FIRAuth.auth()?.createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                    print("We tried to create a user.")
                    
                    if error != nil
                    {
                        print("We have an error: \(error)")
                    }
                    else
                    {
                        print("Created User succesfully.")
                        self.performSegue(withIdentifier: "signInSegue", sender: nil)
                    }
                })
            }
            else
            {
                print("Signed in succesfully.")
                self.performSegue(withIdentifier: "signInSegue", sender: nil)
            }
            
        })
        
    }
    
}

