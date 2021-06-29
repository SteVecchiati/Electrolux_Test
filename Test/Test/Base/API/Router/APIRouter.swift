//
//  APIRouter.swift
//  Test
//
//  Created by stefano vecchiati on 29/06/21.
//

import Foundation

enum APIRouter: URLRequestConvertible {
        static let baseURLString = "https://api.flickr.com/"

    case searchPhotos(String)

    // TODO: use auto string value
    var description: String {
        switch self {
            
        case .searchPhotos:
            return "searchPhotos"
        }
    }
    
    var retryAttempts: Int {
        switch self {
        case .searchPhotos:
            return 3
        }
    }

    var service: Services {
        return .gateway
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        default:
            return nil
            }
    }
    
    // if urlStr is passed in, this is used to create the URLRequest bypassing the default creation
    func asURLRequest(_ urlStr: String?) -> URLRequest {
        let genericReq = URLRequest(url: URL(fileURLWithPath: ""))
        guard var urlComponents = URLComponents(string: APIRouter.baseURLString.appending(path)) else {
            return genericReq
        }
        urlComponents.queryItems = queryItems

        var urlMaybe: URL?
        if let urlStr = urlStr, let url = URL(string: urlStr) {
            urlMaybe = url
        } else if let url = urlComponents.url {
            urlMaybe = url
        }

        guard let url = urlMaybe else { return genericReq }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let sessionID = APIManager.shared.sessionID {
            request.setValue("Bearer " + sessionID, forHTTPHeaderField: "Authorization")
        }

        request.httpBody = payload

        return request
    }

    private var path: String {
        switch self {
        case let .searchPhotos(tag):
            return "services/rest?api_key=3b5800cf54e695681350d3f47ff1e76f&method=flickr.photos.search&tags=\(tag)&format=json&nojsoncallback=true&extras=media&extras=url_sq&extras=url_m&per_page=20&page=1"
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .searchPhotos:
            return .get
        }
    }
    
    private var payload: Data? {
        switch self {
        default:
            return nil
        }
    }

}
