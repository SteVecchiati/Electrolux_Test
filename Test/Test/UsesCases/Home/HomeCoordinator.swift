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
    func presentAlert(alert: UIAlertController) {
        homeViewController.present(alert, animated: true)
    }
    
    
    
}
