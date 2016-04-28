//
//  RandomQuoteVC.swift
//  Motivate
//
//  Created by Jacqueline Kouri on 4/3/16.
//  Copyright © 2016 Jacqueline Kouri. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class RandomQuoteVC: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
  
    @IBOutlet weak var quoteLabel: UILabel!

    var soundRecorder: AVAudioRecorder!
    var soundPlayer:AVAudioPlayer!

    let fileName = "audio.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
    }
    
    
    
    @IBAction func playSound(sender: AnyObject) {
        
            if (sender.titleLabel?!.text == "Play"){
            recordButton.enabled = false
            sender.setTitle("Stop", forState: .Normal)
            preparePlayer()
            soundPlayer.play()
        } else {
            soundPlayer.stop()
            sender.setTitle("Play", forState: .Normal)
        }
        
    }
    
    @IBAction func recordSound(sender: AnyObject) {
        if (sender.titleLabel?!.text == "Record"){
            soundRecorder.record()
            sender.setTitle("Stop", forState: .Normal)
            playButton.enabled = false
        } else {
            soundRecorder.stop()
            sender.setTitle("Record", forState: .Normal)
        }
        
    }
    

    // MARK:- AVRecorder Setup
    
    func setupRecorder() {
        
        //set the settings for recorder
        
        let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),
                              AVFormatIDKey : NSNumber(int: Int32(kAudioFormatAppleLossless)),
                              AVNumberOfChannelsKey : NSNumber(int: 2),
                              AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Max.rawValue))];
        
        var error: NSError?
        
        do {
            //  soundRecorder = try AVAudioRecorder(URL: getFileURL(), settings: recordSettings as [NSObject : AnyObject])
            soundRecorder =  try AVAudioRecorder(URL: getFileURL(), settings: recordSettings)
        } catch let error1 as NSError {
            error = error1
            soundRecorder = nil
        }
        
        if let err = error {
            print("AVAudioRecorder error: \(err.localizedDescription)")
        } else {
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        }
        
        let session = AVAudioSession.sharedInstance()
        try!  session.setCategory(AVAudioSessionCategoryPlayAndRecord)
    }
    
    // MARK:- Prepare AVPlayer
    
    func preparePlayer() {
        var error: NSError?
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            soundPlayer = try AVAudioPlayer(contentsOfURL: getFileURL())
        } catch let error1 as NSError {
            error = error1
            soundPlayer = nil
        }
        
        if let err = error {
            print("AVAudioPlayer error: \(err.localizedDescription)")
        } else {
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        }
    }
    
    // MARK:- File URL
    
   func getCacheDirectory() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory,.UserDomainMask, true)
        
        return paths[0]
    }
    
    func getFileURL() -> NSURL {
      
        
        let path = getCacheDirectory().stringByAppendingString(fileName)
        
        let filePath = NSURL(fileURLWithPath: path)
        
        return filePath

    }
       /* if let fileManager = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first {
            let soundURL = fileManager.URLByAppendingPathComponent("audio.m4a")
            return soundURL
        } else {
            return self.fileName
        } */
        
          
    
    // MARK:- AVAudioPlayer delegate methods
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.enabled = true
        playButton.setTitle("Play", forState: .Normal)
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        print("Error while playing audio \(error!.localizedDescription)")
    }
    
    // MARK:- AVAudioRecorder delegate methods
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        playButton.enabled = true
        recordButton.setTitle("Record", forState: .Normal)
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder, error: NSError?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
    

    
    
    //MARK -- Random Quote Generator, web service requirement
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

