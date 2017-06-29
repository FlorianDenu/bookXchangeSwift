//
//  Language.swift
//  bookXchange
//
//  Created by emily on 2017-06-03.
//  Copyright © 2017 florian inc. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Language: Object, Mappable{
    
    dynamic var languageId: Int = 0
    dynamic var languageDescription: String = ""
    
    required convenience init?(map: Map){
        self.init()
    }
    
    override class func primaryKey() -> String{
        return "languageId"
    }
    
    func mapping(map: Map){
        languageId <- map["languageId"]
        languageDescription <- map["languageDescription"]
    }
}
