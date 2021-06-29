//
//  AppDelegate.swift
//  Test
//
//  Created by stefano vecchiati on 29/06/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var rootCoordinator: Coordinator?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        rootCoordinator = AppCoordinator(delegate: self)

        rootCoordinator?.start(AppCoordinator.Router.home)
        
        return true
    }


}

extension AppDelegate: AppBaseDelegate {
    func keyWindowChanged(_ window: UIWindow) {
        self.window = window
    }
}

