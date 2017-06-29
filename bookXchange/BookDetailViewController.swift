//
//  BookDetailViewController.swift
//  bookXchange
//
//  Created by emily on 2017-06-10.
//  Copyright © 2017 florian inc. All rights reserved.
//

import UIKit
import AlamofireImage

class BookDetailViewController: UIViewController {
    
    //MARK: - Instance variables
    var bookId: Int!
    var book: Book!
    var user: User!
    var images = [Image]()
    var currentPosition = 0
    
    var pageViewController: UIPageViewController?
    
    //MARK: - Application life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        //Get the book
        if bookId != nil {
            getBookInformation()
        }
        //Set up the gesture
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        //Page controller 
        self.pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        self.pageViewController!.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    //MARK: - Gesture
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                navigationController?.popToRootViewController(animated: true)
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
                if currentPosition > 0 {
                    currentPosition -= 1
                    self.setImageBackground()
                }else{
                    let swipeInformation = (storyboard?.instantiateViewController(withIdentifier: "SwipeInformationViewController")) as! SwippedBookInformationViewController
                    swipeInformation.book = book
                    swipeInformation.user = user
                    self.addChildViewController(swipeInformation)
                    swipeInformation.view.frame = self.view.frame
                    self.view.addSubview((swipeInformation.view)!)
                    swipeInformation.didMove(toParentViewController: self)
                }
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
                print("\(currentPosition) and image count \(images.count)")
                if currentPosition < (images.count - 1) {
                    print("we increment the position")
                    currentPosition += 1
                    self.setImageBackground()
                }
            default:
                break
            }
        }
    }
    
    //MARK: - Methods
    func setImageBackground(){
        print("This is the image that have been downloaded \(images[currentPosition])")
        self.view.backgroundColor = UIColor(patternImage: images[currentPosition])
    }
    
    private func getBookInformation(){
        let bookByIdPredicate = "bookId = \(bookId!)"
        BookManager.localBook(predicate: bookByIdPredicate, { (books, error) in
            if error == false{
                self.book = books!.first
                print("This is the book title \(self.book.title)")
            }else{
                print("Error while getting the book by id")
            }
        })
        let imageBookPredicate = "bookId = \(bookId!)"
        ImageManager.localImagesBook(predicate: imageBookPredicate, { (imageBook, error) in
            if error == false{
                for image in imageBook!{
                    ImageManager.image(url: URL(string: image.value)!, { (imageView) in
                        self.images.append(imageView!)
                        self.setImageBackground()
                        print("value of images \(self.images.count)")
                    })
                }
            }else{
                print("Error while getting the image book")
            }
        })
        print("we fetch the user that have the book")
        UserManager.localUserBooks(bookId: bookId!, { (users, error) in
            if error == false{
                if let user = users?.first{
                    print("This is the user that own the book \(user.firstName)")
                    self.user = user
                }
            }else{
                print("error while getting the owner of the book")
            }
        })
    }
}

extension BookDetailViewController: UIPageViewControllerDelegate{
    
}

//MARK: - Extension for the background setting
extension UIView {
    func addBackground(value: NSData, contextMode: UIViewContentMode = .scaleToFill) {
        // setup the UIImageView
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = UIImage(data: value as Data)
        backgroundImageView.contentMode = contentMode
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundImageView)
        sendSubview(toBack: backgroundImageView)
        let leadingConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }
}
