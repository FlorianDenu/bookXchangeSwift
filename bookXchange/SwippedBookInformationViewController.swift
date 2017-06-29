//
//  SwippedBookInformationViewController.swift
//  bookXchange
//
//  Created by emily on 2017-06-10.
//  Copyright © 2017 florian inc. All rights reserved.
//

import UIKit
import MapKit
import ExpandableLabel

class SwippedBookInformationViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: ExpandableLabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var ownerInfoLabel: UILabel!
    
    //MARK: - Instance variables
    let regionRadius: CLLocationDistance = 1000
    var book: Book!
    var user: User!
    
    //MARK: - Application life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if book != nil {
           displayBookInformations()
        }
        if user != nil{
            displayUserInformations()
        }
        
        let initialLocation = CLLocation(latitude: (user.address.latitude), longitude: (user.address.longitude))
        centerMapOnLocation(location: initialLocation)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        descriptionLabel.collapsedAttributedLink = NSAttributedString(string: "Read More")
        descriptionLabel.setLessLinkWith(lessLink: "Close", attributes: [NSForegroundColorAttributeName:UIColor.red], position: nil)

    }

    //MARK: - Map methods
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        
        let annotation = MKPointAnnotation();
        annotation.coordinate = CLLocationCoordinate2D(latitude: (user.address.latitude), longitude: (user.address.longitude))
        mapView.addAnnotation(annotation)
            
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //MARK: - Gesture
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
                self.view.removeFromSuperview()
            default:
                break
            }
        }
    }

    //MARK: - Display information methods
    private func displayBookInformations(){
        titleLabel.text = book.title
        authorLabel.text = "\(book.author.firstName) \(book.author.lastName )"
        descriptionLabel.text = book.desc
    }
    private func displayUserInformations(){
        addressLabel.text = "\(user.address.postalCode), \(user.address.city.cityName)"
        ownerInfoLabel.text = user.email
        if user.profilePicture != "" {
            print("the url is not nill")
            ImageManager.image(url: URL(string: user.profilePicture)!, { (image) in
                let circularImage = image?.af_imageRoundedIntoCircle()
                self.userProfileImageView.image = circularImage
            })
        }else{
            print("The user profile picture is empty")
        }
    }
}
