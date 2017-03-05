//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Huang Edison on 2/26/17.
//  Copyright © 2017 Edison. All rights reserved.
//

import UIKit

fileprivate let buttonsStackViewOriginY = CGFloat(629)
fileprivate let maxLetter = 140

class ComposeViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet weak var letterCountLabel: UILabel!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var composeButton: UIButton!{
        didSet{
            composeButton.layer.cornerRadius = 6.0
        }
    }
    @IBOutlet weak var textInitiateLabel: UILabel!
    
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        composeTextView.delegate = self
        composeTextView.becomeFirstResponder()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: Notification.Name("UIKeyboardDidShowNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: Notification.Name("UIKeyboardDidHideNotification"), object: nil)
        
        updateUI()
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
    
    func updateUI(){
        if let profileImageUrl = user?.profileUrl {
            thumbImageView.setImageWith(profileImageUrl)
            thumbImageView.layer.cornerRadius = 4.0
        }
        if let userName = user?.name {
            userNameLabel.text = userName
            userNameLabel.sizeToFit()
        }
        if let screenName = user?.screenname {
            screennameLabel.text = "@"+screenName
            screennameLabel.sizeToFit()
        }
    }
    
    @IBAction func tapOnTweetButton(_ sender: Any) {
        if let status = composeTextView.text{
            TwitterClient.sharedInstance?.postTweet(status: status, success: {
                self.composeTextView.endEditing(true)
                self.performSegue(withIdentifier: "TweetSuccessSegue", sender: sender)
            })
        }
        
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        let letterCount = composeTextView.text.characters.count
        textInitiateLabel.isHidden = !composeTextView.text.isEmpty
        letterCountLabel.text = "\(maxLetter - letterCount)"
        if letterCount == maxLetter{
            letterCountLabel.textColor = UIColor.red
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if composeTextView.text.characters.count == maxLetter && !text.isEmpty{
            return false
        }
        letterCountLabel.textColor = UIColor.black
        return true
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
