//
//  RandomQuoteVC.swift
//  Motivate
//
//  Created by Jacqueline Kouri on 4/3/16.
//  Copyright © 2016 Jacqueline Kouri. All rights reserved.
//

import UIKit
import Foundation

class RandomQuoteVC: UIViewController {

    @IBOutlet weak var quoteLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func generateQuote(sender: AnyObject) {

        let postEndpoint: String = "http://api.forismatic.com/api/1.0/?method=getQuote&lang=en&format=json"
    
        guard let url = NSURL(string: postEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = NSURLRequest(URL: url)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling GET on /posts/1")
                print(error)
                return
            }
     
            
            // parse the result as JSON, since that's what the API provides
            let post: NSDictionary
            do {
                post = try NSJSONSerialization.JSONObjectWithData(responseData,
                    options: []) as! NSDictionary
                } catch  {
                self.generateQuote(sender)
                print("error trying to convert data to JSON")
                return
            }
            // now we have the post, let's just print it to prove we can access it
            let quote = post["quoteText"] as! String
            print(quote)
            
            dispatch_async(dispatch_get_main_queue()) {
            self.quoteLabel.text = quote
            }
            
        })
        task.resume()

       
        
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

