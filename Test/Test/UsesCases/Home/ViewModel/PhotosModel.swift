//
//  PhotoModel.swift
//  Test
//
//  Created by stefano vecchiati on 29/06/21.
//

import Foundation

struct PhotosModel: Decodable {
    
    let photos: Photos

}

struct Photos: Decodable {
    let photo: [Photo]
}

struct Photo: Decodable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    
}


struct QueryItemSearchPhoto {
    let api_key: String = "3b5800cf54e695681350d3f47ff1e76f"
    let method: String = "flickr.photos.search"
    var tags: String
    let format = "json"
    let nojsoncallback = "true"
    let extras =  ["media", "url_sq", "url_m"]
    let perPage = "20"
    let page = "1"
    
    init(tags: String?) {
        self.tags = tags ?? "Electrolux"
    }
    
    
  func toQueryItems() -> [URLQueryItem] {
    return [
        URLQueryItem(name: "api_key", value: api_key),
        URLQueryItem(name: "method", value: method),
        URLQueryItem(name: "tags", value: tags),
        URLQueryItem(name: "format", value: format),
        URLQueryItem(name: "nojsoncallback", value: nojsoncallback),
        URLQueryItem(name: "extras", value: extras[0]),
        URLQueryItem(name: "extras", value: extras[1]),
        URLQueryItem(name: "extras", value: extras[2]),
        URLQueryItem(name: "per_page", value: perPage),
        URLQueryItem(name: "page", value: page)
    ]
  }
}
