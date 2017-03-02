//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Huang Edison on 2/26/17.
//  Copyright © 2017 Edison. All rights reserved.
//

import UIKit

fileprivate let buttonsStackViewOriginY = CGFloat(629)

class ComposeViewController: UIViewController {

    
    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet weak var letterCountLabel: UILabel!
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    
    
    @IBOutlet weak var composeButton: UIButton!{
        didSet{
            composeButton.layer.cornerRadius = 6.0
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: Notification.Name("UIKeyboardDidShowNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: Notification.Name("UIKeyboardDidHideNotification"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardDidShow(notification: Notification){
        if let keyboardRect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            let keyboardHeight = keyboardRect.height
            buttonsStackView.frame.origin.y = buttonsStackViewOriginY - keyboardHeight
        }
    }
    
    func keyboardDidHide(notification: Notification){
            buttonsStackView.frame.origin.y = buttonsStackViewOriginY
    }
    
    @IBAction func tapOnTweetButton(_ sender: Any) {
        if let status = composeTextView.text{
            TwitterClient.sharedInstance?.postTweet(status: status, success: {
                self.composeTextView.endEditing(true)
                self.performSegue(withIdentifier: "TweetSuccessSegue", sender: sender)
            })
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
