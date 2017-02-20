//
//  TweetsTableViewCell.swift
//  Twitter
//
//  Created by Huang Edison on 2/19/17.
//  Copyright © 2017 Edison. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsTableViewCell: UITableViewCell {

    @IBOutlet weak var userNickNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var tweet: Tweet! {
        didSet{
            if let tweetText = tweet.text {
                tweetTextLabel.text = tweetText
            }
            if let thumbImageUrl = tweet.user.profileUrl {
                thumbImage.setImageWith(thumbImageUrl)
            }
            if let tweetUserName = tweet.user.name {
                userNameLabel.text = tweetUserName
            }
            if let screenname = tweet.user.screenname {
                userNickNameLabel.text = "@"+screenname
            }
            if let timestamp = tweet.timestamp {
                timestampLabel.text = timestamp
            }
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

}
