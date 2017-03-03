//
//  TweetsTableViewCell.swift
//  Twitter
//
//  Created by Huang Edison on 2/19/17.
//  Copyright © 2017 Edison. All rights reserved.
//

import UIKit
import AFNetworking

protocol TweetsTableViewCellDelegate: class  {
    func profileImageViewTapped(cell: TweetsTableViewCell, user: User)
}

class TweetsTableViewCell: UITableViewCell {

    @IBOutlet weak var retweetMentionStackView: UIStackView!
    @IBOutlet weak var retweetUserNameLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!{
        didSet{
            self.thumbImageView.isUserInteractionEnabled = true //make sure this is enabled
            //tap for userImageView
            let userProfileTap = UITapGestureRecognizer(target: self, action: #selector(userProfileTapped(_:)))
            self.thumbImageView.addGestureRecognizer(userProfileTap)
            
        }
    }
    @IBOutlet weak var tweetUserNameLabel: UILabel!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTimestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var replyIconImage: UIImageView!
    @IBOutlet weak var retweetIconImage: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteIconImage: UIImageView!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetTimestampLabel: UILabel!
    
    weak var delegate: TweetsTableViewCellDelegate? //make sure it's weak to prevent retain cycle
    
    var user: User?
    
    var retweet: Tweet? {
        didSet{
            self.user = retweet?.user
            if let tweetText = retweet?.text {
                tweetTextLabel.setTweet(tweet: tweetText)
            }
            if let thumbImageUrl = retweet?.user.profileUrl {
                thumbImageView.setImageWith(thumbImageUrl)
                thumbImageView.layer.cornerRadius = 4.0
            }
            if let tweetUserName = retweet?.user.name {
                tweetUserNameLabel.text = tweetUserName
            }
            if let screenname = retweet?.user.screenname {
                tweetScreenNameLabel.text = "@"+screenname
            }
            if let timestamp = retweet?.timestamp {
                tweetTimestampLabel.text = "· "+timestamp
            }
            if let retweetCount = retweet?.retweetCount {
                retweetCountLabel.text = "\(retweetCount)"
            }
            if let favoriteCount = retweet?.favoritesCount {
                favoriteCountLabel.text = "\(favoriteCount)"
            }
            if let retweetUserName = tweet?.user.name {
                retweetUserNameLabel.text = retweetUserName+" retweeted"
            }
            if let retweetTimestamp = tweet?.timestamp {
                retweetTimestampLabel.text = " · "+retweetTimestamp
            }
            retweetMentionStackView.isHidden = false
            
        }
    }
    
    var tweet: Tweet? {
        didSet{
            self.user = tweet?.user
            retweetMentionStackView.frame.size.height = 0
            //retweetMentionStackView.removeFromSuperview()
            //retweetMentionStackView.isHidden = true
            //thumbImageView.frame.origin.y = 3
            if let tweet = tweet {
                if let retweetStatus = tweet.retweetedStatus{
                    self.retweet = Tweet(dictionary: retweetStatus)
                    //retweetMentionStackView.frame.size.height = 15
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
                tweetUserNameLabel.text = tweetUserName
            }
            if let screenname = tweet?.user.screenname {
                tweetScreenNameLabel.text = "@"+screenname
            }
            if let timestamp = tweet?.timestamp {
                tweetTimestampLabel.text = "· "+timestamp
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func userProfileTapped(_ gesture: UITapGestureRecognizer){
        if let delegate = delegate{
            var screenName = tweetScreenNameLabel.text!
            screenName.remove(at: screenName.startIndex)
            delegate.profileImageViewTapped(cell: self, user: user!)
        }
    }

}
