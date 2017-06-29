//
//  ViewController.swift
//  bookXchange
//
//  Created by emily on 2017-05-27.
//  Copyright © 2017 florian inc. All rights reserved.
//

import UIKit
import FirebaseAuth
import AlamofireImage
import Alamofire
import DGActivityIndicatorView


extension ListOfBookViewController: UICollectionViewDataSource{
    
}
extension ListOfBookViewController: UICollectionViewDelegate{
    
}
extension ListOfBookViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Filter the array with all this option of searching
        //        self.booksSearchResult = self.books.filter{$0.title == searchText || $0.author.firstName == searchText || $0.author.lastName == searchText || $0.gender.genderDescription == searchText || String($0.isbn) == searchText || $0.language.languageDescription == searchText || $0.publisher.name == searchText || $0.series == searchText}
        self.booksSearchResult = self.books.filter{$0.title.contains(searchText) || $0.author.firstName.contains(searchText) || $0.author.lastName.contains(searchText)
        || $0.gender.debugDescription.contains(searchText) || String($0.isbn).contains(searchText) || $0.language.languageDescription.contains(searchText)
        || $0.publisher.name.contains(searchText) || $0.series.contains(searchText)}
        if booksSearchResult.count == 0{
            searchActive = false
        }else{
            searchActive = true
        }
        self.imagesFiltered.removeAll()
        for book in self.booksSearchResult{
            self.imagesFiltered.append(contentsOf: self.images.filter{$0.bookId == book.bookId})
        }
        self.bookCollectionView.reloadData()
        
    }
}



class ListOfBookViewController: UIViewController{

    // MARK: Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bookCollectionView: UICollectionView!
    
    // MARK: Instance variables
    
    let reuseIdentifier = "bookCell"
    let bookInformationIdentifier = "bookInformationSegue"
    var imagesBook = [ImageBook]()
    var books = [Book]()
    var booksSearchResult = [Book]()
    var images = [ImageModel]()
    var imagesFiltered = [ImageModel]()
    var handle : Auth!
    var loadingIndicator: DGActivityIndicatorView!
    var refreshControl: UIRefreshControl!
    var searchController: UISearchController!
    var searchActive : Bool = false
    
    // MARK: Application life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.green
        UITabBar.appearance().tintColor = UIColor.green  
        //Loading indicator
        loadingIndicator = getLoadingIndicator()
        self.view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        
        //Set delegate
        bookCollectionView.delegate = self
        bookCollectionView.dataSource = self
        
        //Search controller
        searchBar.delegate = self
        
        //Api call for list of images
        ImageManager.imageBook { (responseData, error) in
            if error == false {
                if let response = responseData{
                    self.imagesBook = response
                    //Once we get all the url we download the image and add to the array
                    for image in self.imagesBook{
                        if image.primary == true{
                            let url = URL(string: image.value)!
                            print("url ==> \(url)")
                            ImageManager.image(url: url) { (imageFromApi) in
                                self.loadingIndicator?.stopAnimating()
                                let radius: CGFloat = 10.0
                                let roundedImage = imageFromApi?.af_imageRounded(withCornerRadius: radius)
                                self.images.append(ImageModel(imageId: image.imageId, bookId: image.bookId, image: roundedImage!))
                                self.bookCollectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        BookManager.localBook { (books, error) in
            if error == false{
                self.books = books!
            }
        }
    }
    
    //Get the user information
//    override func viewWillAppear(_ animated: Bool) {
//        if Auth.auth().currentUser != nil {
//            let user = Auth.auth().currentUser
//            if let user = user {
//                // The user's ID, unique to the Firebase project.
//                // Do NOT use this value to authenticate with your backend server,
//                // if you have one. Use getTokenWithCompletion:completion: instead.
//                let uid = user.uid
//                let email = user.email
//                let photoURL = user.photoURL
//                print("This is the user email \(email)")
//            }
//        } else {
//            print("The user is not sign in")
//        }
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    // MARK: - Segue
    
    @IBAction func unwindToListOfBook(segue:UIStoryboardSegue) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == bookInformationIdentifier {
            let vc = segue.destination as! BookDetailViewController
            if let itemSelected = bookCollectionView.indexPathsForSelectedItems?.first{
                vc.bookId = images[itemSelected.item].bookId
            }
            
        }
    }
    
    // MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (searchActive){
            return imagesFiltered.count
        }
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageBookCollectionViewCell
        if(searchActive){
            cell.imagebookImageView.image = self.imagesFiltered[indexPath.row].image
        }else{
            cell.imagebookImageView.image = self.images[indexPath.row].image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        return CGSize(width: screenWidth / 2.1, height: (screenHeight / 2.5) - 30);
    }
    
    //MARK: - Refresh
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        GlobalManager.deleteAlldb()
        images.removeAll()
        imagesBook.removeAll()
        print("everithing is deleted")
        ImageManager.imageBook { (responseData, error) in
            print("Get the response")
            if error == false {
                if let response = responseData{
                    print("Befor setting the imagesBook array")
                    self.imagesBook = response
                    print("After setting the image book array")
                    //Once we get all the url we download the image and add to the array
                    for image in self.imagesBook{
                        print("we will download the image from the url")
                        if image.primary == true{
                            let url = URL(string: image.value)!
                            print("url ==> \(url)")
                            ImageManager.image(url: url) { (imageFromApi) in
                                self.loadingIndicator?.stopAnimating()
                                let radius: CGFloat = 20.0
                                let roundedImage = imageFromApi?.af_imageRounded(withCornerRadius: radius)
                                print("just befor adding the new book")
                                self.images.append(ImageModel(imageId: image.imageId, bookId: image.bookId, image: roundedImage!))
                                self.bookCollectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        self.refreshControl.endRefreshing()
        UserManager.users{ (users, error) in
            if error == false{
                print("number of user \(users!.count)")
            }
        }
        ImageManager.imageBooksLink{(responseData, error) in
            if error == false{
                print("image book link ok")
            }
        }
        UserManager.userBooks { (userBooks, error) in
            if error == false{
                print("user list of book ok")
            }
        }
        BookManager.books{ (books, error) in
            if error == false{
                print("Download all book ok")
            }
        }
    }
    
//    ImageManager.imageBook { (responseData, error) in
//    if error == false {
//    print("error false")
//    let array1:Set<ImageBook> = Set(responseData!)
//    let array2:Set<ImageBook> = Set(self.imagesBook)
//    
//    let diff = array1.symmetricDifference(array2)
//    print("number of difference \(diff.count)")
//    for image in diff{
//    if image.primary == true{
//    let url = URL(string: image.value)!
//    print("url ==> \(url)")
//    ImageManager.image(url: url) { (imageFromApi) in
//    self.loadingIndicator?.stopAnimating()
//    let radius: CGFloat = 20.0
//    let roundedImage = imageFromApi?.af_imageRounded(withCornerRadius: radius)
//    self.images.append(ImageModel(imageId: image.imageId, bookId: image.bookId, image: roundedImage!))
//    self.bookCollectionView.reloadData()
//    }
//    }
//    }
//    }
//    }
//    self.refreshControl.endRefreshing()
}

