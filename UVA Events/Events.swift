//
//  Events.swift
//  UVA Events
//
//  Created by James Cohoon on 1/1/16.
//  Copyright © 2016 Alliterative Software. All rights reserved.
//

import UIKit

extension String{
    func decodeEnt() -> String{
        do {
            let encodedData = self.dataUsingEncoding(NSUTF8StringEncoding)!
            let attributedOptions : [String: AnyObject] = [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
            ]
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            return attributedString.string
        } catch {
            fatalError("Unhandled error: \(error)")
        }
    }
}

class Event {
    
    var name: String?
    var description: String?
    var html_url: String?
    var image_url: String? = "http://www.virginia.edu/colp/images/originals/spacer.png"
    var start_time: NSDate?
    var end_time: NSDate?
    var cost: String?
    

    // *** need to add start, stop times, image url, cost, and probably more
    
    init(json: NSDictionary) {
        self.name = (json["summary"] as? String)!.decodeEnt()
        self.description = (json["description"] as? String)!.decodeEnt()
        self.html_url = json["link"] as? String
        self.cost = json["cost"] as? String
        if self.cost!.characters.count < 1 {
            self.cost = "Not listed."
        }

        
        //format date **** still need to add condition for date without time
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "US_en")
        formatter.dateFormat = "yyyymmdd'T'HHmmss"
        
        self.start_time = formatter.dateFromString((json["start"]!["datetime"] as? String)!)
        self.end_time = formatter.dateFromString((json["end"]!["datetime"] as? String)!)

        // problem was that not all entries have "X-BEDEWORK-IMAGE" and they do exist they're not always at the same index
        // alternate solution is finding index of X-BEDEWORK-IMAGE first?
        
        // grab the sub-array with the image key and filter it's members for strings
        let imgURLIndex = ((json["xproperties"]!.valueForKeyPath("X-BEDEWORK-IMAGE.values.text"))! as! Array<AnyObject>).filter { $0 is String }
        // if the array has a member set it as the event's image
        if imgURLIndex.count == 1 {
            if let imgURLString = imgURLIndex[0] as? String {
                self.image_url = imgURLString
            }
        }
    }
}
