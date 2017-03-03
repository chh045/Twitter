//
//  ProfileTableViewController.swift
//  Twitter
//
//  Created by Huang Edison on 2/26/17.
//  Copyright © 2017 Edison. All rights reserved.
//

import UIKit

class ProfileTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var userDescription: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    
    var tweets: [Tweet]!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        
        TwitterClient.sharedInstance?.userTimeline(screenName: user?.screenname, success: { (tweets:[Tweet]) in
            self.tweets = tweets
            for tweet in tweets{
                print(tweet)
            }
            self.tableView.reloadData()
        })
        
        //if let user = user{
        updateUI()
        //}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets{
            return tweets.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetsTableViewCell
        
        let cell = Bundle.main.loadNibNamed("TweetsViewCustomCell", owner: self, options: nil)?.first as! TweetsViewCustomCell
        let tweet = self.tweets[indexPath.row]
        cell.tweet = tweet
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func updateUI(){
        if let thumbImageUrl = user?.profileUrl{
            thumbImageView.setImageWith(thumbImageUrl)
            thumbImageView.layer.cornerRadius = 4.0
        }
        if let userName = user?.name{
            userNameLabel.text = userName
        }
        if let screenName = user?.screenname{
            userScreenNameLabel.text = "@"+screenName
        }
        if let tagline = user?.tagline{
            userDescription.setTweet(tweet: tagline)
            userDescription.sizeToFit()
        }
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
