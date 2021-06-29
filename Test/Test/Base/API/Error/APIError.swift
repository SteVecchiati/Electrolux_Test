//
//  APIError.swift
//  Test
//
//  Created by stefano vecchiati on 29/06/21.
//

import UIKit

protocol ErrorCodeInfo: Decodable, CustomStringConvertible, ErrorInfo {
}

protocol ErrorInfo {
    var description: String { get }
}

enum APIError: Error {
    // system API errors
    case internetNotReachable
    case dataTaskCancelled
    case genericError(message: String, endpoint: URLRequestConvertible?) // generic URLSessionDataTask error

    // server errors
    case fiveHundredError(statusCode: Int, endpoint: URLRequestConvertible)
    case maintenanceMode(error: ServerErrorValues)
    case genericServerError(endpoint: URLRequestConvertible, payload: String?)
    case server(error: ServerErrorValues, endpoint: URLRequestConvertible)
    case notFound(endpoint: URLRequestConvertible)
    case nilResponse(endpoint: URLRequestConvertible)

    // decoding errors
    case decodingFailed(endpoint: URLRequestConvertible, payload: String)
    case dateFailedToDecode

    var serverError: ServerErrorValues? {
        switch self {
        case let .server(error: serverError, endpoint: _):
            return serverError

        default:
            return nil
        }
    }

    static func errorFor<ErrorCodes: Decodable>(_ endpoint: URLRequestConvertible, with code: Int, data: Data?, errorType _: ErrorCodes.Type, request: URLRequest?) -> APIError {
        var apiError: APIError?

        switch code {
        case 500 ... 502:
            apiError = APIError.fiveHundredError(statusCode: code, endpoint: endpoint)

        case 503 ... 599:
            apiError = APIError.fiveHundredError(statusCode: code, endpoint: endpoint)

        default:
            break
        }

        guard let data = data else {
            return .genericServerError(endpoint: endpoint, payload: nil)
        }

        if let apiError = apiError {
            return apiError
        }

        if let apiError = apiError {
            return apiError
        }

        switch code {
        case 404:
            apiError = APIError.notFound(endpoint: endpoint)
            return apiError!

        default:
            apiError = APIError.genericServerError(endpoint: endpoint,
                                                   payload: data.jsonFormattedString())
            return apiError!
        }
    }

    static func errorFor(_ error: Error, endpoint: URLRequestConvertible?) -> APIError {
        if (error as NSError).isInternetUnreachableError() {
            return .internetNotReachable
        } else if (error as NSError).isDataTaskCancelledError() {
            return .dataTaskCancelled
        }
        return .genericError(message: error.localizedDescription, endpoint: endpoint)
    }
}

extension APIError: CustomStringConvertible, ErrorInfo {
    
    var description: String {
        switch self {
        case let .genericError(message, endpoint):

            return "Generic Error \(message), endpoint \(endpoint?.description ?? "")"
        case let .server(error: error, _):

            return error.description

        case .notFound:

            return "404 - object not found"
        case let .fiveHundredError(code, endpointID):

            return String(code) + " level error, from \(endpointID)"
        case let .genericServerError(endpointID, payload):
            guard let payload = payload else { return "Generic server error for endpoint: \(endpointID)" }
            return "Generic server error for endpoint: \(endpointID), payload: \(payload)"
        case .maintenanceMode:

            return "maintenanceMode"
        case .dataTaskCancelled:

            return "dataTaskCancelled"

        case let .decodingFailed(endpoint, payload):

            return "Decoding failed for endpoint: \(endpoint.description), payload: \(payload)"
        default:
            return ""
        }
    }

}

extension APIError {
    func logError(code: Int, endpoint: URLRequestConvertible?, request: URLRequest?, errorCodeInfo: ErrorCodeInfo? = nil, data: Data? = nil) -> APIError {
        debugPrint( "😭 " + self.description)

        return self
    }
}
