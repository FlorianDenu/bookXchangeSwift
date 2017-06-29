//
//  UserListOfBook.swift
//  bookXchange
//
//  Created by emily on 2017-06-10.
//  Copyright © 2017 florian inc. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class UserListOfBook: Object, Mappable{
    
    dynamic var listOfBookId: Int = 0
    dynamic var userId: Int = 0
    dynamic var bookId: Int = 0
    dynamic var dateAdded: Date!
    
    required convenience init?(map: Map){
        self.init()
    }
    
    override class func primaryKey() -> String{
        return "listOfBookId"
    }
    
    func mapping(map: Map){
        listOfBookId <- map["listOfBookId"]
        userId <- map["userId"]
        bookId <- map["bookId"]
        dateAdded <- (map["dateAdded"], DateTransform())
    }
}
