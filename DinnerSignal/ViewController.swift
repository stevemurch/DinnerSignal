//
//  ViewController.swift
//  DinnerSignal
//
//  Created by Steve Murch on 1/11/18.
//  Copyright © 2018 Steve Murch. All rights reserved.
//

import UIKit
import AVFoundation


var player: AVAudioPlayer?

class ViewController: UIViewController {
    
    
    
    var ipAddressOfficeBridge: String = "192.168.1.253"
    var steveOfficeUsername: String = "8tGTxOPZP05ZDZidaazUFMXH085XRyX6fZ-dolqZ"
    
    var ipAddressGriffinBridge: String = "192.168.1.122"
    var griffinBridgeUsername: String = "wbp63bJ0HQQUKc7-OqKPK5J4CbiziHRwoKogfqcJ"
    
    var testLocation = "xxgriffin-room"
    
    @IBOutlet weak var lblWifiWarning: UILabel!
    var logText = ""
    
    @IBOutlet weak var bridgeSelector: UISegmentedControl!
    
    @IBOutlet weak var txtLog: UITextView!
    
    @IBOutlet weak var turnLightsOff: UIButton!
    
    @IBOutlet weak var kitchenImage: UIImageView!
    
    @IBAction func turnAllLightsOff(_ sender: Any) {
        
        var ip:String = ""
        var username:String = ""
        
        txtLog.text = "Turning lights off...\r\n\r\n"
        
        if (bridgeSelector.selectedSegmentIndex==0)
        {
            ip = ipAddressGriffinBridge
            username = griffinBridgeUsername
        }
        else
        {
            ip = ipAddressOfficeBridge
            username = steveOfficeUsername
        }
        
        for _ in 1...8
        {
            // turn off all lights
            for light in 1...15
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    
                    let theUrl = "http://"+ip+"/api/"+username+"/lights/"+String(light)+"/state"
                    self.putToJSON(url: theUrl, body: ["on":false])
                }
                )
                
            }
        }
    }
    
    
    @IBAction func timeForDinner(_ sender: Any) {
        
        self.txtLog.text = "Signaling time for dinner... \r\n\r\n"
        
        var ip:String = ""
        var username:String = ""
        
        if (bridgeSelector.selectedSegmentIndex==0)
        {
            ip = ipAddressGriffinBridge
            username = griffinBridgeUsername
        }
        else
        {
            ip = ipAddressOfficeBridge
            username = steveOfficeUsername
        }
        
        // update all lights to green
        
        playSound()
        
        // alert
        
        animateImage(iterationsRemaining: 3)
        
        
        for light in 1...15
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {
                
                let theUrl = "http://"+ip+"/api/"+username+"/lights/"+String(light)+"/state"
                
                self.putToJSON(url: theUrl, body: ["alert":"select"])
                // self.txtLog.text = result
                
            }
            )
        }
        
        
        
        for light in 1...15
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                
                let theUrl = "http://"+ip+"/api/"+username+"/lights/"+String(light)+"/state"
                self.putToJSON(url: theUrl, body: ["alert":"select"])
                // self.txtLog.text = result
                
            }
            )}
        
        
        
        for light in 1...15
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
                
                let theUrl = "http://"+ip+"/api/"+username+"/lights/"+String(light)+"/state"
                self.putToJSON(url: theUrl, body: ["alert":"select"])
                // self.txtLog.text = result
                
            }
            )}
        
        for light in 1...15
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(9), execute: {
                
                let theUrl = "http://"+ip+"/api/"+username+"/lights/"+String(light)+"/state"
                self.putToJSON(url: theUrl, body: ["alert":"select"])
                // self.txtLog.text = result
                
            }
            )}
    }
    
    func animateImage(iterationsRemaining: Int)
    {
        
        
        if (iterationsRemaining<=0) {return}
        
        kitchenImage.alpha = 1
        //code to animate bg with delay 2 and after completion it recursively calling animateImage method
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       options:UIViewAnimationOptions.curveEaseOut,
                       animations: {() in
                    
                       self.kitchenImage.alpha = 0;
        },
                                   completion: {
                                    
                                    (Bool) in
                                    
                                    self.kitchenImage.alpha = 0
                                    
                                    UIView.animate(withDuration: 2.0,
                                                   delay: 0,
                                                   options:UIViewAnimationOptions.curveEaseOut,
                                                   animations: {
                                                    () in
                                                   self.kitchenImage.alpha = 1.0;
                                                    }
                                        
                                        ,
                                                   completion: {
                                                    
                                                    (Bool) in
                                                    
                                                    
                                                    self.animateImage(iterationsRemaining: iterationsRemaining-1)
                                                    
                                                    
                                                    
                                    })
                                    
                                    
                                    
                                    
                                    
                                    
        })
            
        
        
        
        
    }
    
    
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "clock_chimes", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func putToJSON(url:String, body:[String:Any])
    {
        let todosEndpoint: String = url
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "PUT"
        let newTodo: [String: Any] = body
        
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            todosUrlRequest.httpBody = jsonTodo
        } catch {
            print("Error: cannot create JSON")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: todosUrlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling PUT")
                
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                
                
                DispatchQueue.main.async{
                    self.txtLog.text = self.txtLog.text + String(describing: data!) + "\r\n"
                }
                
                
                
                
                
                guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: Any] else {
                                                                            
                                                                            print("done")
                                                                            
                                                                            
                                                                            
                                                                            return
                }
                
                
                guard let todoID = receivedTodo["id"] as? Int else {
                    print("Could not get todoID as int from JSON")
                    return
                }
                print("The ID is: \(todoID)")
            } catch  {
                print("error parsing response from POST on /todos")
                return
            }
        }
        task.resume()    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (!SDMNetworkHelper.isConnectedToNetwork()){
            self.lblWifiWarning.isHidden = false
            
            
            
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

