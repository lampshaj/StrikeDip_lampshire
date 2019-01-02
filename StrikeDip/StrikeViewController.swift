//
//  FirstViewController.swift
//  StrikeDip
//
//  Created by Aaron Lampshire on 11/19/17.
//  Copyright © 2017 Aaron Lampshire. All rights reserved.
//

import UIKit
import CoreLocation

class SharedVariables:NSObject{
    static let sharedInstance = SharedVariables()
    
    var storedStrikeValue:String = "default";
    var storedDipValue:String = "default";
    private override init(){}
}

class StrikeViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var northLabel: UILabel!
    @IBOutlet weak var strikeButton: UIButton!
    @IBOutlet weak var buttonTapped: UITapGestureRecognizer!
    @IBOutlet weak var strikeImage: UIImageView!
    var locManager = CLLocationManager()
    var heading:CGFloat = 1.5
    var strikeMeasurement:String = ""
    var storedStrikeMeasurement:String = ""
    
    var storedLat: CLLocationDegrees = CLLocationDegrees()
    var storedLong: CLLocationDegrees = CLLocationDegrees()
    var blue = UIColor(red: 4/255, green: 65/255, blue: 79/255, alpha: 1)
    let orange = UIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1)
    let white = UIColor(red: 255/255, green: 239/255, blue: 213/255, alpha: 1)
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //request permission to steal location data
        locManager.requestWhenInUseAuthorization()
        locManager.headingOrientation = .portrait
        locManager.headingFilter = kCLHeadingFilterNone
        locManager.delegate = self // you forgot to set the delegate
        
        locManager.startUpdatingLocation()
        locManager.startUpdatingHeading()
        label.text = "test"
        label.text = "1.0"
//        self.SD.transform = self.SD.transform.rotated(by: CGFloat(heading)) //90degrees
        
        //self.tabBarController?.tabBar.barTintColor = UIColor(red: 155/255, green: 75/255, blue: 4/255, alpha: 1)
        self.tabBarController?.tabBar.barTintColor = UIColor(red: 4/255, green: 65/255, blue: 79/255, alpha: 1)//blue background
        //self.tabBarController?.tabBar.tintColor = UIColor(red: 155/255, green: 75/255, blue: 4/255, alpha: 1) //orange
        self.tabBarController?.tabBar.tintColor = UIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1) //orange
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(red: 255/255, green: 239/255, blue: 213/255, alpha: 1) //off white
        strikeButton.backgroundColor = UIColor(red: 4/255, green: 65/255, blue: 79/255, alpha: 1)
        
    }
    
    // MARK: -
    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed: \(error)")
    }
    
    // Heading readings tend to be widely inaccurate until the system has calibrated itself
    // Return true here allows iOS to show a calibration view when iOS wants to improve itself
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    // This function will be called whenever your heading is updated. Since you asked for best
    // accuracy, this function will be called a lot of times. Better make it very efficient
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let when = DispatchTime.now() + 1
        let degree2:CGFloat = CGFloat(newHeading.magneticHeading)
        let degreeD:Double = Double(degree2)
        let degreeNS:NSNumber = degreeD as NSNumber
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            let wholeNumberformatter = NumberFormatter()
            let wholeNumber = wholeNumberformatter.string(from: degreeNS) //heading number to be displayed i.e. 180
            
            //var degree: String = "\(String(describing: newHeading.magneticHeading))°"
//            let degree2:CGFloat = CGFloat(newHeading.magneticHeading)
            let oldDegree:Double = Double(degree2)
            let difference:Double = oldDegree - Double(CGFloat(newHeading.magneticHeading))
            //print(difference)
            let degreeConvert:Double = Double(degree2)
            let newOrientation:CGFloat = CGFloat(degreeConvert + difference)
            
            
            self.label.text = "\(wholeNumber ?? "0")°"
           
            //print("image radians", 10*(degree2 / (180.0 * CGFloat(Double.pi))))
            let imageOrientation = 10*(newOrientation / (180.0 * CGFloat(Double.pi)))
            
            //set strike measurement to wholeNumber
            self.strikeMeasurement = wholeNumber!
            
            if difference != 0{
                //print("****")
                //print(difference)
            }
            
            //rotates the image SD
            self.strikeImage.transform = CGAffineTransform(rotationAngle: CGFloat(imageOrientation))
            
            //get lat and long, maybe convert to UTM if there's enough time
            
            
        }
    }
    
    @IBAction func strikeButtonTapped(sender: UIButton){
        //store the strike measurement in strike variable or call method instead of passing variables
        storedStrikeMeasurement = strikeMeasurement
        print("stored strike " + storedStrikeMeasurement)
        
        //check if user ok'd location request
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
        
            let location = self.locManager.location
            storedLat = (location?.coordinate.latitude)!
            storedLong = (location?.coordinate.longitude)!
//            storedStrikeMeasurement = storedLat
            
            SharedVariables.sharedInstance.storedStrikeValue = storedStrikeMeasurement
            print(SharedVariables.sharedInstance.storedStrikeValue)
        }
    }
    
}

