//
//  ViewController.swift
//  UVA Events
//
//  Created by James Cohoon on 1/1/16.
//  Copyright © 2016 Alliterative Software. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var events = [Event]()
    @IBOutlet weak var eventSummaryLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    
    @IBOutlet weak var eventDescriptionLabel: UILabel!

    @IBOutlet weak var eventImage: UIImageView!
    
    // set number of rows in table to number of events
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    // populate tableview cells with JSON event data
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = events[indexPath.row].name
        cell.detailTextLabel?.text = events[indexPath.row].description
        return cell
    }

    // update event details labels on tableview cell focus
    func tableView(tableView: UITableView, didUpdateFocusInContext context: UITableViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        if let nextIndexPath = context.nextFocusedIndexPath {
            eventSummaryLabel.text = events[nextIndexPath.row].name
            e   ventDescriptionLabel.text = events[nextIndexPath.row].description
            
//* WIP
            
            if let imgURL = NSURL(string: events[nextIndexPath.row].image_url!) {
                do {
                    let imageData: NSData = try NSData(contentsOfURL: imgURL)!
                    eventImage.image = UIImage(data:imageData)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            
//*/
            
            
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        
        //fetch JSON feed
        let eventsURL = NSURL(string: "http://calendar.virginia.edu/webcache/v1.0/jsonDays/90/list-json-Main/%28catuid%21%3D%278a7a83f4-3a110d79-013a-1ea6fa11-00007e3d%27%26catuid%21%3D%278a7a83f4-3764ec3f-0137-8584da9b-000008fd%27%26catuid%21%3D%278a7a83f4-36cb0460-0137-4c4a353a-00000470%27%26catuid%21%3D%278a7a83f4-374d2f1c-0137-6135c705-000003b8%27%29/no--object.json")
        
        // build dictionary from json data and then create events array
        if let JSONData = NSData(contentsOfURL: eventsURL!) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(JSONData, options: NSJSONReadingOptions.AllowFragments)
                    let bwEventListArray = json as? NSDictionary
    
                            let eventsArray = bwEventListArray!["bwEventList"]!["events"] as? [NSDictionary]
                            for item in eventsArray! {events.append(Event(json: item))
                            }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

