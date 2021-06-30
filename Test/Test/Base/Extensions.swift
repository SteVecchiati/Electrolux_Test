//
//  Extensions.swift
//  Test
//
//  Created by stefano vecchiati on 29/06/21.
//

import UIKit

extension UINavigationController {

    convenience init(root: UIViewController? = nil) {
        if let root = root {
            self.init(rootViewController: root)
        } else {
            self.init()
        }

        setStyle()
    }

    private func setStyle() {
        
        let textColor: UIColor = .black
        
        navigationBar.tintColor = .orange
        navigationBar.barTintColor = .white

        navigationBar.shadowImage = UIImage()

        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: textColor
        ]
        navigationBar.isTranslucent = false

    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }

}

// Foundation
extension Data {
    func jsonFormattedString() -> String {
        do {
            let jsonObject: Any = try JSONSerialization.jsonObject(with: self, options: [])

            do {
                let prettyJsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])

                if let prettyPrintedString = String(data: prettyJsonData, encoding: String.Encoding.utf8) {
                    return prettyPrintedString
                }
            } catch {}
        } catch {}

        return ""
    }

    var cacheKey: String {
        return "\(self.hashValue)-\(self.count)"
    }
}

extension String: ErrorCodeInfo {}
