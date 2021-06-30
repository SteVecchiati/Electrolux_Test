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
    
    private var searchBar: UISearchBar! {
        didSet {
            searchBar.placeholder = NSLocalizedString("placeholder_search_bar", comment: "Search")
            searchBar.delegate = self
        }
    }
    
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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        navBarSaveButtonEnable(state: false)
        
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        
    }
    
    @objc private func saveTapped() {
        homeView.savePhoto()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        navBarSaveButtonEnable(state: false)
        homeView.filterForTag(tag: QueryItemSearchPhoto(tags: searchBar.text))
    }
}

extension HomeViewController: HomeViewControllerDelegate {
    func presentAlert(alert: UIAlertController) {
        delegate.presentAlert(alert: alert)
    }
    
    func navBarSaveButtonEnable(state: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = state
        
        if !state {
            homeView.removeSelectedPhoto()
        }
    }
    
    
}
