//
//  Calculate Date.swift
//  Faith'sApp
//
//  Created by Wyatt Bodle on 12/21/22.
//
/* File used to caluclate date and is refered to in the main View Controller */


import Foundation
import UIKit
import FirebaseDatabase

//Our time converted into a time from //https://blog.paddlefish.net/?page_id=90
let OUR_TIME = 669428280

//Calculates the difference between dates
func caluclateDate() -> String{
    //Our date
    let UPDATED_DATE = Date(timeIntervalSinceReferenceDate: TimeInterval(OUR_TIME + 86436))
    
    //Time that works: 669514716
    //Our time: 669428280
    //Difference: 86436
    
    
    //Subtract the dates
    let INTERVAL = Date() - UPDATED_DATE
    //var to return
    var returnYear = Int()
    var returnMonth = Int()
    var returnDay = Int()
    var returnHour = Int()
    var returnMinute = Int()
    var returnSecond = Int()
    //String to return
    var returnYearString = "Years"
    var returnMonthString = "Months"
    var returnDayString = "Days"
    var returnHourString = "Hours"
    var returnMinuteString = "Minutes"
    var returnSecondString = "Seconds"
    
    //Gets the amount of years
    returnYear = INTERVAL.year ?? 0
    //Gets the amount of months by taking the total amount of months and subtract by the year * 12 months
    returnMonth = ((INTERVAL.month ?? 0) - returnYear * 12)
    //Gets the month of the start date to calcualte the difference in months
    let MONTH_COMPONENT = UPDATED_DATE.get(.month)
    //Int to hold data
    let NUM_DAYS = getDay(startMonth: MONTH_COMPONENT, months: returnMonth)
    
    //Returns the days by the difference of days from the number of days in the year and month
    returnDay = ((INTERVAL.day ?? 0) - NUM_DAYS) - (returnYear * 365)
    //Return hour subtracts the times before it to now
    returnHour = (INTERVAL.hour ?? 0) - (returnYear * 8760) - (NUM_DAYS * 24) - (returnDay * 24)
    //Returns the minute subtracting everything before
    returnMinute = (INTERVAL.minute ?? 0) - (returnYear * 525600) - (NUM_DAYS * 1440) - (returnDay * 1440) - (returnHour * 60)
    
    returnSecond = (INTERVAL.second ?? 0) - (returnYear * 31536000) - (NUM_DAYS * 86400) - (returnDay * 86400) - (returnHour * 3600) - (returnMinute * 60)
    
    //If there is only one of any of the times make their string singular
    if(returnYear == 1){
        returnYearString = "Year"
    }
    if(returnMonth == 1){
        returnMonthString = "Month"
    }
    if(returnDay == 1){
        returnDayString = "Day"
    }
    if(returnHour == 1){
        returnHourString = "Hour"
    }
    if(returnMinute == 1){
        returnMinuteString = "Minute"
    }
    if(returnSecond == 1){
        returnSecondString = "Second"
    }
    
    return "\(returnYear) \(returnYearString), \(returnMonth) \(returnMonthString), \(returnDay) \(returnDayString), \(returnHour) \(returnHourString), \(returnMinute) \(returnMinuteString), \(returnSecond) \(returnSecondString)"
}

//Gets the months based on the start motnhs because there are a different number of days for each month
func getDay(startMonth: Int, months: Int) -> Int{
    
    var subtractionSum = 0
    var startMonth = startMonth
    
    if(months == 0){
        return 0
    }
    
    //Runs from 1 to x amount of months
    for _ in 1...months {
        
        if(startMonth == 1){
            subtractionSum += 31
            startMonth += 1
        }else if(startMonth == 2){
            subtractionSum += 28
            startMonth += 1
        }else if(startMonth == 3){
            subtractionSum += 31
            startMonth += 1
        }else if(startMonth == 4){
            subtractionSum += 30
            startMonth += 1
        }else if(startMonth == 5){
            subtractionSum += 31
            startMonth += 1
        }else if(startMonth == 6){
            subtractionSum += 30
            startMonth += 1
        }else if(startMonth == 7){
            subtractionSum += 31
            startMonth += 1
        }else if(startMonth == 8){
            subtractionSum += 31
            startMonth += 1
        }else if(startMonth == 9){
            subtractionSum += 30
            startMonth += 1
        }else if(startMonth == 10){
            subtractionSum += 31
            startMonth += 1
        }else if(startMonth == 11){
            subtractionSum += 30
            startMonth += 1
        }else if(startMonth == 12){
            subtractionSum += 31
            startMonth = 1
        }
        
    }
    
    return subtractionSum
}


extension Date {

static func -(recent: Date, previous: Date) -> (year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
    let YEAR = Calendar.current.dateComponents([.year], from: previous, to: recent).year
    let DAY = Calendar.current.dateComponents([.day], from: previous, to: recent).day
    let MONTH = Calendar.current.dateComponents([.month], from: previous, to: recent).month
    let HOUR = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
    let MINUTE = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
    let SECOND = Calendar.current.dateComponents([.second], from: previous, to: recent).second

    return (year: YEAR, month: MONTH, day: DAY, hour: HOUR, minute: MINUTE, second: SECOND)
}
    
func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }

}

//Allows for a hex to be a UICOlor
func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
