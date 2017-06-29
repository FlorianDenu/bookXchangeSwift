//
//  Book.swift
//  bookXchange
//
//  Created by emily on 2017-06-03.
//  Copyright © 2017 florian inc. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Book: Object, Mappable{
    
    dynamic var bookId: Int = 0
    dynamic var title: String = ""
    dynamic var desc: String = ""
    dynamic var available: Bool = false
    dynamic var author: Author!
    dynamic var isbn: Int = 0
    dynamic var series: String = ""
    dynamic var publisher: Publisher!
    dynamic var datePublished: Date!
    dynamic var page: Int = 0
    dynamic var gender: Gender!
    dynamic var language: Language!
    dynamic var dateAdded: Date!
    
    required convenience init?(map: Map){
        self.init()
    }
    
    override class func primaryKey() -> String{
        return "bookId"
    }
    
    func mapping(map: Map){
        print("inside the mapping function this is the map \(map)")
        bookId <- map["bookId"]
        title <- map["title"]
        desc <- map["description"]
        available <- map["available"]
        author <- map["author"]
        isbn <- map["isbn"]
        series <- map["series"]
        publisher <- map["publisher"]
        datePublished <- map["datePublished"]
        page <- map["page"]
        gender <- map["gender"]
        language <- map["language"]
        dateAdded <- map["dateAdded"]
    }
}
