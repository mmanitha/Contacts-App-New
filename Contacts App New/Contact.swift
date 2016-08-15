//
//  Contact.swift
//  Contacts Homework
//
//  Created by Michael Manisa on 7/19/16.
//  Copyright © 2016 Michael Manisa. All rights reserved.
//

import Foundation

class Contact : NSObject, NSCoding {
    
    enum Gender : Int {
        case Male = 1
        case Female = 2
    }
   
    func convertDate(x : String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        let y = dateFormatter.dateFromString(x)
        
        
        return y!
    }

    var firstName : String?
    var lastName : String?
    var phoneNumber : String?
    var emailAddress : String?
    var contactID : String = NSUUID().UUIDString
    var gender : Gender = .Male
    var birthday : NSDate?
    
    init(firstName: String, lastName: String, phoneNumber: String, emailAddress: String, gender: Gender, birthday: NSDate?) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.emailAddress = emailAddress
        self.gender = gender
        self.birthday = birthday
        
    }
    
    
    override init() {
        
        super.init()
    }
    
    
    @objc required init?(coder aDecoder: NSCoder) {
        
        self.firstName = aDecoder.decodeObjectForKey("FIRSTNAME") as? String
        self.lastName = aDecoder.decodeObjectForKey("LASTNAME") as? String
        self.phoneNumber = aDecoder.decodeObjectForKey("PHONENUMBER") as? String
        self.emailAddress = aDecoder.decodeObjectForKey("EMAILADDRESS") as? String
        self.contactID = (aDecoder.decodeObjectForKey("CONTACTID") as? String)!
        
        if let genderValue = aDecoder.decodeObjectForKey("GENDER") as? Int {
            
            self.gender = Gender(rawValue: genderValue)!
        }
        
        self.birthday = aDecoder.decodeObjectForKey("BIRTHDAY") as? NSDate
        
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        
        if let fn = self.firstName {
            aCoder.encodeObject(fn, forKey: "FIRSTNAME")
        }
        
        if let ln = self.lastName {
            aCoder.encodeObject(ln, forKey: "LASTNAME")
        }
        
        if let pn = self.phoneNumber {
            aCoder.encodeObject(pn, forKey: "PHONENUMBER")
        }
        
        if let ea = self.emailAddress {
            aCoder.encodeObject(ea, forKey: "EMAILADDRESS")
        }
        
        aCoder.encodeObject(self.contactID, forKey: "CONTACTID")
        
        
        aCoder.encodeObject(gender.rawValue, forKey: "GENDER")
        
        if let bd = self.birthday {
            
            aCoder.encodeObject(bd, forKey: "BIRTHDAY")
        }
        
    }
    
    
    
}
