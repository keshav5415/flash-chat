//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController 
{

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    

    @IBAction func loginPressed(_ sender: UIButton) 
    {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text
        {
            // firebase has added the below code which is outdated , so we made some changes and made it correct !
            /*
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
            */
            Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
                if let e = error
                {
                    print(e)
                }
                else
                {
                    // Navigate to the ChatViewController
                    //  self.performSegue(withIdentifier: "LoginToChat", sender: self)
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
            
        }
        
        
    }
    
}

