//
//  AddNewBookViewController.swift
//  bookXchange
//
//  Created by emily on 2017-05-28.
//  Copyright © 2017 florian inc. All rights reserved.
//

import UIKit
import SwiftyJSON
import FirebaseAuth
import ActionSheetPicker_3_0

//MARK: - Pickers delegate
extension AddNewBookViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}


class AddNewBookViewController: UIViewController{
    
    //MARK: - Outlets
    @IBOutlet weak var firstImageButton: UIButton!
    @IBOutlet weak var secondImageButton: UIButton!
    @IBOutlet weak var thirdImageButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var desciptionTextView: UITextView!
    @IBOutlet weak var pageTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var publisherNameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var genderButton: UIButton!
    
    //MARK: - Instance variable
    let loginSegue = "loginFirst"
    var isbn: String!
    var priceToSend: String!
    let jpegCompressionQuality: CGFloat = 1
    var valueOfLanguage: Int!
    var valueOfGender: Int!
    var bookInformation: [String : Any]!
    var genders = [Gender]()
    var languages = [Language]()
    var imagePicker: UIImagePickerController!
    var currentImage = 0
    
    //MARK: Application life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setPickers()
        imagePicker =  UIImagePickerController()
        if let items: NSArray = bookInformation["items"] as? NSArray{
            print("This is the item \(items)")
            var firstItem = items[0] as? [String:Any]
            let book = firstItem?["volumeInfo"] as! [String:Any]
            self.displayInformation(book: book)
        }else{
            simpleAlert(view: self, title: "No book find", message: "This book is not recognise", buttonText: "Ok")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("inside the view controller")
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == loginSegue {
            _ = segue.destination as! SignInViewController
        }
    }

    //MARK: - Button action
    @IBAction func didPictureButtonPressed(_ sender: UIButton) {
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        switch sender.tag {
        case 1:
            currentImage = 1
        case 2:
            currentImage = 2
        case 3:
            currentImage = 3
        default:
            print("Cannot press another button")
        }
    }
    
