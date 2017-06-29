//
//  Publisher.swift
//  bookXchange
//
//  Created by emily on 2017-06-03.
//  Copyright © 2017 florian inc. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Publisher: Object, Mappable{
    
    dynamic var publisherId: Int = 0
    dynamic var name: String = ""
    dynamic var datePublished: Date!
    
    required convenience init?(map: Map){
        self.init()
    }
    
    override class func primaryKey() -> String{
        return "publisherId"
    }
    
    func mapping(map: Map){
        publisherId <- map["imageId"]
        name <- map["name"]
        datePublished <- map["datePublished"]

    }
}
