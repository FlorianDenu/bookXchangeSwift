//
//  UserManager.swift
//  bookXchange
//
//  Created by emily on 2017-06-10.
//  Copyright © 2017 florian inc. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class UserManager{
    
    class func users(_ completion: @escaping (_ responseData:[User]?, _ error: Bool?) -> ()){
        let url = URL(string: "http://floriand.ddns.net/task_manager/v1/users")
        WebServiceManager.sendRequest(nil, url: url!, requestMethod: .get, responseType: User.self) {
            (responseData:[User]?, error: Bool?) -> Void in
            print("this is the response from the back end \(responseData!)")
            completion(responseData, false)
        }
    }
    
    class func userBooks(_ completion: @escaping (_ responseData:[UserListOfBook]?, _ error: Bool?) -> ()){
        let url = URL(string: "http://floriand.ddns.net/task_manager/v1/userBooks")
        WebServiceManager.sendRequest(nil, url: url!, requestMethod: .get, responseType: UserListOfBook.self) {
            (responseData:[UserListOfBook]?, error: Bool?) -> Void in
            print("this is the response from the back end \(responseData!)")
            completion(responseData, false)
        }
    }
    
    class func userBookLink(predicate: String,_ completion:@escaping (_ responseData:[UserListOfBook]?, _ error: Bool?) -> ()) {
        print("inside the user book link")
        readData(UserListOfBook.self, predicate: predicate) {
            (response: Results<UserListOfBook>) in
            if response.count > 0 {
                completion(response.map { $0 }, false)
            } else {
                print("the number of user book link is less then 1")
                completion(nil, true)
            }
        }
    }
    
    //MARK: - Access to local informations
    
    class func localUser(_ completion:@escaping (_ responseData:[User]?, _ error: Bool?) -> ()) {
        readData(User.self, predicate: nil) {
            (response: Results<User>) in
            if response.count > 0 {
                completion(response.map { $0 }, false)
            } else {
                completion(nil, true)
            }
        }
    }
    
    class func localUserBooks(bookId: Int,_ completion:@escaping (_ responseData:[User]?, _ error: Bool?) -> ()) {
        print("isnde the local user book ")
        userBookLink(predicate: "bookId = \(bookId)") { (userListOfBook, error) in
            if error == false{
                print("no erorr in the manager")
                readData(User.self, predicate: "userId = \(userListOfBook?.first?.userId ?? 0)") {
                    (response: Results<User>) in
                    if response.count > 0 {
                        print("the number of user is less then 1")
                        completion(response.map { $0 }, false)
                    } else {
                        print("error while getting the user")
                        completion(nil, true)
                    }
                }
            }
        }
    }
}
