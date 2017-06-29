//
//  BookManager.swift
//  bookXchange
//
//  Created by emily on 2017-06-10.
//  Copyright © 2017 florian inc. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class BookManager{
    
    class func books(_ completion: @escaping (_ responseData:[Book]?, _ error: Bool?) -> ()){
        let url = URL(string: "http://floriand.ddns.net/task_manager/v1/books")
        WebServiceManager.sendRequest(nil, url: url!, requestMethod: .get, responseType: Book.self) {
            (responseData:[Book]?, error: Bool?) -> Void in
            print("this is the response from the back end \(responseData!)")
            completion(responseData, false)
        }
    }
    
    class func addBook(parameters: [String: AnyObject],_ completion: @escaping (_ responseData:[Response]?, _ error: Bool?) -> ()){
        let url = URL(string: "http://floriand.ddns.net/task_manager/v1/book")
        WebServiceManager.sendRequest(parameters, url: url!, requestMethod: .post, responseType: Response.self) {
            (responseData:[Response]?, error: Bool?) -> Void in
            print("this is the response from the back end \(responseData!)")
            completion(responseData, false)
        }
    }
    
    //MARK: - Access to local informations
    
    class func localBook(_ completion:@escaping (_ responseData:[Book]?, _ error: Bool?) -> ()) {
        
        readData(Book.self, predicate: nil) {
            (response: Results<Book>) in
            if response.count > 0 {
                completion(response.map { $0 }, false)
            } else {
                completion(nil, true)
            }
        }
    }
    
    class func localBook(predicate: String,_ completion:@escaping (_ responseData:[Book]?, _ error: Bool?) -> ()) {
        
        readData(Book.self, predicate: predicate) {
            (response: Results<Book>) in
            if response.count > 0 {
                completion(response.map { $0 }, false)
            } else {
                completion(nil, true)
            }
        }
    }
}
