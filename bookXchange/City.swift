//
//  City.swift
//  bookXchange
//
//  Created by emily on 2017-06-10.
//  Copyright © 2017 florian inc. All rights reserved.
//
import Foundation
import ObjectMapper
import RealmSwift

class City: Object, Mappable{
    
    dynamic var cityId: Int = 0
    dynamic var cityName: String = ""
    
    required convenience init?(map: Map){
        self.init()
    }
    
    override class func primaryKey() -> String{
        return "cityId"
    }
    
    func mapping(map: Map){
        cityId <- map["cityId"]
        cityName <- map["cityName"]
    }
}
