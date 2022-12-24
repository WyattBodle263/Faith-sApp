//
//  New Message View Controller.swift
//  Faith'sApp
//
//  Created by Wyatt Bodle on 12/21/22.
//

import Foundation
import UIKit
import FirebaseDatabase

class NewMessageViewController: UIViewController{
    //New Message textfield
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet var newView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newView.backgroundColor = COLOR
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
                    self.textField.inputAccessoryView = toolbar
        }
        
        //Dimisses keyboard when done button is hit
        @objc func dismissMyKeyboard() {
                view.endEditing(true)
            }
    
    //When send button is hit
    
    @IBAction func messageSent(_ sender: Any) {
        if(textField.text != "" ){
            saveData(newMessage: textField.text ?? "", messageCount: messageArray.count)
            self.performSegue(withIdentifier: "unwindToRootViewController", sender: self)
        }
    }
    //Back button is pressed
    @IBAction func backPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToRootViewController", sender: self)
    }
    //Saves the data the was sent
    func saveData(newMessage: String, messageCount: Int){
        
        //Sets the reference for the database
        let REF = Database.database().reference().child("User").child(USER)
        
        //Creates a dictionary for messages and date
        let scoreDictionary = ["Message": newMessage,
                               "Date": getTimeStampDateString()] as [String : Any]
        //Sets the message data
        REF.child("Message \(messageCount)").setValue(scoreDictionary, withCompletionBlock: { err, ref in
            if let error = err {
                print("userInfoDictionary was not saved: \(error.localizedDescription)")
            } else {
                print("userInfoDictionary saved successfully!")
            }
        })
        
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
    
    
}
