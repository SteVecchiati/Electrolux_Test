//
//  ImageCell.swift
//  Test
//
//  Created by stefano vecchiati on 29/06/21.
//

import UIKit
import Stevia

class ImageCell: UICollectionViewCell {
    
    private let label = UILabel()
    
    override init(frame _: CGRect) {
        super.init(frame: .zero)
        
        sv(
            label
        )
        
        setConstraints()
        
        backgroundColor = .white
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        label.centerInContainer()
    }
    
    func update(string: String) {
        label.text = string
    }
}
