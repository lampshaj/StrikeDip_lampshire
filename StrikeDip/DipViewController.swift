//
//  SecondViewController.swift
//  StrikeDip
//
//  Created by Aaron Lampshire on 11/19/17.
//  Copyright © 2017 Aaron Lampshire. All rights reserved.
//

//TODO - pause when you press the buttons

import UIKit
import CoreMotion

class DipViewController: UIViewController {
    @IBOutlet weak var dipLabel: UILabel!
    @IBOutlet weak var dipButton: UIButton!
    @IBOutlet weak var dipButtonTapped: UITapGestureRecognizer!
    
//    var angle:Double
    var moManager = CMMotionManager()
    var angle:String = String()
    var storedDip:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dipButton.backgroundColor = UIColor(red: 4/255, green: 65/255, blue: 79/255, alpha: 1)
        dipLabel.textColor = UIColor(red: 4/255, green: 65/255, blue: 79/255, alpha: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        angle = "101"
        
        moManager.deviceMotionUpdateInterval = 0.2
        moManager.startDeviceMotionUpdates(to: OperationQueue.current!){(data, error) in
            if let myData = data{
            let rate = myData.attitude
            self.dipLabel.text = String(describing: rate)
//            let tiltAngle = Double((attitude.pitch) * 180.0/Double.pi)
//            print(tiltAngle)
//            let tiltNS = tiltAngle as NSNumber
//            let wholeNumberformatter = NumberFormatter()
//            let dipAngle = wholeNumberformatter.string(from: tiltNS)
//            //                self.angle = dipAngle!
//            //                print(self.angle)
//            self.dipLabel.text = "\(String(describing: dipAngle))°"
            }
        }
        
//        if moManager.isDeviceMotionAvailable == true{
            moManager.deviceMotionUpdateInterval = 0.2
            let queue = OperationQueue()
            moManager.startDeviceMotionUpdates(to: queue){(data, error) in
//                if (data != nil){
                let attitude = data?.attitude
                let tiltAngle = Double((attitude?.pitch)! * 180.0/Double.pi)
                    //print(tiltAngle)
                let tiltNS = tiltAngle as NSNumber
                let wholeNumberformatter = NumberFormatter()
                let dipAngle = wholeNumberformatter.string(from: tiltNS)
                self.angle = dipAngle!
                //print(self.angle)
                
                //needed to get around UI updates to main thread
                DispatchQueue.main.async{
                        self.dipLabel.text = "\(String(describing: self.angle))°"
                    }
                }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func dipButtonTapped(sender: UIButton){
        storedDip = angle
        
        SharedVariables.sharedInstance.storedDipValue = storedDip
        print("Stored angle " + storedDip)
    }

}

