//
//  ErrorModel.swift
//  Test
//
//  Created by stefano vecchiati on 29/06/21.
//

import Foundation

extension NSError {
    func isInternetUnreachableError() -> Bool {
        return self.domain == NSURLErrorDomain && self.code == NSURLErrorNotConnectedToInternet
    }

    func isDataTaskCancelledError() -> Bool {
        return self.domain == NSURLErrorDomain && self.code == NSURLErrorCancelled
    }
}

protocol ServerErrorValues: CustomStringConvertible {
    var statusInfo: Decodable { get }
    var codeString: String { get }
    var codeAsInt: Int { get }
}

struct ServerError<T: Decodable>: Decodable {
    let code: Int
    let status: T
    let message: String?
}

extension ServerError: ServerErrorValues {
    var description: String {
        return "Code: \(codeString) status: \(statusInfo)"
    }

    var statusInfo: Decodable {
        return status
    }

    var codeString: String {
        return String(code)
    }

    var codeAsInt: Int {
        return code
    }
}