    @IBAction func didValidateButtonPressed(_ sender: UIButton) {
        var param = getRequestParam()
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            if let user = user {
                param["email"] = user.email
                param["apiKey"] = user.uid
                BookManager.addBook(parameters: param as [String : AnyObject]) { (response, error) in
                    if error == false{
                        if response?.first?.error == false{
                            print("Book saved")
                            self.tabBarController?.selectedIndex = 0
                        }
                    }else{
                        print("an error occure while saving the book")
                    }
                }
            }
        } else {
            alertWithSegue(view: self, title: "You are not logged in", message: "To add your book, you need to login first", buttonText: "Ok", identifier: loginSegue)
        }
    }
    
    @IBAction func didLanguageButtonPressed(_ sender: UIButton) {
        ActionSheetMultipleStringPicker.show(withTitle: "Gender selection", rows: [
            languages.map{$0.languageDescription}
            ], initialSelection: [1], doneBlock: {
                picker, indexes, values in
                self.valueOfLanguage = indexes!.first as! Int
                let language = values as! Array<String>
                self.languageButton.setTitle(language.first , for: .normal)
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func didGenderButtonPressed(_ sender: UIButton) {
        ActionSheetMultipleStringPicker.show(withTitle: "Gender selection", rows: [
            genders.map{$0.genderDescription}
            ], initialSelection: [1], doneBlock: {
                picker, indexes, values in
                self.valueOfGender = indexes!.first as! Int
                let gender = values as! Array<String>
                self.genderButton.setTitle(gender.first , for: .normal)
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
    }
    
    //MARK: - Picker actions
    func imagePickerController(_ picker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [String : Any]) {
        let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        switch currentImage {
        case 1:
            print("we press the first image")
            firstImageButton.setImage(image, for: .normal)
        case 2:
            secondImageButton.setImage(image, for: .normal)
        case 3:
            thirdImageButton.setImage(image, for: .normal)
        default:
            print("Cannot press another button")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    
    
    //MARK: - Picker setUp
    private func setPickers(){
        GlobalManager.localGenders { (genders, error) in
            if error == false{
                self.genders = genders!
                self.genders.sort{$0.genderDescription < $1.genderDescription}
            }
        }
        GlobalManager.localLanguages { (languages, error) in
            if error == false{
                self.languages = languages!
                self.languages.sort{$0.languageDescription < $1.languageDescription}
            }
        }
    }
    
    //MARK: - Methodes
    private func displayInformation(book: [String:Any]){
        if let title = book["title"] as? String{
            titleTextField.text = title
        }
        if let subtitle = book["subtitle"]{
            var addSubtitle = subtitle as! String
            addSubtitle = ". " + addSubtitle
            titleTextField.text = titleTextField.text! + addSubtitle
        }
        if let description = book["description"] as? String{
            desciptionTextView.text = description
        }
        if let page = book["pageCount"] as? Int{
            pageTextField.text = String(page)
        }
        if let price = book["retailPrice"] as? [String:Any]{
            priceToSend = price["amount"] as? String
        }
        if let author = book["authors"] as? [String]{
            let authorArray = separateFirstNameAndLastName(author: author)
            firstNameTextField.text = authorArray[0]
            lastNameTextField.text = authorArray[1]
        }
        if let publisher = book["publisher"] as? String{
            publisherNameTextField.text = publisher
        }
        if let publishedDdate = book["publishedDate"] as? String{
            dateTextField.text = publishedDdate
        }
        if let imageUrl = book["imageLinks"] as? [String:Any]{
            ImageManager.image(url: URL(string:imageUrl["thumbnail"] as! String)!, { (image) in
                self.firstImageButton.setImage(image, for: .normal)
            })
        }
    }

    private func getRequestParam() -> [String: String]{
        var param = [String:String]()
        if checkIfMandatoryFieldEmpty() {
            print("Display message empty field")
        }else{
            if !checkifImageAsBeenChanged(image: (firstImageButton.imageView?.image)!) {
                print("the image have been changed")
                if let base64String = UIImageJPEGRepresentation((firstImageButton.imageView?.image!)!, jpegCompressionQuality)?.base64EncodedString() {
                    param["picture1"] = base64String
                }
            }
            if !checkifImageAsBeenChanged(image: (secondImageButton.imageView?.image)!) {
                if let base64String = UIImageJPEGRepresentation((secondImageButton.imageView?.image!)!, jpegCompressionQuality)?.base64EncodedString() {
                    param["picture2"] = base64String
                }
            }
            if !checkifImageAsBeenChanged(image: (thirdImageButton.imageView?.image)!) {
                if let base64String = UIImageJPEGRepresentation((thirdImageButton.imageView?.image!)!, jpegCompressionQuality)?.base64EncodedString() {
                    param["picture2"] = base64String
                }
            }
            if let title = titleTextField.text, !title.isEmpty{
                param["title"] = title
            }
            if !isbn.isEmpty{
                param["isbn"] = isbn
            }
            if priceToSend != nil{
                param["price"] = priceToSend
            }else{
                param["price"] = "0"
            }
            param["available"] = "1"
            param["series"] = ""
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            param["dateAdded"] = formatter.string(from: date)
            if let description = desciptionTextView.text, !description.isEmpty{
                param["description"] = description
            }
            if valueOfLanguage != nil{
                param["language"] = languages[valueOfLanguage].languageDescription
            }
            if valueOfGender != nil{
                param["gender"] = genders[valueOfGender].genderDescription
            }
            if let page = pageTextField.text, !page.isEmpty{
                param["page"] = page
            }
            if let firstName = firstNameTextField.text, !firstName.isEmpty{
                param["firstName"] = firstName
            }
            if let lastName = lastNameTextField.text, !lastName.isEmpty{
                param["lastName"] = lastName
            }
            if let publisherName = publisherNameTextField.text, !publisherName.isEmpty{
                param["name"] = publisherName
            }
            if let datePublished = dateTextField.text, !datePublished.isEmpty{
                param["date"] = datePublished
            }
        }
        return param
    }
    //MARK: - Checking methods
    private func checkIfMandatoryFieldEmpty()->Bool{
        var emptyField = false
        emptyField = checkifImageAsBeenChanged(image: (firstImageButton.imageView?.image!)!)
        if let title = titleTextField.text, title.isEmpty{
            emptyField = true
        }
        return emptyField
    }
    
    private func checkifImageAsBeenChanged(image: UIImage)-> Bool{
        var emptyField = false
        if let imageAdd = UIImage(named: "Camera") {
            let addPhotoImage = UIImagePNGRepresentation(imageAdd)
            let compareImageData = UIImagePNGRepresentation(image)
            if let empty = addPhotoImage,let compareTo = compareImageData {
                if empty == compareTo {
                    emptyField = true
                }
            }
        }
        return emptyField
    }
    
    //MARK: - Alert popUp
    func alertWithSegue(view: UIViewController,title: String, message: String, buttonText : String, identifier: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.performSegue(withIdentifier: identifier, sender: nil)
        }
        alert.addAction(okAction)
        view.present(alert, animated: true, completion: nil)
    }
}
