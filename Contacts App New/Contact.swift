//
//  Contact.swift
//  Contacts Homework
//
//  Created by Michael Manisa on 7/19/16.
//  Copyright © 2016 Michael Manisa. All rights reserved.
//

import Foundation

class Contact : NSObject, NSCoding {
    
    var firstName : String?
    var lastName : String?
    var phoneNumber : String?
    var emailAddress : String?
    var contactID : String = NSUUID().UUIDString
    
    init(firstName: String, lastName: String, phoneNumber: String, emailAddress: String) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.emailAddress = emailAddress
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
        
    }
    
    
    
}
