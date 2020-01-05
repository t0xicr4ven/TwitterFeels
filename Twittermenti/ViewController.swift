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
    
    let swifter = Swifter(consumerKey: "key", consumerSecret: "key")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       let prediction = try! sentimentClassifier.prediction(text: "You are shit")
        
        print(prediction.label)
  
        swifter.searchTweet(using: "@Apple",lang: "en", count: 100, tweetMode: .extended, success: { (results, metadata) in
            //print(results)
            //print(metadata)
        }) { (error) in
            print("there was was an error with the twitter api request \(error)")
        }
  
    }
    
    
    @IBAction func predictPressed(_ sender: Any) {
        
        
    }
    
}

