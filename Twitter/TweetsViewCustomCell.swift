//
//  TweetsViewCustomCell.swift
//  Twitter
//
//  Created by Huang Edison on 2/26/17.
//  Copyright © 2017 Edison. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsViewCustomCell: UITableViewCell {

    
    @IBOutlet weak var retweetedUserNameLabel: UILabel!
    @IBOutlet weak var retweetMentionStackView: UIStackView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    
    var retweet: Tweet? {
        didSet{
            if let tweetText = retweet?.text {
                tweetTextLabel.setTweet(tweet: tweetText)
            }
            if let thumbImageUrl = retweet?.user.profileUrl {
                thumbImageView.setImageWith(thumbImageUrl)
                thumbImageView.layer.cornerRadius = 4.0
            }
            if let tweetUserName = retweet?.user.name {
                userNameLabel.text = tweetUserName
            }
            if let screenname = retweet?.user.screenname {
                userScreenNameLabel.text = "@"+screenname
            }
            if let timestamp = retweet?.timestamp {
                dateCreatedLabel.text = "· "+timestamp
            }
            if let retweetCount = retweet?.retweetCount {
                retweetCountLabel.text = "\(retweetCount)"
            }
            if let favoriteCount = retweet?.favoritesCount {
                favoriteCountLabel.text = "\(favoriteCount)"
            }
            if let retweetUserName = tweet?.user.name {
                retweetedUserNameLabel.text = retweetUserName+" retweeted"
            }
//            if let retweetTimestamp = tweet?.timestamp {
//                retweetTimestampLabel.text = " · "+retweetTimestamp
//            }
            retweetMentionStackView.isHidden = false
            
        }
    }
    
    var tweet: Tweet? {
        didSet{
            retweetMentionStackView.frame.size.height = 0
            //retweetMentionStackView.removeFromSuperview()
            //retweetMentionStackView.isHidden = true
            //thumbImageView.frame.origin.y = 3
            if let tweet = tweet {
                if let retweetStatus = tweet.retweetedStatus{
                    self.retweet = Tweet(dictionary: retweetStatus)
                    retweetMentionStackView.frame.size.height = 15
                    //retweetMentionStackView.isHidden = false
                    //thumbImageView.frame.origin.y = 21
                    return
                }
            }
            if let tweetText = tweet?.text {
                tweetTextLabel.setTweet(tweet: tweetText)
            }
            if let thumbImageUrl = tweet?.user.profileUrl {
                thumbImageView.setImageWith(thumbImageUrl)
                thumbImageView.layer.cornerRadius = 4.0
            }
            if let tweetUserName = tweet?.user.name {
                userNameLabel.text = tweetUserName
            }
            if let screenname = tweet?.user.screenname {
                userScreenNameLabel.text = "@"+screenname
            }
            if let timestamp = tweet?.timestamp {
                dateCreatedLabel.text = "· "+timestamp
            }
            if let retweetCount = tweet?.retweetCount {
                retweetCountLabel.text = "\(retweetCount)"
            }
            if let favoriteCount = tweet?.favoritesCount {
                favoriteCountLabel.text = "\(favoriteCount)"
            }
            retweetMentionStackView.isHidden = true
        }
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        retweetMentionStackView.isHidden = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
