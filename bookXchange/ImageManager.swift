//
//  ListOfBookManager.swift
//  bookXchange
//
//  Created by emily on 2017-05-27.
//  Copyright © 2017 florian inc. All rights reserved.
//

import Foundation
import AlamofireImage
import RealmSwift

class ImageManager{
    
    class func image(url: URL, _ completion: @escaping (_ responseImage:Image?) -> ()){
        WebServiceManager.sendImageRequest(url: url) { (imageResponse) in
            completion(imageResponse)
        }
    }
    
    class func imageBook(_ completion: @escaping (_ responseData:[ImageBook]?, _ error: Bool?) -> ()){
        let (_, url) = ImageBookUrls.getImages.httpMethodeUrl()
        WebServiceManager.sendRequest(nil, url: url, requestMethod: .get, responseType: ImageBook.self) {
            (responseData:[ImageBook]?, error: Bool?) -> Void in
            print("this is the response from the back end \(responseData!)")
            completion(responseData, false)
        }
    }
    
    class func imageBooksLink(_ completion: @escaping (_ responseData:[ImageBookLink]?, _ error: Bool?) -> ()){
        let url = URL(string: "http://floriand.ddns.net/task_manager/v1/imagesBookLink")
        WebServiceManager.sendRequest(nil, url: url!, requestMethod: .get, responseType: ImageBookLink.self) {
            (responseData:[ImageBookLink]?, error: Bool?) -> Void in
            completion(responseData, false)
        }
    }
    
    //MARK: - Access to local informations
    
    class func localImagesBook(predicate: String,_ completion:@escaping (_ responseData:[ImageBook]?, _ error: Bool?) -> ()) {
        
        readData(ImageBook.self, predicate: predicate) {
            (response: Results<ImageBook>) in
            if response.count > 0 {
                completion(response.map { $0 }, false)
            } else {
                completion(nil, true)
            }
        }
    }
    
    class func deleteImageBook(model: ImageBook){
        print("model \(model)")
        delete( model)
    }
    

    

}
