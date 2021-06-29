//
//  Constant.swift
//  Test
//
//  Created by stefano vecchiati on 29/06/21.
//

import UIKit

let formatters = Formatters()

class Formatters {

    lazy var isoDateFormatterNoSecs: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()

        formatter.formatOptions = [.withInternetDateTime]

        return formatter
    }()

    lazy var isoDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()

        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        return formatter
    }()

    lazy var isoDateFormatterDateOnly: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()

        formatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]

        return formatter
    }()
}
