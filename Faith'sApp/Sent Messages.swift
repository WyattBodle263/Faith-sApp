//
//  Sent Messages.swift
//  Faith'sApp
//
//  Created by Wyatt Bodle on 12/22/22.
//

import Foundation
import UIKit
import FirebaseDatabase

public var sentBackgroundcolor = UIColor()

class SentMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var sentMessageArray = [String]()
    var sentDateArray = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var sentView: UIView!
    
    //When view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        //Sets the background color
        let faithsColor = hexStringToUIColor(hex: "#AFE1AF")
        if(!COLOR.isEqual(faithsColor)){
            sentView.backgroundColor = hexStringToUIColor(hex: "#AFE1AF")
            sentBackgroundcolor = hexStringToUIColor(hex: "#AFE1AF")
        }else{
            sentView.backgroundColor = hexStringToUIColor(hex: "#BFA1AF")
            sentBackgroundcolor = hexStringToUIColor(hex: "#BFA1AF")
        }
    }
    
    //When the view did load
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //Adds a refresh to the top of the table
        REFRESH_CONTROL.tintColor = UIColor.black
        self.REFRESH_CONTROL.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(self.REFRESH_CONTROL) // not required when using UITableViewController
        //fetches the sheets and gets data
        getData()
        
    }
    
    let REFRESH_CONTROL = UIRefreshControl()

    
    //Function to get the tableview to reload
       func fetchSheets() {
           
           DispatchQueue.main.async {
               self.tableView.reloadData()
               
           }
           
       }
    
    //Gets the data from the database that we sent
    func getData(){
        
        // Making a reference
               let REF = Database.database().reference(withPath: "User/\(USER)")
               REF.observeSingleEvent(of: .value, with: { (snapshot) in

                   // Printing the child count
                   print("There are \(snapshot.childrenCount) children found")

                   // Checking if the reference has some values
                   if snapshot.childrenCount > 0 {

                       // Go through every child
                       for data in snapshot.children.allObjects as! [DataSnapshot] {
                           if let data = data.value as? [String: Any] {

                               // Retrieve the data per child

                               // Puts data in a datebase
                               let date = data["Date"] as? String
                               let message = data["Message"] as? String
                               
                               //If there is a new message then add it to the array
                               if(!self.sentMessageArray.contains(message ?? "")){
                                   self.sentMessageArray.append(message ?? "")
                                   self.sentDateArray.append(date ?? "")
                               }
                              

                               // Print the values for each child or do whatever you want
                               print("SENT MESSAGE ARRAY")
                               print("__________________")
                               print(self.sentMessageArray)
                               print(self.sentDateArray)
                               self.fetchSheets()
                               self.REFRESH_CONTROL.endRefreshing()
                           }
                       }
                   }else{
                       messageArray = [String]()
                       dateArray = [String]()
                       self.fetchSheets()
                       self.REFRESH_CONTROL.endRefreshing()
                   }
               })
    }
    //Refresh
    @objc func refresh(_ sender: AnyObject) {
           // Code to refresh table view
            getData()
        }
    //This will add the cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentMessageArray.count
    }
    //sets the data of the tableview labels
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        let thisMessage = sentMessageArray[indexPath.row]
        let thisDate = sentDateArray[indexPath.row]
        cell.textLabel?.text = thisMessage
        cell.detailTextLabel?.text = thisDate
        cell.textLabel?.font = UIFont(name: "\(RECIEVER)font", size: 20)
        cell.detailTextLabel?.font = UIFont(name: "\(RECIEVER)font", size: 14)
                
                return cell
    }
    //Defines the height of the cell
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            return 60
        }
    //When the cell is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMessage = sentMessageArray[indexPath.row]
        selectedDate = sentDateArray[indexPath.row]
        unwindIdentifier = "unwindSent"
        self.performSegue(withIdentifier: "sentCellPressed", sender: self)
        
    }
    
    //Unwinds the segue
    @IBAction func backPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindSentMessage", sender: self)
        
    }
    
    //Anchor for unwind segue
        @IBAction func unwindToSentViewController(segue: UIStoryboardSegue) {
            print("Unwind to Sent View Controller")
            getData()
        }
}
