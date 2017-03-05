//
//  TweetEntity.swift
//  Twitter
//
//  Created by Huang Edison on 3/4/17.
//  Copyright © 2017 Edison. All rights reserved.
//

import UIKit

class TweetEntity: NSObject {
    
    var entity: NSDictionary?
    
    var hashtags: [String]?{
        var hashtagList: [String] = []
        guard let hashtags = entity?["hashtags"] as? [NSDictionary] else {
            return nil
        }
        for hashtag in hashtags {
            hashtagList.append(hashtag["text"] as! String)
        }
        return hashtagList
    }
    
    var mentions: [String]?{
        var mentionList: [String] = []
        guard let mensions = entity?["user_mentions"] as? [NSDictionary] else {
            return nil
        }
        for mention in mensions {
            mentionList.append(mention["screen_name"] as! String)
        }
        return mentionList
    }
        
    init(dictionary: NSDictionary?) {
        if let dictionary = dictionary{
            self.entity = dictionary
        }
    }
}
