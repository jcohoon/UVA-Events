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
    var datetime: NSDate?
    

    // *** need to add start, stop times, image url, cost, and probably more
    
    init(json: NSDictionary) {
        self.name = (json["summary"] as? String)!.decodeEnt()
        self.description = (json["description"] as? String)!.decodeEnt()
        self.html_url = json["link"] as? String
       
        // problem is that not all entries have "X-BEDEWORK-IMAGE", they're not always the 4th entry
            self.image_url = json["xproperties"]![4]["X-BEDEWORK-IMAGE"]!!["values"]!!["text"] as? String
        
        print(image_url)
        
    }
}
