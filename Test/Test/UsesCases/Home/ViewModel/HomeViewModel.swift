//
//  HomeViewModel.swift
//  Test
//
//  Created by stefano vecchiati on 29/06/21.
//

import Foundation

class HomeViewModel {
    private unowned var delegate: HomeViewDelegate
    
    var elements: [String] = ["1", "2", "3", "4", "5"]
    
    init(delegate: HomeViewDelegate) {
        self.delegate = delegate
    }
}
