//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Huang Edison on 2/20/17.
//  Copyright © 2017 Edison. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var messageButton: UIButton!
    
    
    
    var tweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140

        if let tweetText = self.tweet?.text {
            print(tweetText)
            textLabel.setTweet(tweet: tweetText)
            textLabel.sizeToFit()
        }
        if let thumbImageUrl = self.tweet?.user.profileUrl {
            thumbImageView.layer.cornerRadius = 4.0
            thumbImageView.clipsToBounds = true
            thumbImageView.setImageWith(thumbImageUrl)
        }
        if let userName = self.tweet?.user.name {
            userNameLabel.text = userName
        }
        if let screenname = self.tweet?.user.screenname {
            screenNameLabel.text = "@"+screenname
        }
        if let createdDate = tweet?.createdDate {
            timeStampLabel.text = createdDate
            timeStampLabel.sizeToFit()
        }
        if let retweetCount = tweet?.retweetCount {
            retweetCountLabel.text = "\(retweetCount)"
        }
        if let favoriteCount = tweet?.favoritesCount {
            favoriteCountLabel.text = "\(favoriteCount)"
        }
        
        //print(tweet!)
        let tapOnThumbImageRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnThumbImage(tapGestureRecognizer:)))
        thumbImageView.isUserInteractionEnabled = true
        thumbImageView.addGestureRecognizer(tapOnThumbImageRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TweetsViewCustomCell", owner: self, options: nil)?.first as! TweetsViewCustomCell
        //let tweet = self.tweets[indexPath.row]
        //cell.tweet = tweet
        //cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.retweetMentionStackView.isHidden = true
        return cell
    }
    
    func tapOnThumbImage(tapGestureRecognizer: UITapGestureRecognizer){
        //let tappedImage = tapGestureRecognizer
        performSegue(withIdentifier: "DetailViewToProfileView", sender: tapGestureRecognizer)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
