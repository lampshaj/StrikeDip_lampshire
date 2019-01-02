//
//  StationDetailViewController.swift
//  StrikeDip
//
//  Created by Aaron Lampshire on 12/7/17.
//  Copyright © 2017 Aaron Lampshire. All rights reserved.
//

//TODO - image features so that it can be changed
//core data problems

import UIKit
import CoreLocation
import CoreData

class StationDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate  {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var coordinatesButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var notesTextView:UITextView!
    @IBOutlet weak var strike: UITextField!
    @IBOutlet weak var dip: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var geoImage: UIImageView!
    
    var locManager = CLLocationManager()
    var storedLat: CLLocationDegrees = CLLocationDegrees()
    var storedLong: CLLocationDegrees = CLLocationDegrees()
    //weak var toDoItem:ToDoItem?
    weak var stationItem:StationItem?
    //image stuff
    var shown: Bool = false
    var imageView:UIImageView = UIImageView()
    let blue = UIColor(red: 4/255, green: 65/255, blue: 79/255, alpha: 1)
    let orange = UIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1)
    let white = UIColor(red: 255/255, green: 239/255, blue: 213/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = stationItem?.title
        locationLabel.isHidden = true
        coordinatesButton.backgroundColor = blue
        photoButton.backgroundColor = blue
        notesTextView.layer.cornerRadius = 15.0
        strike.borderStyle = UITextBorderStyle.none
        dip.borderStyle = UITextBorderStyle.none
        
        self.view.backgroundColor = white
        //self.navigationController!.navigationBar.tintColor = blue //this changed the back button color to blue
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: white]
        
        //title not updating that the best time, update immediately
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //load previously saved data
        if let item = stationItem{
            navigationItem.title = item.title
            if item.notes != nil{
                notesTextView.text = item.notes
                notesTextView.textColor = UIColor.black
            }
            print(SharedVariables.sharedInstance.storedStrikeValue)
            if item.strike != nil{
                strike.text = item.strike
                strike.textColor = UIColor.black
            }else if SharedVariables.sharedInstance.storedStrikeValue != "default"{
                print(SharedVariables.sharedInstance.storedStrikeValue)
                strike.text = SharedVariables.sharedInstance.storedStrikeValue
                strike.textColor = UIColor.black
            }
            //get stored dip value
            if item.dip != nil{
                dip.text = item.dip
                dip.textColor = UIColor.black
            }else if SharedVariables.sharedInstance.storedDipValue != "default"{
                print(SharedVariables.sharedInstance.storedDipValue)
                strike.text = SharedVariables.sharedInstance.storedDipValue
                strike.textColor = UIColor.black
            }
            
            if item.coordinates != nil{
                print(item.coordinates as Any)
                locationLabel.text = item.coordinates
                locationLabel.textColor = UIColor.black
                coordinatesButton.isHidden = true
                locationLabel.isHidden = false
                locationLabel.backgroundColor = UIColor.groupTableViewBackground
                locationLabel.textAlignment = NSTextAlignment.center
            }
            if item.photo != nil{
                let imageData = item.photo
                geoImage.image = UIImage(data: imageData!)
                photoButton.isHidden = true
            }
        }
    }
    
    //when the view disappears, save the data
    override func viewWillDisappear(_ animated: Bool) {
        if let item = stationItem{

            if notesTextView.text != "Station Notes" && notesTextView.text != ""{
                item.notes = notesTextView.text
            }
            if strike.text != "Strike" && strike.text != ""{
                item.strike = strike.text
            }
            if dip.text != "Dip & Heading" && dip.text != ""{
                item.dip = dip.text
            }
//            if geoImage.image == nil{
//               print(geoImage)
//               print("no image")
//            } else{
            //make sure you don't have the UIImageview instead of the UIImageview.image to perform this!
            if geoImage.image != nil {
                let imageData:NSData = UIImagePNGRepresentation(geoImage.image!)! as NSData
                item.photo = imageData as Data
            }
            if locationLabel != nil{
                print(locationLabel.text as Any)
                item.coordinates = locationLabel.text
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //erases the default text in the notes field
    func textViewDidBeginEditing(_ textView: UITextView) {
        if notesTextView.text == "Station Notes" {
            notesTextView.text = ""
            notesTextView.textColor = UIColor.black
        }
    }
    
    @IBAction func getCoordinates(sender: UIButton){
        
        let location = self.locManager.location
        storedLat = (location?.coordinate.latitude)!
        storedLong = (location?.coordinate.longitude)!
        
        //hide the button after the coordinates have been set, so they aren't released
        coordinatesButton.isHidden = true
        print(storedLat)
        print(storedLong)
        
        locationLabel.backgroundColor = UIColor.groupTableViewBackground
        locationLabel.textAlignment = NSTextAlignment.center
        locationLabel.text = "\(storedLat), \(storedLong)"
        locationLabel.isHidden = false
        //expand the location window when the button hides
    }
    
    
    //give user the option to take a picture or select from gallery
    @IBAction func getPhoto(sender: UIButton){
        //get an image from the gallery
        //present the photo library viewController
            if(shown == false){
                let alert = UIAlertController(title: "Choose an Option", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(alert: UIAlertAction!) in self.getPhotoCamera()}))
                alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {(alert: UIAlertAction!) in self.getPhotoGallery()}))
                alert.addAction(UIAlertAction(title: "Canel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                view.endEditing(true)
                shown = false
            }
    }
    
    func getPhotoCamera(){
        let imagePickerViewController:UIImagePickerController = UIImagePickerController()
        //need to add the delegate as self in order for the camera photo to reach func imagePickerController
        imagePickerViewController.delegate = self
        imagePickerViewController.sourceType = UIImagePickerControllerSourceType.camera
        present(imagePickerViewController, animated: true, completion: nil)
    }
    
    func getPhotoGallery(){
        let imagePickerViewController:UIImagePickerController = UIImagePickerController()
        imagePickerViewController.delegate = self
        present(imagePickerViewController, animated: true, completion: nil)
    }
    
    //should be called when image is picked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image:UIImage! = info[UIImagePickerControllerOriginalImage] as! UIImage
        geoImage.image = image
        dismiss(animated: true, completion: nil)
        photoButton.isHidden = true
    }
    
    @IBAction func screenTapped(){
        view.endEditing(true)
    }
    
    //single tap image to reload image button or double tap to expand image to full screen
    @IBAction func changeImage(){
        //image view needs to have user interaction enabled
        //photoButton.isHidden = false //crude way to relaod imagePicker
        //below seems like a lazy way
//        if(shown == false){
//            
            let imagePickerViewController:UIImagePickerController = UIImagePickerController()
            imagePickerViewController.delegate = self //had an issue with the adopted delegates, the NavigationControllerDelegate was not being adopted
            imagePickerViewController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //        }
            
            present(imagePickerViewController, animated: true, completion: nil)
//        }
//        else{
//            view.endEditing(true)
//            shown = false
//        }
    }
    
    //delete with swipe
    @IBAction func deleteImage(){
        let alert = UIAlertController(title: "Alert", message: "Do you want to remove the photo?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Remove", style: .default, handler: {(alert: UIAlertAction!) in self.deletePhotoFromLongPress()}))
        alert.addAction(UIAlertAction(title: "Canel", style: .cancel, handler: nil))
        geoImage.leftToRightAnimation()
        geoImage.image = nil
        photoButton.isHidden = false
    }
    
    //redo coordinates
    @IBAction func longPressReLocate(){
        //notification to say this isn't advised
        let alert = UIAlertController(title: "Alert", message: "You're about to change the coordinates, your current position will replace existing data", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(alert: UIAlertAction!) in self.newCoordinates()}))
        alert.addAction(UIAlertAction(title: "Canel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        //if okay'd then show button and hide label; show button in case user doesn't want coordinates displayed
        
    }
    
    //allow user to redo the coordinates if they press okay
    func newCoordinates(){
        locationLabel.isHidden = true
        coordinatesButton.isHidden = false
    }
    

    
    //perferred with users in testing
    @IBAction func longPressDeleteImage(){
        //warn user of the dangers!!!
        let alert = UIAlertController(title: "Alert", message: "Do you want to remove the photo?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Remove", style: .default, handler: {(alert: UIAlertAction!) in self.deletePhotoFromLongPress()}))
        alert.addAction(UIAlertAction(title: "Canel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deletePhotoFromLongPress(){
        geoImage.image = nil
        photoButton.isHidden = false
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

extension UIView{
    func leftToRightAnimation(duration: TimeInterval = 0.5, completionDelegate: AnyObject? = nil) {
    // Create a CATransition object
    let leftToRightTransition = CATransition()
    
    // Set its callback delegate to the completionDelegate that was provided
    if let delegate: CAAnimationDelegate = completionDelegate as! CAAnimationDelegate? {
    leftToRightTransition.delegate = delegate
    }
    
    leftToRightTransition.type = kCATransitionPush
    leftToRightTransition.subtype = kCATransitionFromRight
    leftToRightTransition.duration = duration
    leftToRightTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    leftToRightTransition.fillMode = kCAFillModeRemoved
    
    // Add the animation to the View's layer
    self.layer.add(leftToRightTransition, forKey: "leftToRightTransition")
    }
}
