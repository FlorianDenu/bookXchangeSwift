//
//  ImageBook.swift
//  bookXchange
//
//  Created by emily on 2017-05-27.
//  Copyright © 2017 florian inc. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class ImageBook: Object, Mappable{
    
    dynamic var imageId: Int = 0
    dynamic var bookId: Int = 0
    dynamic var primary: Bool = false
    dynamic var value: String = ""
    
    required convenience init?(map: Map){
        self.init()
    }
    
    override class func primaryKey() -> String{
        return "imageId"
    }
    
    func mapping(map: Map){
        imageId <- map["imageId"]
        bookId <- map["bookId"]
        primary <- map["primary"]
        value <- map["image"]
    }
}
