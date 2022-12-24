//
//  Cell For Row View Controller.swift
//  Faith'sApp
//
//  Created by Wyatt Bodle on 12/22/22.
//

import Foundation
import UIKit

public var selectedMessage = ""
public var selectedDate = ""
public var unwindIdentifier = ""

class CellForRowAtViewController: UIViewController{
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var thisView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thisView.backgroundColor = sentBackgroundcolor
        if(unwindIdentifier == "unwindRoot"){
            messageLabel.font = UIFont(name: "\(USER)font", size: 23)
            dateLabel.font = UIFont(name: "\(USER)font", size: 20)
        }else{
            messageLabel.font = UIFont(name: "\(RECIEVER)font", size: 23)
            dateLabel.font = UIFont(name: "\(RECIEVER)font", size: 20)
        }
        messageLabel.text = selectedMessage
        dateLabel.text = selectedDate
        
    }
    
    
    @IBAction func unwindButton(_ sender: Any) {
        self.performSegue(withIdentifier: unwindIdentifier, sender: self)

    }
    
}
