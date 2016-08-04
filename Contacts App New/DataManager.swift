//
//  DataManager.swift
//  Contacts Homework
//
//  Created by Michael Manisa on 8/1/16.
//  Copyright © 2016 Michael Manisa. All rights reserved.
//

import Foundation

class DataManager {
    
    //    var sendContact : Int?
    
    private var contactList : [Contact]
    
    static let sharedManager = DataManager()
    
    var aj = Contact(firstName: "Aj", lastName: "Coley", phoneNumber: "470-939-3942", emailAddress: "acoley@gmail.com")
    var brandon = Contact(firstName: "Brandon", lastName: "Green", phoneNumber: "493-299-9234", emailAddress: "bgeen@gmail.com")
    var caleda = Contact(firstName: "Caleda", lastName: "Champagne", phoneNumber: "293-492-4322", emailAddress: "cchampagne@gmail.com")
    var rj = Contact(firstName: "Rj", lastName: "Coley", phoneNumber: "470-939-3942", emailAddress: "acoley@gmail.com")

    init() {
        self.contactList = [Contact]()
        //self.contactList = loadContacts()
    }
    
    //returns the contactList array
    func getContacts() -> [Contact] {
        
        self.contactList = loadContacts()
        
        return self.contactList
    }
    
    //updates contactList
    func updateContact(updatedContact : Contact) -> Bool {
        
        for c in self.contactList {
            
            if c.contactID == updatedContact.contactID {
                c.firstName = updatedContact.firstName
                c.lastName = updatedContact.lastName
                c.emailAddress = updatedContact.emailAddress
                c.phoneNumber = updatedContact.phoneNumber
                
                self.saveContacts()
                
                publishMessage(true)
                
                return true
            }
        }
        
        return false
    }
    
    
    
    
    func addContact(newContact: Contact) -> Bool {
        
        self.contactList.append(newContact)
        
        self.saveContacts()
        
        publishMessageAdd(true)
        
        return true
    }
    
    
    
    
    func deleteContact(contactToDelete: Contact) -> Bool {
        
        var index = 0
        
        for x in contactList {
            
            if x.contactID == contactToDelete.contactID {
                
                self.contactList.removeAtIndex(index)
                
                print("x.firstName \(x.firstName)")
                
                saveContacts()
                
                publishMessageDelete(true)
                
                return true
            }
            
            index += 1
        }
        
        return false
    }
    
    
    
    
    
    //publish notification
    
    func publishMessage(message:Bool) {
        
        NSNotificationCenter.defaultCenter().postNotificationName("CONTACT_CHANGED", object: self, userInfo: ["message" : message])
        
    }
    
    func publishMessageAdd(message:Bool) {
        
        NSNotificationCenter.defaultCenter().postNotificationName("CONTACT_ADDED", object: self, userInfo: ["message" : message])
        
    }
    
    func publishMessageDelete(message:Bool) {
        
        NSNotificationCenter.defaultCenter().postNotificationName("CONTACT_DELETED", object: self, userInfo: ["message" : message])
        
    }
    

    
    
    
    
    private func saveContacts() {
        
        let destinationPath = self.filePathForArchiving()
        NSKeyedArchiver.archiveRootObject(self.contactList, toFile:destinationPath)
        
    }
    
    
    private func loadContacts() -> [Contact] {
        
        if self.contactList.isEmpty {
        
            self.contactList += [aj, brandon, caleda, rj]
        }
        
        let destinationPath = self.filePathForArchiving()
        
        if let contacts : [Contact] = NSKeyedUnarchiver.unarchiveObjectWithFile(destinationPath) as? [Contact] {
            
            return contacts
        }
        
        return contactList
        
    }
    
    
    
    
    
    private func filePathForArchiving() -> String {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let destinationPath = "\(documentsPath)/SavedContacts"
        
        return destinationPath
    }
    
    
    
    
}