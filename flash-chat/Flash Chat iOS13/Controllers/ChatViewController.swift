//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController 
{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()   // to interact with database
    
    var messages : [Messages] =
    [
        Messages(sender: "keshav@gmail.com", body: "Hey!"),
        Messages(sender: "nitin@gmail.com", body: "Hello!"),
        Messages(sender: "keshav@gmail.com", body: "What's up?")
    ]
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        // Set the title for the ChatViewController
        // title = "⚡️FlashChat"
        title = K.appName
        /*
         now i want to hide my back button in ChatViewController , because there is no
         point in that , so we will do that.
         */
        // Hide the back button since it's unnecessary in this context
        navigationItem.hidesBackButton = true
        
        
        /*
        I want to call a method called loadMessages . And this method loadMessages() shoul be able to pullup all the free current
        data that's inside our database. And then we are going to use it populate our TableView.
        */
        loadMessages()
    }
    
    func loadMessages()
    {
        /*
        // clearing the dummy messages
        messages = []
        
        // going to tap into our database
        db.collection(K.FStore.collectionName).getDocuments { (querySnapshot, error) in
            if let e = error
            {
                print("There was an issue retrieving data from FireStore.\(e)")
            }
            else
            {
                /*
                 if there is no error , then we want to be able to tap into this querySnapshot object and get hold of the data
                 that's contained in it.
                */
                if let snapShotDocuments = querySnapshot?.documents
                {
                    for doc in snapShotDocuments
                    {
                        //print(doc.data())
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String , let messageBody = data[K.FStore.bodyField] as? String
                        {
                            let newMessage = Messages(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.sync 
                            {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
         */
        
        
        /*
        -> if you wanted to get data just once, then you would use the getDocument method.But as we have a messaging app, it would be great if everytime a
           new message gets added to our database,then we simply just trigger this block over again , so that we can add the messages to our message array.
        ->To do this instead of calling 'getDocuments' we are going to change it to 'addSnampshotListener' .
        -> after this we will be able to add new messages in realTime , but it doesn't clear out the previous messages inside the messages array.
        -> so we changes the position of messages=[],
        -> after doing that , the order of messages is unorganized, because messages are organized on the basis of their IDs , first numerically and the
           alphabetically(the lower value will come first).
        -> so, to arrange the messages based on 'Time' we are adding a new key-value pair , and the value here is current time . So we will first add this
           in sendPressed Button.
        -> and then make changes in the 'loadMessages' function.
        ->
        */
        // going to tap into our database
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener { (querySnapshot, error) in
            
            self.messages = []
            
            if let e = error
            {
                print("There was an issue retrieving data from FireStore.\(e)")
            }
            else
            {
                /*
                 if there is no error , then we want to be able to tap into this querySnapshot object and get hold of the data
                 that's contained in it.
                */
                if let snapShotDocuments = querySnapshot?.documents
                {
                    for doc in snapShotDocuments
                    {
                        //print(doc.data())
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String , let messageBody = data[K.FStore.bodyField] as? String
                        {
                            let newMessage = Messages(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async
                            {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func sendPressed(_ sender: UIButton) 
    {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email
        {
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField:messageSender, K.FStore.bodyField:messageBody, K.FStore.dateField:Date().timeIntervalSince1970]) { (error) in
                if let e = error
                {
                    print("There was a issue saving data to firestore,\(e)")
                }
                else
                {
                    print("Succesfully saved Data.")
                    /*
                     we are inside a closure and trying to update the User Interface, remember that we should tap into
                     the DispathQueue.main.async
                     */
                    // we want to clear the text field the moment we send the message.
                    DispatchQueue.main.async
                    {
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
        
    }
    

    @IBAction func logOutPressed(_ sender: UIBarButtonItem) 
    {
        let firebaseAuth = Auth.auth()
        do 
        {
            try firebaseAuth.signOut()
            // what will happen if we click the "Log Out" button
            // below code will bring you back to the Welcome View Controller.
            /*
             The line navigationController?.popToRootViewController(animated: true) is
             used to navigate back to the root view controller of the navigation stack.
             When this line is executed, the app will return to the first view
             controller that was pushed onto the navigation stack, essentially
             dismissing all the intermediate view controllers.
            */
            navigationController?.popToRootViewController(animated: true)
        }
        catch let signOutError as NSError 
        {
            print("Error signing out: %@", signOutError)
        }
    }
}
/*
UITableViewDataSource is a protocol in iOS development that provides the data for a
UITableView. It defines methods that you, as a developer, must implement to populate
the table view with data.

Key Methods of UITableViewDataSource:
1.)numberOfSections(in tableView: UITableView):
Returns the number of sections in the table view. If you have a single section, you can
 return 1.
 
2.)tableView(_:numberOfRowsInSection:):
Returns the number of rows in a particular section of the table view. The table view
will call this method to know how many rows it should display.

3.)tableView(_:cellForRowAt:):
Returns the cell for a particular row in the table view. In this method, you dequeue
reusable cells, configure them, and return them to the table view for display.
*/
extension ChatViewController : UITableViewDataSource
{
    // Only two methods of this protocol are required, and they’re shown in the following example code.
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // this method will give number of rows
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 
    {
        // Dequeue a reusable cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        
//        putting some data in the cell
        
//        cell.textLabel!.text = "This is a Cell"
//        cell.textLabel!.text = "\(indexPath.row)"
        
        /* 
         Dequeue a reusable cell(going to use MessageCell as Real cell as we have created a custom cell which looks a bit amazing , so we will use that,
         so we can delete 'ReusableCell' from ChatViewController diagram)
        */
        
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        
        // Configure the cell with data(Message Cell has a label in it named 'label', so we can access that now )
        cell.label.text = messages[indexPath.row].body
        return cell
        */
        
        // as there are going to be 2 users so , we will be authorizing the message that whether it came from the logged in user or not, So
        let message = messages[indexPath.row]
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        // This is a message from the current user.
        if message.sender == Auth.auth().currentUser?.email
        {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.MessageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        // This is a message from the another user.
        else
        {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.MessageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
          return cell
    }
    
    
}



/*
-> In iOS development, any UI updates must occur on the main thread. If you're inside a closure or a background thread (for example, after a network request or heavy processing task), you need to switch to the main thread to perform UI updates. Using DispatchQueue.main.async ensures that the code within it will run on the main thread.
*/


