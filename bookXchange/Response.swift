//
//  Response.swift
//  bookXchange
//
//  Created by emily on 2017-06-12.
//  Copyright © 2017 florian inc. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Response: Object, Mappable{
    
    dynamic var book_id: Int = 0
    dynamic var error: Bool = false
    dynamic var message: String = ""
    
    required convenience init?(map: Map){
        self.init()
    }
    
    override class func primaryKey() -> String{
        return "book_id"
    }
    
    func mapping(map: Map){
        book_id <- map["book_id"]
        error <- map["error"]
        message <- map["message"]
    }
}
