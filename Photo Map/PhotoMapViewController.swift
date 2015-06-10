//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Alexander Hoekje List on 6/9/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var nextPhoto: UIImage!
    var annotations: [PhotoAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1)), animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraButtonPressed(sender: AnyObject) {
        var vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
             vc.sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
            var originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            var editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            
            dismissViewControllerAnimated(true, completion: nil)
            performSegueWithIdentifier("tagSegue", sender: editedImage)
    }
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber,longitude: NSNumber) {
        var coordinate = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue)
        var image = controller.userInfo as! UIImage
        
        navigationController?.popToViewController(self, animated: true)
        
        var annotation = PhotoAnnotation()
        annotation.coordinate = coordinate
        annotation.photo = image
        
        annotations.append(annotation)
        mapView.addAnnotation(annotation)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var locations = segue.destinationViewController as! LocationsViewController
        locations.delegate = self
        locations.userInfo = sender
    }

}