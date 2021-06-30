//
//  HomeViewController.swift
//  Test
//
//  Created by stefano vecchiati on 29/06/21.
//

import UIKit

protocol HomeViewControllerDelegate: HomeViewDelegate {
}

class HomeViewController: UIViewController {
    
    unowned let delegate: HomeViewControllerDelegate
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private var homeView: HomeView! {
        didSet {
            self.view = homeView
        }
    }
    
    override func loadView() {
        homeView = HomeView(delegate: delegate)
    }
    
    init(delegate: HomeViewControllerDelegate) {
        self.delegate = delegate

        super.init(nibName: nil, bundle: nil)
        
        
        title = NSLocalizedString("home_nav_bar_title", comment: "HomeViewController")
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

