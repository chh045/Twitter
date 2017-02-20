//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Huang Edison on 2/19/17.
//  Copyright © 2017 Edison. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tweetTableView: UITableView!

    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTableView.dataSource = self
        tweetTableView.delegate = self
        tweetTableView.rowHeight = UITableViewAutomaticDimension
        tweetTableView.estimatedRowHeight = 140

        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets) in
            self.tweets = tweets

            self.tweetTableView.reloadData()
        }, failure: { (error) in
            print("Error: \(error.localizedDescription)")
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tweets = self.tweets else {
            return 0
        }
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetsTableViewCell
        
        let tweet = tweets![indexPath.row]
        cell.tweet = tweet
        
        return cell
    }

    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let iden = segue.identifier{
            if iden == "ShowTweetDetail"{
                guard let tweetDetailVC = segue.destination as? TweetDetailViewController else { return }
                guard let selectedIndexPath = sender as? IndexPath else {return}
                guard let selectedTweet = tweets?[selectedIndexPath.row] else {return}
                
            }
        }
    }
    

}
