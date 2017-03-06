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
    @IBOutlet weak var headerView: UIView!
    
    weak var delegate: TweetsTableViewCellDelegate?
    var tweet: Tweet?
    var retweetCount: Int?
    var isRetweeted: Bool?{
        didSet{
            if isRetweeted! {
                retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControlState.normal)
            }
            else{
                retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControlState.normal)
            }
        }
    }
    var favorCount: Int?
    var isFavorited: Bool?{
        didSet{
            if isFavorited! {
                favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: UIControlState.normal)
            }
            else {
                favoriteButton.setImage(UIImage(named: "favor-icon"), for: UIControlState.normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        if let tweetText = self.tweet?.text {
            textLabel.setTweet(tweet: tweetText)
            textLabel.sizeToFit()
            print(textLabel.frame.size.height, headerView.frame.size.height)
            headerView.frame.size.height = 200 + textLabel.frame.size.height
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
            self.retweetCount = retweetCount
        }
        if let favoriteCount = tweet?.favoritesCount {
            favoriteCountLabel.text = "\(favoriteCount)"
            self.favorCount = favoriteCount
        }
        if let isRetweeted = tweet?.isRetweeted {
            self.isRetweeted = isRetweeted
        }
        if let isFavorited = tweet?.isFavorited {
            self.isFavorited = isFavorited
        }
        

        let tapOnThumbImageRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnThumbImage(tapGestureRecognizer:)))
        thumbImageView.isUserInteractionEnabled = true
        thumbImageView.addGestureRecognizer(tapOnThumbImageRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TweetsViewCustomCell", owner: self, options: nil)?.first as! TweetsViewCustomCell
        cell.retweetMentionStackView.isHidden = true
        return cell
    }
    
    func tapOnThumbImage(tapGestureRecognizer: UITapGestureRecognizer){
        performSegue(withIdentifier: "DetailViewToProfileView", sender: tapGestureRecognizer)
    }
    
    @IBAction func onTapRetweetButton(_ sender: UIButton) {
        if isRetweeted! {
            retweetCount! -= 1
            retweetCountLabel.text = "\(retweetCount!)"
            isRetweeted! = false
        }
        else {
            retweetCount! += 1
            retweetCountLabel.text = "\(retweetCount!)"
            isRetweeted! = true
        }
    }
    
    @IBAction func onTapFavorButton(_ sender: UIButton) {
        if isFavorited! {
            favorCount! -= 1
            favoriteCountLabel.text = "\(favorCount!)"
            isFavorited = false
        }
        else {
            favorCount! += 1
            favoriteCountLabel.text = "\(favorCount!)"
            isFavorited = true
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let iden = segue.identifier
        if iden == "replyFromDetailViewSegue" {
            let composeVC = segue.destination as! ComposeViewController
            composeVC.beginText = screenNameLabel.text
        }
        else if iden == "DetailViewToProfileView" {
            let profileVC = segue.destination as! ProfileTableViewController
            profileVC.user = tweet?.user
        }
    }
    

}
