//
//  WebServiceManager
//  bookXchange
//
//  Created by emily on 2017-05-27.
//  Copyright © 2017 florian inc. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireImage
import AlamofireObjectMapper

class WebServiceManager{
    

    class func sendImageRequest(url: URL, completion: @escaping (Image) -> Void){
        Alamofire.request(url).responseImage { response in
            debugPrint(response)
            debugPrint(response.result)
            
            if let image = response.result.value {
                DispatchQueue.main.async(execute: {
                    completion(image)
                })
            }
        }
    }
    
    class func sendGoogleApiRequest(url: URL, completion: @escaping([String: Any]) -> Void){
        Alamofire.request(url).validate().responseJSON { response in
            OperationQueue.main.addOperation {
                completion(response.result.value as! [String : Any])
            }
        }
    }

    class func sendRequest<T: Mappable>(_ requestParameters: [String: AnyObject]?, url: URL, requestMethod: Alamofire.HTTPMethod, responseType: T.Type, completion: @escaping (_ responseData: [T]?, _ error: Bool?) -> Void) {
        
        // To execute in a different thread than main thread:
        let queue = DispatchQueue(label: "manager-response-queue", attributes: DispatchQueue.Attributes.concurrent)
        // Alamofire web service call:
        Alamofire.request(url, method: requestMethod, parameters: requestParameters)
            .responseArray(queue: queue, completionHandler: {
                (response: DataResponse<[T]>) in
//                print("this is the response \(response)")
//                print(response)
//                print("Response form the Web service manager")
//                print(response.request!)  // original URL request
//                print(response.response!) // URL response
//                print(response.result)   // result of response serialization
//                print("this is the result value \(response.result.value)")
                if let mappedModel = response.result.value {
                    
                    DispatchQueue.main.async(execute: {
                        saveData(mappedModel)
                        //print("Mapped Model: \(mappedModel)")
                        completion(mappedModel, nil)
                    })
                }
            })
    }

}
