//
//  ContactDetailViewController.swift
//  Contacts App New
//
//  Created by Michael Manisa on 8/3/16.
//  Copyright © 2016 Michael Manisa. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet weak var birthdayField: UITextField!
    
    
    var recievedContact : Contact?
    
    var pickerData: [String] = [String]()
    
    var value = ""

//    func decodeEnum() {
//        if let x = recievedContact?.pet {
//            switch x {
//            case .Cat:
//                value = "Cat"
//            case .Dog:
//                value = "Dog"
//            case .Other:
//                value = "Other"
//            }
//        }
//    }
    
    
    
    func convertDateToNSDate(x : String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        if let y = dateFormatter.dateFromString(x) {
        
            return y
        }
        
        return nil
    }
    
    
    func convertDateToString(x : NSDate) -> String? {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        
        let convertedDate = dateFormatter.stringFromDate(x)
        
        print("DATE IS: \(convertedDate)")
        
        return convertedDate
    }
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //self.petPicker.dataSource = self
        //self.petPicker.delegate = self
        
        pickerData = ["cat", "dog", "other"]
        
//        saveStatus.text = ""
        
        //all of this sets the text fields
        firstNameField.text = recievedContact?.firstName
        lastNameField.text = recievedContact?.lastName
        emailAddressField.text = recievedContact?.emailAddress
        phoneNumberField.text = recievedContact?.phoneNumber
        
        if let rc = recievedContact?.gender {
            if rc == .Male {
                genderSwitch.setOn(true, animated: false)
            } else {
                genderSwitch.setOn(false, animated: false)
            }
        }
        
        let recievedDate = recievedContact?.birthday
        var convertedDate : String?
        if recievedDate != nil {
            
            print("THIS RAN!!!")
            convertedDate = convertDateToString(recievedDate!)
        }
        
        if let cd = convertedDate {
        
            birthdayField.text = cd
        }
        
        
//        let bdtext = birthdayField.text
//        let x = convertDate(bdtext!)
//        recievedContact?.birthday = x
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    //capturing picker data
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
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
            
            
            if genderSwitch.on {
                newInfo.gender = .Male
                print("changed to male")
            } else {
                newInfo.gender = .Female
                print("changed to female")
            }
            
            
            if let birthdayInTextField = birthdayField.text {
                
                let convertedDate = convertDateToNSDate(birthdayInTextField)
                newInfo.birthday = convertedDate
            }
            
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
        
        if genderSwitch.on {
            newContact.gender = .Male
            print("added as male")
        } else {
            newContact.gender = .Female
            print("added as female")
        }
        
        if let birthdayInTextField = birthdayField.text {
            
            let convertedDate = convertDateToNSDate(birthdayInTextField)
            newContact.birthday = convertedDate
        }
        
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
