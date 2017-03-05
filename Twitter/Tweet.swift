//
//  Tweets.swift
//  Twitter
//
//  Created by Huang Edison on 2/18/17.
//  Copyright © 2017 Edison. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var dictionary: NSDictionary!
    
    var text: String?{
        return dictionary["text"] as? String
    }
    
    var createdDate: String?{
        let createdDate = dictionary["created_at"] as? String
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        let date = formatter.date(from: createdDate!)
        formatter.dateFormat = "MM/dd/yy, HH:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from:date!)
    }
    
    var timestamp: String?{
        
        let timestampString = dictionary["created_at"] as? String
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        let create_date = formatter.date(from: timestampString!)
        
        let elapsed = Int(Date().timeIntervalSince(create_date!))
        if elapsed < 60 * 60 {
            let minutes = (elapsed/60) % 60
            return "\(minutes)m"
        }
        else if elapsed < 60 * 60 * 24 {
            let hours = (elapsed/(60 * 60)) % 24
            return "\(hours)h"
        }
        else if elapsed < 60 * 60 * 24 * 15 {
            let days = (elapsed/(60 * 60 * 24)) % 15
            return "\(days)d"
        }
        else {
            formatter.dateFormat = "MM-dd-yyyy"
            return formatter.string(from: create_date!)
        }
    }
        
    var retweetCount: Int{
        return dictionary["retweet_count"] as! Int
    }
    
    var favoritesCount: Int{
        return dictionary["favorite_count"] as! Int
    }
    
    var user: User{
        return User(dictionary: dictionary["user"] as! NSDictionary)
    }
    
    var isRetweeted: Bool{
        return dictionary["retweeted"] as! Bool
    }
    
    var isFavorited: Bool{
        return dictionary["favorited"] as! Bool
    }
    
    var retweetedStatus: NSDictionary?{
        return dictionary["retweeted_status"] as? NSDictionary
    }
    
    var tweetId: UInt64{
        return dictionary["id"] as! UInt64
    }
    
    var entities: TweetEntity?{
        guard let entities = dictionary["entities"] as? NSDictionary else {
            return nil
        }
        return TweetEntity(dictionary: entities)
    }
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
    }
    
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
        
    }
}
