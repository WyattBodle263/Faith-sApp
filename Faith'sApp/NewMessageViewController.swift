//
//  ViewController.swift
//  Faith'sApp
//
//  Created by Wyatt Bodle on 12/8/22.
//

import UIKit
import FirebaseDatabase
public var ref = Database.database().reference().child(user)
public var refSent = Database.database().reference().child(sendTo)
public var messageCount = 0

class NewMessageViewController: UIViewController, UITextViewDelegate {
    
    
    //UIConnections
    @IBOutlet weak var newTextView: UITextView!
    
    //Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createToolBar()
        newTextView.delegate = self
        getCount()
        
    }
    
    
    //Function used to create a toolbar
    func createToolBar(){
        //Creates a new UIToolbar for the textView
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //Creates space to fill the bar with a done button at the end
                let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
                let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissMyKeyboard))
                toolbar.setItems([flexSpace, doneBtn], animated: false)
                toolbar.sizeToFit()
                self.newTextView.inputAccessoryView = toolbar
    }
    
    //Dimisses keyboard when done button is hit
    @objc func dismissMyKeyboard() {
            view.endEditing(true)
        }
    
    //When text begins to edit change the textfield to nothing
    func textViewDidBeginEditing(_ textView: UITextView) {
        newTextView.text = ""
    }
    
    //Gets the time that the message was sent in pacific time
    func getTimeStampDateString() -> String {
        let date = Date(timeIntervalSinceNow: 0.0)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "PST")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "MM/dd/yy h:mm a"
            let strDate = dateFormatter.string(from: date)
            return strDate
        }
    
    //When a message is sent
    @IBAction func messageSent(_ sender: Any) {
        
        if(newTextView.text != "" ){
            
            //Creates a new message object
            let newMessage = Message(newMessage: newTextView.text, newDate: getTimeStampDateString())
            
            //Creates a dictionary from it
            let messagesDictionary = ["message" : newMessage.getMessage(),
                                       "date" : newMessage.getDate()
                                       ]
            //Creates a folder
            let messageFolder = "Message \(messageCount)"


            //      ref.setValue(userInfoDictionary) { (error:Error?, ref:DatabaseReference) in
            //Sets the message data
            refSent.child("Messages").child(messageFolder).setValue(messagesDictionary, withCompletionBlock: { err, ref in
                if let error = err {
                    print("userInfoDictionary was not saved: \(error.localizedDescription)")
                } else {
                    print("userInfoDictionary saved successfully!")
                }
            })
            //Increment the Count
            messageCount+=1
            //Sets the message count
            refSent.child("Count").setValue(["Count": messageCount])
                    
            //Unwind Segue
            self.performSegue(withIdentifier: "unwindSend", sender: self)
        }else {
            newTextView.text = "Please Enter A Message"
            dismissMyKeyboard()
        }
        
    }
    
    //Gets the data from the firebase to be used in tableview
    
    func getCount() {
        // Making a reference
        let ref = Database.database().reference()
        ref.child("\(user)/Count/Count").observeSingleEvent(of: .value) { (snapshot) in
            let Count = snapshot.value as? Int
            messageCount = Count ?? 0
        }
    }
    
}

