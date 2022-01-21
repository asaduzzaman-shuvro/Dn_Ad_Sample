//
// Created by Apps AS on 26/01/16.
// Copyright (c) 2016 All rights reserved.
//
// FACTORY
// Create news feed related component from JSON.

import Foundation
import SwiftyJSON

class ComponentFactory {
    
    let dateFormatter = DateFormatter()
    var hideStockComponent : Bool = false
    
    init() {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
    }
    
    func flattenJSON(_ json: JSON) -> [JSON] {
        let type = json["type"].stringValue
        
        switch type {
        case "dn_events":
            return self.flattenedDNEventJSON(json)
        default:
            return [json]
        }
    }
    
    func resolveComponent(_ json: JSON) -> Component {
        let type = json["type"].stringValue
        switch type {
        case "ad_dfp":
            return json.decode(DFPAd.self)
        case "article_summary":
            return json.decode(ArticleSummary.self)
        default:
            return UnknownComponent(json: json)
        }
    }
        
    fileprivate func flattenedDNEventJSON(_ json: JSON) -> [JSON] {
        let groupId = json["type"].stringValue
        var jsonArray = [self.buildDNEventsHeaderJSON(json, groupId: groupId)]
        
        let componentsArray = json["components"].arrayValue
        jsonArray.append(contentsOf: componentsArray.map{self.buildUpDNEventsComponentJSON($0, groupId: groupId)})
        
        return jsonArray
    }
    
    private func buildUpDNEventsComponentJSON(_ json: JSON, groupId: String) -> JSON {
        var dict = json.dictionaryValue
        dict["group"] = self.buildUpGroupInfoJSON(groupId: groupId)
        
        return JSON(dict)
    }
    
    private func buildDNEventsHeaderJSON(_ json: JSON, groupId: String) -> JSON {
        return JSON([ "type" : "dn_events_header",
                      "group" : self.buildUpGroupInfoJSON(groupId: groupId),
                      "left_image_url" : json["dn_event_group_logo_url"].stringValue,
                      "left_image_home_url" : json ["dn_event_group_url"].stringValue,
                      "right_image_url" : json["dn_event_partner_logo_url"].stringValue,
                      "right_image_home_url" : json ["dn_event_partner_url"].stringValue])
    }
    
    private func buildUpGroupInfoJSON(groupId: String, skin: String = "", title: String = "") -> JSON {
        return JSON(["group_id" : groupId,
                     "skin" : "",
                     "title" : ""])
    }
}

extension String {
    var bool: Bool? {
        switch self.lowercased() {
        case "true":
            return true
        case "false":
            return false
        default:
            return nil
        }
    }
    
    init?(htmlEncodedString: String) {
        
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }        
        guard let attributedString = try? NSAttributedString(data: data, options: [
            .documentType : NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil) else {
            return nil
        }
        
        self.init(attributedString.string)
    }
    
}
