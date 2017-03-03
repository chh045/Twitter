//
//  StringHandler.swift
//  Twitter
//
//  Created by Huang Edison on 3/2/17.
//  Copyright © 2017 Edison. All rights reserved.
//

import UIKit
import SwiftHEXColors

func spaceOrNewline(text: String)->String.Index{
    
    if let space = text.range(of: " ")?.lowerBound{
        return space
    }
    else if let newline = text.range(of: "\n")?.lowerBound{
        return newline
    }
    else{
        return text.endIndex
    }
}

extension String{
    
    func hashtags(text: String, function: (String)->()){
        
        if let hashtag = text.range(of: "#"){
            let hashtagPos = hashtag.lowerBound
            let sub = text.substring(from: hashtagPos)
            let end = spaceOrNewline(text: sub)
            let hashtagName = sub.substring(to: end)
            function(hashtagName)
            hashtags(text: text.substring(from: hashtag.upperBound), function: function)
        }
        return
    }
    
    func mentions(text: String, function: (String)->()){
        
        if let mention = text.range(of: "@"){
            let mentionPos = mention.lowerBound
            let sub = text.substring(from: mentionPos)
            let end = spaceOrNewline(text: sub)
            let mentionPosName = sub.substring(to: end)
            function(mentionPosName)
            mentions(text: text.substring(from: mention.upperBound), function: function)
        }
        return
    }
    
    func addColorAttribute(colorText: String, attribute: NSMutableAttributedString?) -> NSMutableAttributedString{
        if let attribute = attribute{
            let range = (self as NSString).range(of: colorText)
            attribute.addAttribute(NSForegroundColorAttributeName, value: UIColor(hexString: "#00b2ff")! , range: range)
            return attribute
        }
        else{
            let attribute = NSMutableAttributedString.init(string: self)
            let range = (self as NSString).range(of: colorText)
            attribute.addAttribute(NSForegroundColorAttributeName, value: UIColor(hexString: "#00b2ff")! , range: range)
            return attribute
        }
    }
}

