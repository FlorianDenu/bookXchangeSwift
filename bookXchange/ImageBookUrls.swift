//
//  Urls.swift
//  bookXchange
//
//  Created by emily on 2017-06-03.
//  Copyright © 2017 florian inc. All rights reserved.
//

import Foundation

enum ImageBookUrls{
    case getImages
    case getMissingImages
    case postImage
    case postImages
    case delete
    case update
}

extension ImageBookUrls {
    func httpMethodeUrl() -> (method: String,url: URL) {
        let baseUrl = "http://floriand.ddns.net/task_manager/v1/"
        switch self {
        case .getImages:
            return ("GET", URL(string: "\(baseUrl)images")!)
        case .getMissingImages:
            return ("GET", URL(string: "\(baseUrl)missingImages")!)
        case .postImage:
            return ("POST", URL(string: "\(baseUrl)image")!)
        case .postImages:
            return ("POST", URL(string: "\(baseUrl)images")!)
        case .delete:
            return ("DELETE", URL(string: "\(baseUrl)image")!)
        case .update:
            return ("PUT", URL(string: "\(baseUrl)image")!)
        }
    }
}
