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
    var image_url: String?
    var start_time: NSDate?
    var end_time: NSDate?
    

    // *** need to add start, stop times, image url, cost, and probably more
    
    init(json: NSDictionary) {
        self.name = (json["summary"] as? String)!.decodeEnt()
        self.description = (json["description"] as? String)!.decodeEnt()
        self.html_url = json["link"] as? String
        
        //format date **** still need to add condition for date without time
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "US_en")
        formatter.dateFormat = "yyyymmdd'T'HHmmss"
        
        self.start_time = formatter.dateFromString((json["start"]!["datetime"] as? String)!)
        self.end_time = formatter.dateFromString((json["end"]!["datetime"] as? String)!)

        // problem is that not all entries have "X-BEDEWORK-IMAGE", they're not always the 4th entry
        
        // ¿solution is finding index of X-BEDEWORK-IMAGE first?
        
        // ********  i'm so close here it seems. valueForKeyPath has found the right value but it retains the empty, wrong values as well
        let imgIDX = (json["xproperties"]!.valueForKeyPath("X-BEDEWORK-IMAGE.values.text"))!
        print(imgIDX)
//        let imgIDX = (json["xproperties"]!.valueForKeyPath("X-BEDEWORK-IMAGE.values.text"))! as! Array<String>
        let imgIDX2 = imgIDX as! Array<String>
        print(imgIDX2)
        for item in imgIDX2 {
            if item != ""{
                self.image_url = item
            }
        }
//        let imgIDX3 = imgIDX2.filteredArrayUsingPredicate(format: "name contains [c] %@")

//            ).filteredArrayUsingPredicate(format: "name contains[c] %@")
//        let keysToRemove = imgIDX.keys.array.filter { imgIDX[$0]! !== nil }

//        self.image_url = (imgIDX as! [NSArray])[0] as? String
        print(imgIDX)
//            self.image_url = json["xproperties"]![(json["xproperties"] as! Array).indexOf("X-BEDEWORK-IMAGE")!]!["X-BEDEWORK-IMAGE"]!!["values"]!!["text"] as? String
//        let imgIdx: Int = (json[14] as! Array).indexOf("X-BEDEWORK-IMAGE")!
//        self.image_url = json["xproperties"]![(json["xproperties"]?.indexOfObject("X-BEDEWORK-IMAGE"))!]!["X-BEDEWORK-IMAGE"]!!["values"]!!["text"] as? String
        
//        print(image_url)
        
    }
}
