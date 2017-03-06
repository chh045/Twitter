//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Huang Edison on 2/19/17.
//  Copyright © 2017 Edison. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tweetTableView: UITableView!
    var tweets: [Tweet]!
    var loadingMoreView: InfiniteScrollActivityView?
    var isMoreDataLoading = false
    var tweetIdList: [UInt64] = []
    
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
        self.navigationItem.titleView = twitterLogo

        let frame = CGRect(x: 0, y: tweetTableView.contentSize.height, width: tweetTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tweetTableView.addSubview(loadingMoreView!)
        
        var insets = tweetTableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tweetTableView.contentInset = insets
        
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets) in
            self.tweets = tweets
            for tweet in tweets{
                self.tweetIdList.append(tweet.tweetId)
            }
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
        let since_id = tweetIdList.max()! + 1
        TwitterClient.sharedInstance?.homeTimeline(since_id: since_id, success: { (tweets) in
            refreshControl.endRefreshing()
            //self.tweets = tweets
            self.tweets.insert(contentsOf: tweets, at: 0)
            for tweet in tweets{
                self.tweetIdList.append(tweet.tweetId)
            }
            self.tweetTableView.reloadData()
            
        }, failure: { (error) in
            refreshControl.endRefreshing()
            print("Error: \(error.localizedDescription)")
        })
    }
    
    func loadMoreTweetsIntoTable(){
        let max_id = tweetIdList.min()! - 1
        TwitterClient.sharedInstance?.homeTimeline(max_id: max_id, success: { (tweets) in
            self.loadingMoreView?.stopAnimating()
            self.tweets.append(contentsOf: tweets)
            //self.tweetIdList = []
            for tweet in tweets{
                self.tweetIdList.append(tweet.tweetId)
            }
            self.tweetTableView.reloadData()
            self.isMoreDataLoading = false
        }, failure: { (error) in
            print("Error: \(error.localizedDescription)")
        })
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if( !isMoreDataLoading ) {
            let scrollViewContentHeight = tweetTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tweetTableView.bounds.size.height
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tweetTableView.isDragging) {
                isMoreDataLoading = true
                let frame = CGRect(x: 0, y: tweetTableView.contentSize.height, width: tweetTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                loadMoreTweetsIntoTable()
            }
        }
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
            }
        }
    }
}


extension TweetsViewController: TweetsTableViewCellDelegate{
    func profileImageViewTapped(cell: TweetsTableViewCell, user: User) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileTableViewController{
            //set the profile user before your push
            profileVC.user = user
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    func replyButtonOnTap(screenname: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let composeVC = storyboard.instantiateViewController(withIdentifier: "ComposeViewController") as? ComposeViewController{
            composeVC.beginText = screenname
            self.navigationController?.pushViewController(composeVC, animated: true)
        }
    }
}
