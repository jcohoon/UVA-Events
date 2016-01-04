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
    
    init(json: NSDictionary) {
        self.name = (json["summary"] as? String)!.decodeEnt()
        self.description = (json["description"] as? String)!.decodeEnt()
        self.html_url = json["link"] as? String
    }
}
