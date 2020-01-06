//
//  ViewController.swift
//  Twittermenti
//
//  Created by Matt Bremner on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import CoreML
import SwifteriOS


class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let sentimentClassifier = TweetSentimentClassifier()
    
    let swifter = Swifter(consumerKey: "USE YOUR OWN KEY", consumerSecret: "USE YOUR OWN KEY")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
       
        
        view.addGestureRecognizer(tapGesture)
    
    }
    
    
    @IBAction func predictPressed(_ sender: Any) {
        
        if let searchText = textField.text {
            
            swifter.searchTweet(using: searchText ,lang: "en", count: 100, tweetMode: .extended, success: { (results, metadata) in
                
                
                var tweets = [TweetSentimentClassifierInput]()
                
                for i in 0..<100 {
                    //grab the full text then convert it into something the model can undetstant
                    if let tweet = results[i]["full_text"].string {
                        let tweetForClassifiaction = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassifiaction)
                    }
                    
                }
                do{
                    //get model to predict the sentiment of the text and put the output into an array
                    let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
                    
                    var sentimentScore = 0
                    
                    //loop through the results and score each sentiment results, and add/subtract to total score
                    for prediction in predictions {
                        let sentiment = prediction.label
                        
                        if sentiment == "Pos" {
                            sentimentScore += 1
                        }else if sentiment == "Neg" {
                            sentimentScore -= 1
                        }
                        
                    }
                    
                    if sentimentScore > 20 {
                        self.sentimentLabel.text = "😍"
                    }else if sentimentScore > 10 {
                        self.sentimentLabel.text = "😀"
                    }else if sentimentScore > 0 {
                        self.sentimentLabel.text = "🙂"
                    }else if sentimentScore > -10 {
                        self.sentimentLabel.text = "😐"
                    }else if sentimentScore > -20 {
                        self.sentimentLabel.text = "😡"
                    }else {
                        self.sentimentLabel.text = "🤮"
                    }
                    
                    print(sentimentScore)
                }catch{
                    print("There was an error with making a prediction::\(error)")
                }
                
                
            }) { (error) in
                print("there was was an error with the twitter api request \(error)")
            }
            
            
        }
  
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
}

