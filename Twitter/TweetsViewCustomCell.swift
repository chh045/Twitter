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
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favorButton: UIButton!
    
    
    var retweetCount: Int?
    var isRetweeted: Bool? {
        didSet{
            if isRetweeted! {
                retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControlState.normal)
            }
            else {
                retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControlState.normal)
            }
        }
    }
    var favoriteCount: Int?
    var isFavorited: Bool? {
        didSet{
            if isFavorited! {
                favorButton.setImage(UIImage(named: "favor-icon-red"), for: UIControlState.normal)
            }
            else {
                favorButton.setImage(UIImage(named: "favor-icon"), for: UIControlState.normal)
            }
        }
    }
    
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
                self.retweetCount = retweetCount
            }
            if let favoriteCount = retweet?.favoritesCount {
                favoriteCountLabel.text = "\(favoriteCount)"
                self.favoriteCount = favoriteCount
            }
            if let retweetUserName = tweet?.user.name {
                retweetedUserNameLabel.text = retweetUserName+" retweeted"
            }
//            if let retweetTimestamp = tweet?.timestamp {
//                retweetTimestampLabel.text = " · "+retweetTimestamp
//            }
            if let isRetweeted = retweet?.isRetweeted {
                self.isRetweeted = isRetweeted
            }
            if let isFavorited = retweet?.isFavorited {
                self.isFavorited = isFavorited
            }
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
                self.retweetCount = retweetCount
            }
            if let favoriteCount = tweet?.favoritesCount {
                favoriteCountLabel.text = "\(favoriteCount)"
                self.favoriteCount = favoriteCount
            }
            if let isRetweeted = tweet?.isRetweeted {
                self.isRetweeted = isRetweeted
            }
            if let isFavorited = tweet?.isFavorited {
                self.isFavorited = isFavorited
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
    
    @IBAction func onTapRetweetButton(_ sender: UIButton) {
        guard let tid = tweet?.tweetId else {return}
        if isRetweeted! {
            TwitterClient.sharedInstance?.unretweet(id: tid, success: {
                self.retweetCount! -= 1
                self.retweetCountLabel.text = "\(self.retweetCount!)"
                self.isRetweeted = false
            })
        }
        else {
            TwitterClient.sharedInstance?.retweet(id: tid, success: {
                self.retweetCount! += 1
                self.retweetCountLabel.text = "\(self.retweetCount!)"
                self.isRetweeted = true
            })
        }
    }
    
    
    @IBAction func onTapFavorButton(_ sender: UIButton) {
        guard let tid = tweet?.tweetId else {return}
        if isFavorited! {
            TwitterClient.sharedInstance?.unfavorite(id: tid, success: {
                self.favoriteCount! -= 1
                self.favoriteCountLabel.text = "\(self.favoriteCount!)"
                self.isFavorited = false
            })
        }
        else {
            TwitterClient.sharedInstance?.favorite(id: tid, success: {
                self.favoriteCount! += 1
                self.favoriteCountLabel.text = "\(self.favoriteCount!)"
                self.isFavorited = true
            })
        }
    }
    
    
}
