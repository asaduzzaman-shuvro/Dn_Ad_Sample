//
//  FeedJSONResolver.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 12/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import SwiftyJSON

class FeedJSONResolver {
    let dateFormatter = DateFormatter()
    let componentFactory: ComponentFactory
    
    init(pageType: PageType, componentFactory: ComponentFactory) {
        self.componentFactory = componentFactory
        self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
        self.dateFormatter.timeZone = TimeZone(identifier: "UTC")
    }
    
    fileprivate func flattenJSONArray(_ jsonArray: [JSON]) -> [JSON] {
        return jsonArray.flatMap({self.componentFactory.flattenJSON($0)})
    }
    
    fileprivate func resolveComponentsJSON(_ jsonArray: [JSON], groupIdentifier: String? = nil) -> [Component] {
        let flattenedJSONArray = self.flattenJSONArray(jsonArray)
        
        var isFirstArticleSummaryComponent = true
        var components = [Component] ()
        
        for index in flattenedJSONArray.startIndex..<flattenedJSONArray.endIndex {
            let feedComponent = self.componentFactory.resolveComponent(flattenedJSONArray[index])
            if !(feedComponent is UnknownComponent) && !feedComponent.isEmpty {
                switch Mirror(reflecting: feedComponent).subjectType {
                    default:
                        components.append(feedComponent)
                }
            }
        }
        
        return components
    }
    
    fileprivate func resolveIssue(_ editionJSON: JSON) -> String {
        guard !editionJSON.isEmpty else {
            return ""
        }

        return editionJSON["issue"].stringValue
    }
    
    func resolveJSON(_ json: JSON) -> Feed {
        let components = self.resolveComponentsJSON(json["components"].arrayValue)
        
        let newsFeedUpdateAt = dateFormatter.date(from: json["updated_at"].stringValue) ?? Date()
        let issue = self.resolveIssue(json["edition"])
        let newsFeed = Feed(updateAt: newsFeedUpdateAt, issue: issue, components: components)
        return newsFeed
    }
        
    func resolvePagedJSON(_ json: JSON) -> PagedFeed {
        let components = self.resolveComponentsJSON(json["components"].arrayValue)
        
        let totalContentCount = json["total"].uIntValue
        let currentOffset = json["offset"].uIntValue
        let newContentCount = json["size"].uIntValue
        return PagedFeed(totalContentCount: totalContentCount, currentOffset: currentOffset, newContentCount: newContentCount, components: components)
    }
    
    func resolveJSON(_ json: JSON, isfirstPage firstPageFlag: Bool, isLastPage lastPageFlag: Bool) -> PagedFeed {
        let totalContentCount = json["total"].uIntValue
        let currentOffset = json["offset"].uIntValue
        let newContentCount = json["size"].uIntValue
        
        var components = [Component] ()
        
        
        components.append(contentsOf: self.resolveComponentsJSON(json["components"].arrayValue))
                
        return PagedFeed(totalContentCount: totalContentCount, currentOffset: currentOffset, newContentCount: newContentCount, components: components)
    }
}

