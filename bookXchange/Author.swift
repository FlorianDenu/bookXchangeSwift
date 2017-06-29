//
//  Author.swift
//  bookXchange
//
//  Created by emily on 2017-06-03.
//  Copyright © 2017 florian inc. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Author: Object, Mappable{
    
    dynamic var authorId: Int = 0
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var dateOfBirth: Date!
    dynamic var dateOfDeath: Date!
    dynamic var country: Country!
    
    required convenience init?(map: Map){
        self.init()
    }
    
    override class func primaryKey() -> String{
        return "authorId"
    }
    
    func mapping(map: Map){
        authorId <- map["authorId"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        dateOfBirth <- map["dateOfBirth"]
        dateOfDeath <- map["dateOfDeath"]
        country <- map["country"]

    }
}
