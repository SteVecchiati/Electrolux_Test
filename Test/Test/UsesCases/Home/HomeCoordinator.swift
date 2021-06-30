//
//  HomeCoordinator.swift
//  Test
//
//  Created by stefano vecchiati on 29/06/21.
//

import UIKit

class HomeCoordinator: Coordinator {
    
    unowned let delegate: AppCoordinatorDelegate
    
    private var navController: UINavigationController?
    
    private lazy var homeViewController: HomeViewController! = {
        return HomeViewController(delegate: self)
    }()
    
    init(delegate: AppCoordinatorDelegate) {
        self.delegate = delegate
        
    }
    
    func start(_ router: CoordinatorRouter?) -> UIViewController? {
        
        if let navController = navController {
            navController.pushViewController(homeViewController, animated: true)
        } else {
            navController = UINavigationController(root: homeViewController)
        }
        
        return navController
    }
    
    
}

extension HomeCoordinator: HomeViewControllerDelegate {
    func navBarSaveButtonEnable(state: Bool) {
        fatalError("navBarSaveButtonEnable into HomeCoordinator should never work, if we land here maybe something is wrong")
    }
    
    
    func presentAlert(alert: UIAlertController) {
        homeViewController.present(alert, animated: true)
    }
    
    
    
}
