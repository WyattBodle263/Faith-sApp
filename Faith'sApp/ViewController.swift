//
//  ViewController.swift
//  Faith'sApp
//
//  Created by Wyatt Bodle on 12/8/22.
//

import UIKit
import FirebaseDatabase

//Colors
//Green
//#AFE1AF
//Blue
//#AFE1E6

public var user = "Faith"
public var sendTo = "Wyatt"

//Table view functions
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //Determines and returns the number of messages in the array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }

    //Defines whats in the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        let thisMessage = messageArray[indexPath.row]
        let thisDate = dateArray[indexPath.row]
        cell.textLabel?.text = thisMessage
        cell.textLabel?.font = UIFont(name: "Wyattfont", size: 20)
        cell.detailTextLabel?.text = thisDate
        cell.detailTextLabel?.font = UIFont(name: "Wyattfont", size: 15)
        
        return cell
    }
    //Defines the height of the cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    //Determines what happens when you clicked a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickedMessage = messageArray[indexPath.row]
        clickedDate = dateArray[indexPath.row]
        self.performSegue(withIdentifier: "clickedSegue", sender: self)

    }
    
    
    //Tableview Outlets
    @IBOutlet var messageTableView: UITableView!
    //Outlet to hide the view
    @IBOutlet weak var openingView: UIView!
    
    //Date we started dating
    let updatedDate = Date(timeIntervalSinceReferenceDate: 669510336)
    
    //Timer for counting down
    var timer = Timer()
    
    //Two arrays to hold the messages and the dates to populate the table view
    var messageArray = [String]()
    var dateArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Sets delegates
        messageTableView.delegate = self
        messageTableView.dataSource = self
        //Turns the label on the time
        timeLabel.transform = CGAffineTransformMakeRotation(-3.14/2)
        //Call to get the needed data
        getMessageData()
        calculateDate()
        //Timer repeating every 60 sec
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.calculateDate()
            self.fetchSheets()
        })
        //Sets the sideways label
        timeLabel.layer.anchorPoint = CGPoint(x: -0.1, y: 6.2)
        

    }
    
    @IBOutlet weak var timeLabel: UILabel!
    
    //Anchor for unwind segue
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        print("Unwind to Main View Controller")
        getMessageData()
        fetchSheets()
        
    }
    
    //Function to get the tableview to reload
    func fetchSheets() {
        
        DispatchQueue.main.async {
            self.messageTableView.reloadData()
        }
        
    }
    
    //Gets the amont of time we've been together
    func calculateDate() {
        
        let interval = Date() - updatedDate
        
        let finalYears = interval.year ?? 0 / 365

        let yearSubFactor = finalYears * 12
        let finalMonths = ((interval.month ?? 0) - yearSubFactor)

        let yearMultiFactor = finalYears * 365
        var monthSubFactor = Int()
        if finalMonths == 1 {
            
            monthSubFactor = 31
        
        } else if finalMonths == 2 {
            
            monthSubFactor = 61
        
        }else if finalMonths == 3 {
            
            monthSubFactor = 92
        
        }else if finalMonths == 4 {
            
            monthSubFactor = 122
        
        }else if finalMonths == 5 {
            
            monthSubFactor = 153
        
        }else if finalMonths == 6 {
            
            monthSubFactor = 184
        
        }else if finalMonths == 7 {
            
            monthSubFactor = 214
        
        }else if finalMonths == 8 {
            
            monthSubFactor = 245
        
        }else if finalMonths == 9 {
            
            monthSubFactor = 275
        
        }else if finalMonths == 10 {
            
            monthSubFactor = 306
        
        }else if finalMonths == 11 {
            
            monthSubFactor = 337
        
        }
        
        let finalDays = ((interval.day ?? 0) - yearMultiFactor) - monthSubFactor
        
        
        let daysSubFactorForHours = finalDays * 24
        let monthSubFactorForHours = monthSubFactor * 24
        let yearMultiFactorForHours = yearMultiFactor * 24
        
        let finalHours = ((interval.hour ?? 0) - yearMultiFactorForHours - monthSubFactorForHours - daysSubFactorForHours)
        
        let daysSubFactorForMinutes = finalDays * 24 * 60
        let monthSubFactorForMinutes = monthSubFactor * 24 * 60
        let yearMultiFactorForMinutes = yearMultiFactor * 24 * 60
        let hourMutiFactorForMinutes = finalHours * 60
        
        let finalMinutes = ((interval.minute ?? 0) - yearMultiFactorForMinutes - monthSubFactorForMinutes - daysSubFactorForMinutes - hourMutiFactorForMinutes)
        
        let daysSubFactorForSeconds = finalDays * 24 * 60 * 60
        let monthSubFactorForSeconds = monthSubFactor * 24 * 60 * 60
        let yearMultiFactorForSeconds = yearMultiFactor * 24 * 60 * 60
        let hourMultiFactorForSeconds = hourMutiFactorForMinutes * 60
        let minuteSubFactorForSeconds = finalMinutes * 60
        
        let finalSeconds = ((interval.second ?? 0) - yearMultiFactorForSeconds - monthSubFactorForSeconds - daysSubFactorForSeconds - hourMultiFactorForSeconds - minuteSubFactorForSeconds)
        
        var yearsPlural = "Years"
        
        if finalYears == 1 {
            
            yearsPlural = "Year"
        } else {
            
            yearsPlural = "Years"
        }
        var monthsPlural = "Months"
        
        if finalMonths == 1 {
            
            monthsPlural = "Month"
        } else {
            
            monthsPlural = "Months"
        }
        var daysPlural = "Days"
        
        if finalDays == 1 {
            
            daysPlural = "Day"
        } else {
            
            daysPlural = "Days"
        }
        var hoursPlural = "hours"
        
        if finalHours == 1 {
            
            hoursPlural = "Hour"
        } else {
            
            hoursPlural = "Hours"
        }
        var minutesPlural = "Minutes"
        
        if finalMinutes == 1 {
            
            minutesPlural = "Minute"
        } else {
            
            minutesPlural = "Minutes"
        }
        var secondsPlural = "Seconds"
        
        if finalSeconds == 1 {
            
            secondsPlural = "Second"
        } else {
            
            secondsPlural = "Seconds"
        }
        
        
        timeLabel.text = "\(finalYears) \(yearsPlural), \(finalMonths) \(monthsPlural), \(finalDays) \(daysPlural),\(finalHours) \(hoursPlural), \(finalMinutes) \(minutesPlural), \(finalSeconds) \(secondsPlural)"
        
        
    }
    
    
    
    
    
    
    //Gets the data from the firebase to be used in tableview
    
    func getMessageData() {
        // Making a reference
        let transactionRef = Database.database().reference(withPath: "\(user)/Messages")
        transactionRef.observeSingleEvent(of: .value, with: { (snapshot) in

            // Printing the child count
            print("There are \(snapshot.childrenCount) children found")

            // Checking if the reference has some values
            if snapshot.childrenCount > 0 {

                // Go through every child
                for data in snapshot.children.allObjects as! [DataSnapshot] {
                    if let data = data.value as? [String: Any] {

                        // Retrieve the data per child


                        // Puts data in a datebase
                        let date = data["date"] as? String
                        let message = data["message"] as? String
                        
                        //If there is a new message then add it to the array
                        if(!self.messageArray.contains(message ?? "")){
                            self.messageArray.append(message ?? "")
                            self.dateArray.append(date ?? "")
                        }
                       
                        
                        print(self.messageArray)
                        print(self.dateArray)

                        // Print the values for each child or do whatever you want
                        print("Message: \(message ?? "") \n Date: \(date ?? "")")
                    }
                }
            }
        })
        
    }

    
}

extension Date {

    static func -(recent: Date, previous: Date) -> (year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let year = Calendar.current.dateComponents([.year], from: previous, to: recent).year
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (year: year, month: month, day: day, hour: hour, minute: minute, second: second)
    }

}

