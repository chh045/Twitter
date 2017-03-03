//
//  UILabelExtension.swift
//  Twitter
//
//  Created by Huang Edison on 3/2/17.
//  Copyright © 2017 Edison. All rights reserved.
//

import UIKit

extension UILabel{
    func setTweet(tweet: String){
        var attribute: NSMutableAttributedString? = nil
        tweet.hashtags(text: tweet, function: {hashtag in
            attribute = tweet.addColorAttribute(colorText: hashtag, attribute: attribute)
        })
        tweet.mentions(text: tweet, function: {mention in
            attribute = tweet.addColorAttribute(colorText: mention, attribute: attribute)
        })
        if let att = attribute {
            self.attributedText = att
        }
        else{
            self.text = tweet
        }
    }
}
