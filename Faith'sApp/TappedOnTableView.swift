//
//  TappedOnTableView.swift
//  Faith'sApp
//
//  Created by Wyatt Bodle on 12/11/22.
//

import Foundation
import UIKit
import FirebaseDatabase
import SwiftUI

public var clickedMessage = ""
public var clickedDate = ""

class TappedOnTableView: UIViewController  {
    //Connections
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets the label
        messageLabel.text = clickedMessage
        dateLabel.text = clickedDate
        
    }
    
    @IBAction func backClicked(_ sender: Any) {
        //Unwind Segue
        self.performSegue(withIdentifier: "UnwindBaby", sender: self)
    }
}
