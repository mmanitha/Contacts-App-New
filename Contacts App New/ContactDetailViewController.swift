//
//  ContactDetailViewController.swift
//  Contacts App New
//
//  Created by Michael Manisa on 8/3/16.
//  Copyright © 2016 Michael Manisa. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var emailAddressField: UITextField!
    
    
    var recievedContact : Contact?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        saveStatus.text = ""
        
        //all of this sets the text fields
        firstNameField.text = recievedContact?.firstName
        lastNameField.text = recievedContact?.lastName
        emailAddressField.text = recievedContact?.emailAddress
        phoneNumberField.text = recievedContact?.phoneNumber
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func update() {
        
        
    }
    
    /*    func updateContacts() {
     
     if let d = self.delegate {
     d.updateContactFunction(newInfo)
     }
     }
 
    func checkSuccess(x: Contact) {
        if x.firstName != recievedContact!.firstName || x.lastName != recievedContact!.lastName || x.emailAddress != recievedContact!.emailAddress || x.phoneNumber != recievedContact!.phoneNumber {
            saveStatus.text = "Changes Saved!"
        } else {
            saveStatus.text = "No Changes Detected"
        }
    }
*/
    //when button is pushed, grab data and save it in "newInfo" class and call updateContacts()
    @IBAction func saveChanges(sender: UIButton) {
        
        if let newInfo = self.recievedContact {
            
            newInfo.firstName = firstNameField.text!
            newInfo.lastName = lastNameField.text!
            newInfo.emailAddress = emailAddressField.text!
            newInfo.phoneNumber = phoneNumberField.text!
            
//            self.checkSuccess(newInfo)
            
            //            if saveStatus.text == "Changes Saved!" {
            
            if DataManager.sharedManager.updateContact(newInfo) == true {
                let center = NSNotificationCenter.defaultCenter()
                center.postNotificationName("CONTACT_CHANGED", object: nil, userInfo: ["Message": true])
            }
            
            //            }
            
            
            print("newInfo: " + newInfo.contactID)
        }
    }
    
    
    @IBAction func addButton(sender: UIButton) {
        
        let newContact = Contact()
        
        newContact.firstName = firstNameField.text!
        newContact.lastName = lastNameField.text!
        newContact.emailAddress = emailAddressField.text!
        newContact.phoneNumber = phoneNumberField.text!
        
        //DataManager.sharedManager.addContact(newContact)
        
        if DataManager.sharedManager.addContact(newContact) == true {
//            let center = NSNotificationCenter.defaultCenter()
//            center.postNotificationName("CONTACT_ADDED", object: nil, userInfo: ["Message": true])
        }
        
        
        
    }

    
    @IBAction func deleteButton(sender: UIButton) {
        
        if let x = recievedContact {
            
            DataManager.sharedManager.deleteContact(x)
        }
    }
    
    

    
}
