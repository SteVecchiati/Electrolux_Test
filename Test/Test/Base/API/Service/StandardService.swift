//
//  StandardService.swift
//  Test
//
//  Created by stefano vecchiati on 29/06/21.
//

import Foundation
import PromiseKit

class StandardService {
    
    private func makeRawCall<ErrorCodes: ErrorCodeInfo>(urlRequest: URLRequest, endpoint: URLRequestConvertible,
                                                        errorType: ErrorCodes.Type) -> Promise<(data: Data, response: URLResponse)> {
        let urlRequest = endpoint.asURLRequest(nil)

        return attempt(maximumRetryCount: endpoint.retryAttempts) {
            APIManager.shared.session.dataTask(.promise, with: urlRequest)
                .recover { error -> Promise<(data: Data, response: URLResponse)> in
                    throw APIError.errorFor(error, endpoint: endpoint)
                }
                .validate(endpoint, errorType: errorType, request: urlRequest)
        }
    }
    
    func makeCall<ErrorCodes: ErrorCodeInfo>(endpoint: URLRequestConvertible, errorType: ErrorCodes.Type) -> Promise<(HTTPURLResponse, Data)> {
        let urlRequest = endpoint.asURLRequest(nil)
        return attempt(maximumRetryCount: endpoint.retryAttempts) {
            APIManager.shared.session.dataTask(.promise, with: urlRequest)
                .recover { error -> Promise<(data: Data, response: URLResponse)> in
                    throw APIError.errorFor(error, endpoint: endpoint)
                }
                .validate(endpoint, errorType: errorType, request: urlRequest)
        }.map {
            ($0.response as! HTTPURLResponse, $0.data)
        }
    }
    
    func makeCall<Model: Decodable, ErrorCodes: ErrorCodeInfo>(endpoint: URLRequestConvertible,
                                                               modelType _: Model.Type,
                                                               errorType: ErrorCodes.Type) -> Promise<Model> {
        let urlRequest = endpoint.asURLRequest(nil)
        return makeRawCall(urlRequest: urlRequest, endpoint: endpoint, errorType: errorType).map {
            
            debugPrint("📟 Payload Received 📟")
            debugPrint("Url: \($0.response.url?.absoluteString ?? "") data: \($0.data.jsonFormattedString())")

            do {
                return try APIManager.shared.decoder.decode(Model.self, from: $0.data)
            } catch {
                throw APIError.decodingFailed(endpoint: endpoint, payload: $0.data.jsonFormattedString())
                    .logError(code: 300, endpoint: endpoint, request: urlRequest, data: $0.data)
            }
        }
    }
    
    
    private func attempt<T>(maximumRetryCount: Int, delayBeforeRetry: DispatchTimeInterval = .milliseconds(200), _ body: @escaping () -> Promise<T>) -> Promise<T> {
        var attempts = 0
        func attempt() -> Promise<T> {
            attempts += 1
            return body().recover { error -> Promise<T> in
                guard attempts < maximumRetryCount else { throw error }
                guard let apiError = error as? APIError, self.shouldRetryOn(apiError) else { throw error }
                return after(delayBeforeRetry).then(on: nil, attempt)
            }
        }
        return attempt()
    }

    private func shouldRetryOn(_ error: APIError) -> Bool {
        switch error {
        case let .server(error: serverError, _):
            switch serverError.codeAsInt {
            case 500 ..< 600:
                return true

            default:
                return false
            }

        case .fiveHundredError:
            return true

        default:
            return false
        }
    }
    
}
