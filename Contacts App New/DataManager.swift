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
    
    

    init() {
        self.contactList = [Contact]()
        
        //self.contactList = loadContacts()
        
        //
        //        let ajbday = DataManager.sharedManager.convertDate("Aug 10, 2016")
        //        var aj = Contact(firstName: "Aj", lastName: "Coley", phoneNumber: "470-939-3942", emailAddress: "acoley@gmail.com", pet: .Cat, birthday: ajbday)
        //
        //        var bbday = DataManager.sharedManager.convertDate("Aug 10, 2016")
        //        var brandon = Contact(firstName: "Brandon", lastName: "Green", phoneNumber: "493-299-9234", emailAddress: "bgeen@gmail.com", pet: .Cat, birthday: bbday)
        //
        //        var cbday = DataManager.sharedManager.convertDate("Aug 10, 2016")
        //        var caleda = Contact(firstName: "Caleda", lastName: "Champagne", phoneNumber: "293-492-4322", emailAddress: "cchampagne@gmail.com", pet: .Dog, birthday: cbday)
        //
        //        var rjbday = DataManager.sharedManager.convertDate("Aug 10, 2016")
        //        var rj = Contact(firstName: "Rj", lastName: "Coley", phoneNumber: "470-939-3942", emailAddress: "acoley@gmail.com", pet: .Other, birthday: rjbday)
        //        
        //
        
    }
    
    //returns the contactList array
    func getContacts() -> [Contact] {
        
        self.contactList = loadContacts()
        
        return self.contactList
    }
    
    //updates contactList
    func updateContact(updatedContact : Contact) -> Bool {
        
        
        let filteredList = self.contactList.filter{$0.contactID == updatedContact.contactID}
    

        if filteredList.count > 0 {
            
            let c = filteredList[0]
                
            c.firstName = updatedContact.firstName
            c.lastName = updatedContact.lastName
            c.emailAddress = updatedContact.emailAddress
            c.phoneNumber = updatedContact.phoneNumber
            c.gender = updatedContact.gender
            c.birthday = updatedContact.birthday
            
            self.saveContacts()
            
            publishMessage(true)
            
            return true
            
        }
        
        return false
    }

    
        
//        for c in self.contactList {
//            
//            if c.contactID == updatedContact.contactID {
//                c.firstName = updatedContact.firstName
//                c.lastName = updatedContact.lastName
//                c.emailAddress = updatedContact.emailAddress
//                c.phoneNumber = updatedContact.phoneNumber
//                c.gender = updatedContact.gender
//                c.birthday = updatedContact.birthday
//                
//                self.saveContacts()
//                
//                publishMessage(true)
//                
//                return true
//            }
//        }
//        
//        return false
//    }
    
    
    
    
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
        
        //    self.contactList += [aj, brandon, caleda, rj]
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