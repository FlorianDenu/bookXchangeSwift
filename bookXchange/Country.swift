//
//  Country.swift
//  bookXchange
//
//  Created by emily on 2017-06-03.
//  Copyright © 2017 florian inc. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Country: Object, Mappable{
    
    dynamic var countryId: Int = 0
    dynamic var countryDescription: String = ""

    
    required convenience init?(map: Map){
        self.init()
    }
    
    override class func primaryKey() -> String{
        return "countryId"
    }
    
    func mapping(map: Map){
        countryId <- map["countryId"]
        countryDescription <- map["countryDescption"]

        
    }
}
