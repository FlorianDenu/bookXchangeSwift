//
//  AppDelegate.swift
//  bookXchange
//
//  Created by emily on 2017-05-27.
//  Copyright © 2017 florian inc. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        //MARK: Google sign in
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        loadData()
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: Google sign in function
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        return  GIDSignIn.sharedInstance().handle(url,
//                                                 sourceApplication: sourceApplication,
//                                                 annotation: annotation)
//    }
    
    

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if (url.absoluteString.contains("FACEBOOK_ID")) {
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
        }
        else {
            return GIDSignIn.sharedInstance().handle(url as URL!, sourceApplication: sourceApplication, annotation: annotation)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print("error while sign in using google \(error)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        print("sign in with google successfull, this is the credential \(credential)")
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("error while getting the user information \(error)")
                return
            }else{
                
//                let user = Auth.auth().currentUser
//                if let user = user {
//                    // The user's ID, unique to the Firebase project.
//                    // Do NOT use this value to authenticate with your backend server,
//                    // if you have one. Use getTokenWithCompletion:completion: instead.
//                    let uid = user.uid
//                    let email = user.email
//                    let photoURL = user.photoURL
//                    print("user email \(email)")
//                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    //MARK: - Facebook sign in
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }else{
            print("Facebook sign in successfull")
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    print("Error while sign in the user with facebook, this is the error \(error)")
                    return
                }else{
                    print("The user \(user?.displayName), is sign in")
                }
                // User is signed in
                // ...
            }
        }
    }
    
    private func loadData(){
        GlobalManager.languages { (languages, error) in
            print("fetch the languages")
            if error == false {
                if languages!.count > 0{
                    print("number of languages \(languages!.count)")
                }
            }else{
                print("error while fetching the language from the api")
            }
        }
        
        GlobalManager.genders { (genders, error) in
            if genders!.count > 0{
                print("number of genders \(genders!.count)")
            }
        }
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
}

