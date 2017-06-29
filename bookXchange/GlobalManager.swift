//
//  GlobalManager.swift
//  bookXchange
//
//  Created by emily on 2017-06-11.
//  Copyright © 2017 florian inc. All rights reserved.
//


import Foundation
import ObjectMapper
import RealmSwift

class GlobalManager{
    
    class func languages(_ completion: @escaping (_ responseData:[Language]?, _ error: Bool?) -> ()){
        let url = URL(string: "http://floriand.ddns.net/task_manager/v1/languages")
        WebServiceManager.sendRequest(nil, url: url!, requestMethod: .get, responseType: Language.self) {
            (responseData:[Language]?, error: Bool?) -> Void in
            print("this is the response from the back end \(responseData!)")
            completion(responseData, false)
        }
    }
    
    class func genders(_ completion: @escaping (_ responseData:[Gender]?, _ error: Bool?) -> ()){
        let url = URL(string: "http://floriand.ddns.net/task_manager/v1/genders")
        WebServiceManager.sendRequest(nil, url: url!, requestMethod: .get, responseType: Gender.self) {
            (responseData:[Gender]?, error: Bool?) -> Void in
            print("this is the response from the back end \(responseData!)")
            completion(responseData, false)
        }
    }
    
    //MARK: - Access to local informations
    
    class func localLanguages(_ completion:@escaping (_ responseData:[Language]?, _ error: Bool?) -> ()) {
        readData(Language.self, predicate: nil) {
            (response: Results<Language>) in
            if response.count > 0 {
                completion(response.map { $0 }, false)
            } else {
                completion(nil, true)
            }
        }
    }
    
    class func localGenders(_ completion:@escaping (_ responseData:[Gender]?, _ error: Bool?) -> ()) {
        readData(Gender.self, predicate: nil) {
            (response: Results<Gender>) in
            if response.count > 0 {
                completion(response.map { $0 }, false)
            } else {
                completion(nil, true)
            }
        }
    }
    
    class func deleteAlldb(){
        print("delete all")
        deleteAll()
    }
}
