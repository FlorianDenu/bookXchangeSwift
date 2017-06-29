//
//  User.swift
//  bookXchange
//
//  Created by emily on 2017-06-10.
//  Copyright © 2017 florian inc. All rights reserved.
//

import Foundation

import Foundation
import ObjectMapper
import RealmSwift

class User: Object, Mappable{
    
    dynamic var userId: Int = 0
    dynamic var userName: String = ""
    dynamic var password: String = ""
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var email: String = ""
    dynamic var address: Address!
    dynamic var apiKey: String = ""
    dynamic var profilePicture: String = ""
    dynamic var points: Int = 0
    
    
    
    required convenience init?(map: Map){
        self.init()
    }
    
    override class func primaryKey() -> String{
        return "userId"
    }
    
    func mapping(map: Map){
        userId <- map["userId"]
        userName <- map["userName"]
        password <- map["password"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        email <- map["email"]
        address <- map["address"]
        apiKey <- map["apiKey"]
        profilePicture <- map["image"]
        points <- map["points"]
    }
}
