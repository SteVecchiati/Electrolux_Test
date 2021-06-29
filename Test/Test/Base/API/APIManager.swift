//
//  APIManager.swift
//  Test
//
//  Created by stefano vecchiati on 29/06/21.
//

import Foundation
import PromiseKit

enum HTTPMethod: String, Decodable {
    case options
    case get
    case head
    case post
    case put
    case patch
    case delete
    case trace
    case connect
}

enum Services {
    case gateway

    static let defaultService = StandardService()
}

/// Types adopting the `URLRequestConvertible` protocol can be used to construct URL requests.
protocol URLRequestConvertible: CustomStringConvertible {
    var retryAttempts: Int { get }
    var service: Services { get }
    var queryItems: [URLQueryItem]? { get }

    func asURLRequest(_ urlStr: String?) -> URLRequest
}

protocol APIProxy {

    @discardableResult
    func makeCall<Model: Decodable, ErrorCodes: ErrorCodeInfo>(endpoint: URLRequestConvertible, modelType: Model.Type, errorType: ErrorCodes.Type) -> Promise<Model>
}

class APIManager {
    static let shared: APIManager = {
        APIManager()
    }()

    let session: URLSession

    let decoder: JSONDecoder
    let encoder: JSONEncoder

    var sessionID: String?

    init() {
        let sessionConfig: URLSessionConfiguration = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30
        sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        sessionConfig.urlCache = nil

        session = URLSession(configuration: sessionConfig)

        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)

                if let date = formatters.isoDateFormatterNoSecs.date(from: string.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)) {
                    return date
                }

            if let date = formatters.isoDateFormatterDateOnly.date(from: string) {
                return date
            }

            throw APIError.dateFailedToDecode
        }

        encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        encoder.dateEncodingStrategy = .iso8601
    }
}

extension Promise where T == (data: Data, response: URLResponse) {
    func validate<ErrorCodes: Decodable>(_ endpoint: URLRequestConvertible, errorType: ErrorCodes.Type, request: URLRequest) -> Promise<T> {
        return map {
            guard let response = $0.response as? HTTPURLResponse else { throw APIError.nilResponse(endpoint: endpoint) }

            switch response.statusCode {
            case 200 ..< 300:
                return $0

            case let code:
                throw APIError.errorFor(endpoint, with: code, data: $0.data, errorType: errorType, request: request)
            }
        }
    }
}
