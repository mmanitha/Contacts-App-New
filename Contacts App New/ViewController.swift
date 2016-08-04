//
//  ViewController.swift
//  Contacts App New
//
//  Created by Michael Manisa on 8/3/16.
//  Copyright © 2016 Michael Manisa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tabeView: UITableView!
    
    var contactList : [Contact]?
    
    var sendContact : Int?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tabeView.dataSource = self
        self.tabeView.delegate = self
        
        
        self.contactList = DataManager.sharedManager.getContacts()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(contactChangedFunction), name: "CONTACT_CHANGED", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onNewContactAdded), name: "CONTACT_ADDED", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onContactDeleted), name: "CONTACT_DELETED", object: nil)
        
    }
    
    
    //recieve notification
    @objc func contactChangedFunction(msg:NSNotification) {
        
        if let userInfo = msg.userInfo as? [String : Bool] {
            if userInfo["message"] == true {
                
                self.contactList = DataManager.sharedManager.getContacts()
                self.tabeView.reloadData()
            }
        }
    }
    
    @objc func onNewContactAdded(msg:NSNotification) {
        
        if let userInfo = msg.userInfo as? [String : Bool] {
            if userInfo["message"] == true {
                
                self.contactList = DataManager.sharedManager.getContacts()
                self.tabeView.reloadData()
            }
        }
        
    }
    
    @objc func onContactDeleted(msg: NSNotification) {
        
        if let userInfo = msg.userInfo as? [String : Bool] {
            if userInfo["message"] == true {
        self.contactList = DataManager.sharedManager.getContacts()
        self.tabeView.reloadData()
            }
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //table funcs
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let x = contactList {
            return x.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let x = contactList {
            cell.textLabel?.text = x[indexPath.row].firstName! + " " + x[indexPath.row].lastName!
        }
        return cell
    }
    
    //tableView Delegate Code
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        sendContact = indexPath.row
        
        self.performSegueWithIdentifier("showDetail", sender: self)
    }
    
    //push content
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let index = sendContact {
            if let NextVC = segue.destinationViewController as? ContactDetailViewController {
                if let x = contactList {
                    NextVC.recievedContact = x[index]
                }
                
                //SETTING THE DELEGATE!!! ¯\_(ツ)_/¯
                //NextVC.delegate = self
            }
        }
    }
    
}

