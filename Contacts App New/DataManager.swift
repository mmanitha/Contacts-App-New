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
        
        fetchContacts()
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
    
    
    
    
    
    
    
    //function to parse contacts
    
    
    
    private func parseContact(jsonDict : [String:AnyObject]) -> Contact {
        
        let newContact = Contact()
        
        
        //Name
        if let fullName = jsonDict["name"] as? String {
            
            let names = parseName(fullName)
            
            newContact.firstName = names?.first
            newContact.lastName = names?.last
            
        }
        
        //phoneNumber
        newContact.phoneNumber = jsonDict["phone"] as? String
        
        //emailAddress
        newContact.emailAddress = jsonDict["email"] as? String
        
        //contactID
        if let contactId = jsonDict["id"] as? NSNumber {
            
            newContact.contactID = String(contactId)
        }
        

        
        return newContact
    }
    
    
    //parsing the fullname to first and last names
    
    func parseName(fullName : String) -> (first: String , last: String)? {
        
        let names = fullName.componentsSeparatedByString(" ")
        
        if names.count > 1 {
            
            return (first:names[0], last:names[1])
        }
        
        return nil
    }

    
    
    
    //function to fetch contacts
    
    func fetchContacts() {
        
        let url = NSURL(string: "http://jsonplaceholder.typicode.com/users")
        let request = NSURLRequest(URL: url!)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {data, response, err in
            
            if err != nil {
                print("Got an error: \(err)")
            }
            else {
                var contactList = [Contact]()
                
                do {
                    
                    if let results : [[String : AnyObject]] = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? [[String : AnyObject]] {
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            for jsonDict in results {
                                
                                let newContact = self.parseContact(jsonDict)
                                
                                contactList.append(newContact)
                                
                                print(contactList)
                                
                                self.saveContacts()
                                
                                self.publishMessageAdd(true)
                            }
                            
                        })
                    }
                    
                    
                }
                catch {
                    print("Failed to fetch: \(error)")
                }
            }
        }
        
        task.resume()
        
    }
    
    
    
    
}