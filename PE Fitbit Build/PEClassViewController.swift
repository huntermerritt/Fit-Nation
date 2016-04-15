//
//  PEClassViewController.swift
//  PE Fitbit Build
//
//  Created by hmerritt on 4/8/16.
//  Copyright © 2016 shedtechsolutions. All rights reserved.
//

import UIKit
import OAuthSwift

class PEClassViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var defaults = NSUserDefaults.standardUserDefaults()
    var classes: [String] = []
    var sendingClassName = ""
    var oauthswift : OAuth2Swift! = nil
    var parameters: [String: AnyObject]!
    var headers : [String: String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if defaults.arrayForKey("classes") != nil
        {
            classes = defaults.arrayForKey("classes") as! [String]
        }
        
        print(classes)
    }

    
    @IBAction func newClass(sender: AnyObject)
    {
        let alert = UIAlertController(title: "New Sub Group", message: "What do you want to name your new Sub Group?", preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler { (textfield) in
            textfield.placeholder = "Group Name"
            
            
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .Default, handler: { (action) in
            
            if alert.textFields![0].text != ""
            {
                self.classes.append(alert.textFields![0].text!)
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                self.defaults.setObject(self.classes, forKey: "classes")
                self.tableView.reloadData()
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: { (action) in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
            self.tableView.reloadData()
        }))
        
        
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return classes.count
    }
    
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = classes[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        sendingClassName = classes[indexPath.row]
        
        performSegueWithIdentifier("specific", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "specific"
        {
            
            let next = segue.destinationViewController as! specificClassViewController
            
            next.className = sendingClassName
            next.parameters = self.parameters
            next.oauthswift = self.oauthswift
            next.headers = self.headers

            
        }
        
    }
    

}
