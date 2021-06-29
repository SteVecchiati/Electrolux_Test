//
//  HomeCoordinator.swift
//  Test
//
//  Created by stefano vecchiati on 29/06/21.
//

import UIKit

class HomeCoordinator: Coordinator {
    
    unowned let delegate: AppCoordinatorDelegate
    
    private lazy var homeViewController: HomeViewController! = {
        return HomeViewController(delegate: self)
    }()
    
    init(delegate: AppCoordinatorDelegate) {
        self.delegate = delegate
        
    }
    
    func start(_ router: CoordinatorRouter?) -> UIViewController? {
        
        return homeViewController
    }
    
    
}

extension HomeCoordinator: HomeViewControllerDelegate {
    
    
}
