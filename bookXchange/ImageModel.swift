//
//  Image.swift
//  bookXchange
//
//  Created by emily on 2017-06-10.
//  Copyright © 2017 florian inc. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift
import AlamofireImage

class ImageModel{
    
    var imageId: Int
    var bookId: Int
    var image: Image
    
    init(imageId: Int, bookId: Int, image: Image){
        self.imageId = imageId
        self.bookId = bookId
        self.image = image
    }
}
