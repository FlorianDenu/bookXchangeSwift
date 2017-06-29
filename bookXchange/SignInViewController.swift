//
//  SignInViewController.swift
//  bookXchange
//
//  Created by emily on 2017-05-27.
//  Copyright © 2017 florian inc. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
import CoreLocation

extension SignInViewController: GIDSignInUIDelegate, CLLocationManagerDelegate {
    
}

class SignInViewController: UIViewController{

    //: MARK Outlets
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var googleSignIn: GIDSignInButton!
    @IBOutlet weak var facebookSignIn: FBSDKLoginButton!
    @IBOutlet weak var bookXchangeAccountLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    //MARK: - Instance variable
    
    var locationManager = CLLocationManager()
    var credential : AuthCredential!
    var emailEnteredIsValid = false
    
    //MARK: - Application life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        logInButton.isEnabled = false
        signInButton.isEnabled = false
        passwordTextField.isSecureTextEntry = true
        cityTextField.isHidden = true
        setUpLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        if Auth.auth().currentUser != nil {
            presentSignInMethods(true)
        } else {
            presentSignInMethods(false)
            print("The user is not sign in")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Button action
    
    @IBAction func didGoogleSignInPressed(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didFacebookSignInPressed(_ sender: UIButton) {
        let loginManager = LoginManager()

        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in! this is hte grantedPermission \(grantedPermissions), this is the declinePermission \(declinedPermissions), this is the access token \(accessToken)")
            }
        }
    }
    
    @IBAction func didLogInButtonPressed(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user != nil{
                self.dismiss(animated: true, completion: nil)
            }else{
                simpleAlert(view: self, title: "Probleme while log in", message: "Something went wrong, please try again later", buttonText: "Ok i forgive you")
            }
        }
    }

    @IBAction func didSignInButtonPressed(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            let errorCode = (error! as NSError).code
            if user != nil{
                //TODO: save the use into database
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }else if errorCode == 17007 {
                simpleAlert(view: self, title: "Account with this email already exists", message: "Recovert your password or create another account", buttonText: "Ok")
            
            }else{
                simpleAlert(view: self, title: "Probleme while creating your account", message: "Something went wrong, please try again later", buttonText: "Ok i forgive you")
            }
        }
    }
    
    @IBAction func didLogOutButtonPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        print("press log out")
        do {
            print("press the log out button,")
            try firebaseAuth.signOut()
            self.tabBarController?.selectedIndex = 0
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    //MARK: - Hide and display element depending on login status
    
    func presentSignInMethods(_ display: Bool){
        googleSignIn.isHidden = display
        facebookSignIn.isHidden = display
        bookXchangeAccountLabel.isHidden = display
        emailTextField.isHidden = display
        passwordTextField.isHidden = display
        signInButton.isHidden = display
        logInButton.isHidden = display
        logOutButton.isHidden = !display
    }
    
    
    //MARK: - Email and password methode
    
    func textFieldDidChange(_ textField: UITextField) {
        if textField.tag == 1 || textField.tag == 2 {
            if checkIfEmailCorrect(email: emailTextField.text!) && !emailEnteredIsValid{
                emailEnteredIsValid = true
            } else if emailEnteredIsValid && (passwordTextField.text?.characters.count)! > 5 && passwordTextField.text != "Password"{
                logInButton.isEnabled = true
                signInButton.isEnabled = true
            }
        }
    }
    
    //MARK: - Location
    func setUpLocation(){
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }else{
            cityTextField.isHidden = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        manager.stopUpdatingLocation()
    }
}
