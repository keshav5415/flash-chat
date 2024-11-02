//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController 
{

    @IBOutlet weak var titleLabel: UILabel!
    
    // hide navigation bar as it's a waste on welcomeViewController
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated) // it will not change anything
        /*
        -> but it's really a good practice to get into the habit of always calling super whenever you override any \
           function from the superClass.
        */
        navigationController?.isNavigationBarHidden = true
    }
    
    // unhide navigation bar as we move to any other screen, So just before the view disappears and the next screen shows up , we tap into navigationController and reset 'isNavigationBarHidden' property to false/
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated) // it will not change anything
        /*
        -> but it's really a good practice to get into the habit of always calling super whenever you override any \
           function from the superClass.
        */
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var char_index = 0.0
        titleLabel.text = ""
        let titleText = K.appName         // "⚡️FlashChat"
        for letter in titleText
        {
            Timer.scheduledTimer(withTimeInterval: 0.1 * char_index, repeats: false) { timer in
                self.titleLabel.text?.append(letter)
            }
            char_index += 1
        }
       
    }

}

/*
-> There are 2 types of segues in this app
(i) One is from one View to another View
Eg:- RegisterViewController -> ChatViewController
     LoginViewController -> ChatViewController
(ii)Second One is Button to View
Eg:- Register Button -> RegisterViewController
     Login Button -> LoginViewController
*/


/*
 
*/
