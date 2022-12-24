//
//  ViewController.swift
//  Faith'sApp
//
//  Created by Wyatt Bodle on 12/8/22.
//

import UIKit
import FirebaseDatabase

public let USER = "Faith"
public let RECIEVER = "Wyatt"
//Faith Color: AFE1AF
//public let COLOR = hexStringToUIColor(hex: "#AFE1AF")
//Wyatt Color:
public var COLOR = hexStringToUIColor(hex: "#BFA1AF")

public var messageArray = [String]()
public var dateArray = [String]()

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ourTimeLabel: UILabel!
    
    //Our time since reference date
    
    let OUR_TIME = 669428280
    
    let REFRESH_CONTROL = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Sets the background color
        
        if(USER.elementsEqual("Faith")){
            COLOR = hexStringToUIColor(hex: "#AFE1AF")
        }else{
            COLOR = hexStringToUIColor(hex: "#BFA1AF")

        }
        mainView.backgroundColor = COLOR
        tableView.backgroundColor = COLOR
        
        //Re-gets our date every second to update
        tableView.delegate = self
        tableView.dataSource = self
        //Creates the timer for our date
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            let DATE_STRING = caluclateDate()
            self.ourTimeLabel.text = DATE_STRING
        })
        //Adds a refresh to the top of the table
        REFRESH_CONTROL.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        REFRESH_CONTROL.tintColor = UIColor.black
        tableView.addSubview(REFRESH_CONTROL) // not required when using UITableViewController
        getData()
    }
    @objc func refresh(_ sender: AnyObject) {
           // Code to refresh table view
            getData()
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getData()
        
        
    }
    
    
    //Function to get the tableview to reload
       func fetchSheets() {
           
           DispatchQueue.main.async {
               self.tableView.reloadData()
           }
           
       }
    //Gets the data from the database
    func getData(){
        
        // Making a reference
               let REF = Database.database().reference(withPath: "User/\(RECIEVER)")
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
                               if(!messageArray.contains(message ?? "")){
                                   messageArray.append(message ?? "")
                                   dateArray.append(date ?? "")
                               }
                              
                               
                               print(messageArray)
                               print(dateArray)

                               // Print the values for each child or do whatever you want
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
    
    //This will add the cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    //sets the data of the tableview labels
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        let thisMessage = messageArray[indexPath.row]
        let thisDate = dateArray[indexPath.row]
        cell.textLabel?.text = thisMessage
        cell.detailTextLabel?.text = thisDate
        cell.textLabel?.font = UIFont(name: "\(USER)font", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "\(USER)font", size: 12)

        return cell
    }
    //When the cell is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMessage = messageArray[indexPath.row]
        selectedDate = dateArray[indexPath.row]
        unwindIdentifier = "unwindRoot"
        sentBackgroundcolor = COLOR
        self.performSegue(withIdentifier: "cellPressed", sender: self)
        
    }
    //Defines the height of the cell
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            return 60
        }
    
    //Anchor for unwind segue
        @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
            print("Unwind to Main View Controller")
            getData()
        }
    
}
