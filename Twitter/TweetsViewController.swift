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
        //tweetTableView.allowsSelection = false
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tweetTableView.insertSubview(refreshControl, at: 0)
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barTintColor = .white
        let twitterLogo = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        twitterLogo.contentMode = .scaleAspectFit
        twitterLogo.image = UIImage(named: "TwitterLogoBlue")
        //twitterLogo.backgroundColor = .blue
        self.navigationItem.titleView = twitterLogo
        //self.navigationItem.titleView?.backgroundColor = .white
        //composeButton.image = UIImage(named: "message-add")
        
        
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
        
        let cell = tweetTableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetsTableViewCell
        
        let tweet = tweets![indexPath.row]
        cell.tweet = tweet
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.delegate = self
        return cell
    }

    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl){
        
        refreshControl.beginRefreshing()
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets) in
            refreshControl.endRefreshing()
            self.tweets = tweets
            self.tweetTableView.reloadData()
            
        }, failure: { (error) in
            refreshControl.endRefreshing()
            print("Error: \(error.localizedDescription)")
        })
        

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let iden = segue.identifier{
            if iden == "ShowTweetDetail"{
                let tweetDetailVC = segue.destination as! TweetDetailViewController
                let cell = sender as! TweetsTableViewCell
                let selectedIndexPath = tweetTableView.indexPath(for: cell)
                let selectedTweet = tweets![selectedIndexPath!.row]
                
                //tweetDetailVC.detailView
                tweetDetailVC.tweet = selectedTweet
                
                let backItem = UIBarButtonItem()
                backItem.title = "Home"
                navigationItem.backBarButtonItem = backItem
                //tweetTableView.deselectRow(at: selectedIndexPath!, animated: true)
            }
        }
    }
}


extension TweetsViewController: TweetsTableViewCellDelegate{
    func profileImageViewTapped(cell: TweetsTableViewCell, user: User) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileTableViewController{
            //set the profile user before your push
            //print(user.name)
            profileVC.user = user
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}
