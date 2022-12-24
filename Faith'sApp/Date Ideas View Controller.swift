//
//  Date Ideas View Controller.swift
//  Faith'sApp
//
//  Created by Wyatt Bodle on 12/22/22.
//

import Foundation
import UIKit
import FirebaseDatabase

public var dateIdeaArray = [String]()
public var datePlaceArray = [String]()
public var priceArray = [String]()


class DateIdeaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    let REFRESH_CONTROL = UIRefreshControl()

    
    @IBOutlet var dateView: UIView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting delgates and background
        dateView.backgroundColor = COLOR
        tableView.delegate = self
        tableView.dataSource = self
        
        //Adds a refresh to the top of the table
        REFRESH_CONTROL.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        REFRESH_CONTROL.tintColor = UIColor.black
        tableView.addSubview(REFRESH_CONTROL)
        
        getData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getData()
        
        
    }
    //Refresh function
    @objc func refresh(_ sender: AnyObject) {
           // Code to refresh table view
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
               let REF = Database.database().reference(withPath: "Date Ideas")
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
                               let whereString = data["Where"] as? String
                               let price = data["Price"] as? String
                               
                               //If there is a new message then add it to the array
                               if(!dateIdeaArray.contains(date ?? "")){
                                   dateIdeaArray.append(date ?? "")
                                   datePlaceArray.append(whereString ?? "")
                                   priceArray.append(price ?? "")
                               }
                              
                               
                               print(dateIdeaArray)
                               print(dateIdeaArray)
                               print(priceArray)

                               // Print the values for each child or do whatever you want
                               self.fetchSheets()
                               self.REFRESH_CONTROL.endRefreshing()
                           }
                       }
                   }else{
                       dateIdeaArray = [String]()
                       dateIdeaArray = [String]()
                       priceArray = [String]()
                       
                       self.fetchSheets()
                       self.REFRESH_CONTROL.endRefreshing()
                   }
               })
    }
    
    
    
    //Anchor for unwind segue
        @IBAction func unwindToDateViewController(segue: UIStoryboardSegue) {
            print("Unwind to Date Idea View Controller")
            getData()
        }
    
    //This will add the cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateIdeaArray.count
    }
    //sets the data of the tableview labels
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        let thisDateIdea = dateIdeaArray[indexPath.row]
        let thisPrice = priceArray[indexPath.row]
        cell.textLabel?.text = thisDateIdea
        cell.detailTextLabel?.text = thisPrice

        return cell
    }
    //When the cell is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    //Defines the height of the cell
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            return 60
        }
    
}
