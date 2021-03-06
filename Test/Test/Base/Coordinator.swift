//
//  Coordinator.swift
//  Test
//
//  Created by stefano vecchiati on 29/06/21.
//

import UIKit

protocol CoordinatorRouter {}

protocol Coordinator {
    @discardableResult
    func start(_ router: CoordinatorRouter?) -> UIViewController?
}
