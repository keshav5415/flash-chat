//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController 
{

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) 
    {
        
        /*
        what does this says is if emailTextfield.text is not 'nil' and it can be turned into a string
        and stored inside this propert called email , and the same thing with the password.And only if
        both of these things do not fail, then do we continue to the next stage which is to actually
        create our user.
        */
        if let email = emailTextfield.text, let password = passwordTextfield.text
        {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                if let e = error
                {
                    print(e)
                }
                else
                {
                    // Navigate to the ChatViewController
                    //  self.performSegue(withIdentifier: "RegisterToChat", sender: self)
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
                
            }
            
        }
    }
    
}
