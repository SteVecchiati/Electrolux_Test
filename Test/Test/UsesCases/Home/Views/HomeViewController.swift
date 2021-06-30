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
        homeView = HomeView(delegate: self)
    }
    
    init(delegate: HomeViewControllerDelegate) {
        self.delegate = delegate

        super.init(nibName: nil, bundle: nil)
        
        
        title = NSLocalizedString("home_nav_bar_title", comment: "HomeViewController")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc private func saveTapped() {
        homeView.savePhoto()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeViewController: HomeViewControllerDelegate {
    func presentAlert(alert: UIAlertController) {
        delegate.presentAlert(alert: alert)
    }
    
    func navBarSaveButtonEnable(state: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = state
    }
    
    
}
