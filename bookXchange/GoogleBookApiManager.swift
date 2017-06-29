//
//  GoogleBookApiManager.swift
//  bookXchange
//
//  Created by emily on 2017-06-04.
//  Copyright © 2017 florian inc. All rights reserved.
//

import Foundation
class GoogleBookApiManager{
    
    class func googleBook(isbn: String, _ completion: @escaping (_ responseData:[String:Any]) -> ()){
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            let url = "\(dict["googleBookUrl"]!)\(isbn)\(dict["googleBookApiKey"]!)"
            print("This is the url of the book \(url)")
            WebServiceManager.sendGoogleApiRequest(url: URL(string: url)!){ (jsonResponse) in
                completion(jsonResponse)
            }
        }
    }
}


