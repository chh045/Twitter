//
//  User.swift
//  Twitter
//
//  Created by Huang Edison on 2/18/17.
//  Copyright © 2017 Edison. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?{
        return dictionary["name"] as? String
    }
    var screenname: String?{
        return dictionary["screen_name"] as? String
    }
    var profileUrl: URL?{
        let profileUrlString = dictionary["profile_image_url_https"] as! String
        return URL(string: profileUrlString)
    }
    var tagline: String?{
        return dictionary["description"] as? String
    }
    var dictionary: NSDictionary!
    
    
    
    // so called deserialization
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
    }
    
    
    //Twitter[43213:3765185] [User Defaults] Attempt to set a non-property-list object <Twitter.User: 0x6000000f5280> as an NSUserDefaults/CFPreferences value for key currentUser
    static let userDidLogoutNotification = NSNotification.Name(rawValue: "UserDidLogout")

    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user){
            _currentUser = user
            
            let defaults = UserDefaults.standard
            if let user = user{
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}
