//
//  TwitterClient.swift
//  Twitter
//
//  Created by Huang Edison on 2/18/17.
//  Copyright © 2017 Edison. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


// the reason for creating this class is because now every time
// we want information about our app we need to make a call to
// to the API server
class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "kp20nrC8exFFmdgXr5ju8W9YK", consumerSecret: "0dn2bCmlPeMI55aTo1rUkV52yW3Ba7d6TT7cOZzHWYDJ6TdgFO")
    
    // because login is the first step we have to do before fetching data
    // we want to store it some where as a instance variable to check on the instance
    var loginSuccess: (() -> ())?
    
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()){
        
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterDemo://oauth"), scope: nil, success: { (responseToken: BDBOAuth1Credential?) -> Void in
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(responseToken!.token!)")!
            UIApplication.shared.open(url)
            
        }, failure: { (error: Error?) -> Void in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func logout(){
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: URL){
        let responseToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: responseToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            
            self.currentAccount(success: { (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) -> () in
                self.loginFailure?(error)
            })
            self.loginSuccess?()
            
        }, failure: { (error) in
            self.loginFailure?(error!)
        })
    }
    
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            //let tweets = response as! [NSDictionary]
            
            let dictionary = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionary)

            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    
    func userTimeline(screenName: String?, success: @escaping ([Tweet]) -> ()){
        guard let screenName = screenName else {
            print("try to pass in an empty screen name\n")
            return
        }
        let param : NSDictionary!
        param = ["screen_name":screenName]
        get("1.1/statuses/user_timeline.json", parameters: param, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictonary = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictonary)
            success(tweets)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
        }
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error)-> Void in
            failure(error)
        })
    }
    
    func postTweet(status: String, success: @escaping ()->()){
        guard let encodedStatus = status.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            print("User Input status format issue found")
            return
        }
        post("1.1/statuses/update.json?status=\(encodedStatus)", parameters: nil, progress: nil, success: { (task: URLSessionTask, response: Any?) in
            success()
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
        }
    }
}
