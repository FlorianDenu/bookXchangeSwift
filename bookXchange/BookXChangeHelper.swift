//
//  BookXChangeHelper.swift
//  bookXchange
//
//  Created by emily on 2017-05-28.
//  Copyright © 2017 florian inc. All rights reserved.
//
import UIKit
import Foundation
import DGActivityIndicatorView

public func checkIfEmailCorrect(email: String)-> Bool{
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
}

public func simpleAlert(view: UIViewController,title: String, message: String, buttonText : String){
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: buttonText, style: UIAlertActionStyle.default, handler: nil))
    view.present(alert, animated: true, completion: nil)
}

public func separateFirstNameAndLastName(author: [String]) -> [String]{
    var authorString = author.flatMap({$0}).joined()
    authorString = authorString.replacingOccurrences(of: "[", with: "")
    authorString = authorString.replacingOccurrences(of: "]", with: "")
    authorString = authorString.replacingOccurrences(of: "\"", with: "")
    return authorString.components(separatedBy: " ")
}

public func getLoadingIndicator() -> DGActivityIndicatorView{
    let screenSize: CGRect = UIScreen.main.bounds
    let screenWidth = screenSize.width
    let screenHeight = screenSize.height
    let width : CGFloat = 50.0
    let height : CGFloat = 50.0
    let loadingIndicator = DGActivityIndicatorView(type: .ballPulse, tintColor: UIColor.green)
    loadingIndicator?.frame = CGRect(x: ((screenWidth/2) - (width/2)), y: ((screenHeight/2) - (height/2)), width: width, height: height)
    return loadingIndicator!
}

