//
//  BingImagesRequest.swift
//  CombineTest
//
//  Created by 罗树新 on 2021/1/20.
//

import Foundation
import Tina

extension BingImagesRequest {
    func request(_ completion: @escaping ([BingImages.BingImage]?) -> Void) {
        let request = BingImagesRequest()
        request.get { (response) in
            if let result = response.result, let bingImage = BingImages.object(from: result) {
                completion(bingImage.images)
                return
            }
            completion(nil)
            
        }
    }
}

struct BingImagesRequest: Getable, BingSession {
    var path: String? {
        return "HPImageArchive.aspx"
    }
    
    var format = "js"
    var idx = 0
    var n = 10
}

struct BingImages: Responseable {
    
    struct BingImage: Responseable {
        var urlBase: String
        var quiz: String
        var url: String
        var copyRight: String
    
        private enum CodingKeys: String, CodingKey {
            case urlBase = "urlbase"
            case quiz
            case url
            case copyRight = "copyright"
        }
        
        func getImageUrl() -> String {
            return "https://www.bing.com\(url)"
        }
        
        
    }
    var images:[BingImage]
}
