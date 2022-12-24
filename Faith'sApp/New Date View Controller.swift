//
//  New Date View Controller.swift
//  Faith'sApp
//
//  Created by Wyatt Bodle on 12/23/22.
//

import Foundation
import UIKit
import FirebaseDatabase


class NewDateViewController: UIViewController {
    
    @IBOutlet weak var dateIdeaTextField: UITextField!
    
    @IBOutlet weak var whereTextField: UITextField!
    
    @IBOutlet weak var priceSlider: UISegmentedControl!
    
    @IBOutlet var thisView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thisView.backgroundColor = COLOR
        
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        saveData(dateIdea: dateIdeaTextField.text ?? " ", whereText: whereTextField.text ?? " ", price: priceSlider.selectedSegmentIndex)
        
        self.performSegue(withIdentifier: "unwindDate", sender: self)

    }
    
    func saveData(dateIdea: String, whereText: String, price: Int){
        
        var priceString  = String()

        if(price == 0){
            priceString = "$"
        }else if(price == 1){
            priceString = "$$"
        }else{
            priceString = "$$$"
        }
        
        //Sets the reference for the database
        let REF = Database.database().reference().child("Date Ideas")
        
        //Creates a dictionary for messages and date
        let messageDictionary = ["Date": dateIdea, "Where": whereText, "Price": priceString]
        //Sets the message data
        REF.child("Date \(dateIdeaArray.count)").setValue(messageDictionary, withCompletionBlock: { err, ref in
            if let error = err {
                print("userInfoDictionary was not saved: \(error.localizedDescription)")
            } else {
                print("userInfoDictionary saved successfully!")
            }
        })
        
    }
    
}
