//
//  Gender.swift
//  bookXchange
//
//  Created by emily on 2017-06-03.
//  Copyright © 2017 florian inc. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Gender: Object, Mappable{
    
    dynamic var genderId: Int = 0
    dynamic var genderDescription: String = ""
    
    required convenience init?(map: Map){
        self.init()
    }
    
    override class func primaryKey() -> String{
        return "genderId"
    }
    
    func mapping(map: Map){
        genderId <- map["genderId"]
        genderDescription <- map["genderDescription"]
    }
}
