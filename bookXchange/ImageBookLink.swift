//
//  ImageBookLink.swift
//  bookXchange
//
//  Created by emily on 2017-06-10.
//  Copyright © 2017 florian inc. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class ImageBookLink: Object, Mappable{
    
    dynamic var imageBookId: Int = 0
    dynamic var imageId: Int = 0
    dynamic var bookId: Int = 0
    
    required convenience init?(map: Map){
        self.init()
    }
    
    override class func primaryKey() -> String{
        return "imageBookId"
    }
    
    func mapping(map: Map){
        imageId <- map["imageBookId"]
        imageId <- map["imageId"]
        bookId <- map["bookId"]
    }
}
