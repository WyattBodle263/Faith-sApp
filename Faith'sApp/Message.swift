//
//  Message.swift
//  Faith'sApp
//
//  Created by Wyatt Bodle on 12/8/22.
//

import Foundation

class Message{
    //Class that holds and allows us to get and set message fields
    private var message = String()
    private var date = String()
    
    //Constructs a new message with a message and a date
    init(newMessage: String, newDate: String) {
        self.message = newMessage
        self.date = newDate
    }
    
    func getMessage() -> String{
        return self.message
    }
    func getDate() -> String{
        return self.date
    }
    
}
