//
//  Address.swift
//  bookXchange
//
//  Created by emily on 2017-06-10.
//  Copyright © 2017 florian inc. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Address: Object, Mappable{
    
    dynamic var addressId: Int = 0
    dynamic var streetNumber: String = ""
    dynamic var streetName: String = ""
    dynamic var postalCode: String = ""
    dynamic var city: City!
    dynamic var country: Country!
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    
    required convenience init?(map: Map){
        self.init()
    }
    
    override class func primaryKey() -> String{
        return "addressId"
    }
    
    func mapping(map: Map){
        addressId <- map["addressId"]
        streetNumber <- map["streetNumber"]
        streetName <- map["streetName"]
        postalCode <- map["postalCode"]
        city <- map["city"]
        country <- map["country"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        
    }
}
