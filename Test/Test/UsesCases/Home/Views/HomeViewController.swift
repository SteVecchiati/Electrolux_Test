//
//  HomeViewController.swift
//  Test
//
//  Created by stefano vecchiati on 29/06/21.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
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
        homeView = HomeView()
    }
    
    init(delegate: HomeViewControllerDelegate) {
        self.delegate = delegate

        super.init(nibName: nil, bundle: nil)
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

