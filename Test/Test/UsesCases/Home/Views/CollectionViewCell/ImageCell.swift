//
//  ImageCell.swift
//  Test
//
//  Created by stefano vecchiati on 29/06/21.
//

import UIKit
import Stevia

class ImageCell: UICollectionViewCell {
    
    let activityIndicator = UIActivityIndicatorView()
    
    override init(frame _: CGRect) {
        super.init(frame: .zero)
        
        sv(
            activityIndicator
        )
        
        setConstraints()
        
        backgroundColor = .white
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        activityIndicator.centerInContainer()
    }
    
    func update(string: Photo) {
        activityIndicator.color = .black
        activityIndicator.startAnimating()
    }
}
