//
//  ImageCell.swift
//  Test
//
//  Created by stefano vecchiati on 29/06/21.
//

import UIKit
import Stevia

class ImageCell: UICollectionViewCell {
    
    private let activityIndicator = UIActivityIndicatorView()
    private let imageView = UIImageView()
    
    var image: UIImage?
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .orange : .white
        }
    }
    
    override init(frame _: CGRect) {
        super.init(frame: .zero)
        
        sv(
            activityIndicator,
            imageView
        )
        
        setConstraints()
        
        backgroundColor = .white
        activityIndicator.hidesWhenStopped = true
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        activityIndicator.centerInContainer()
        
        imageView.fillContainer(8)
    }
    
    func update(photo: Photo, viewModel: HomeViewModel) {
        downloadImage(photo: photo, viewModel: viewModel)
    }
    
    private func downloadImage(photo: Photo, viewModel: HomeViewModel) {
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        imageView.image = nil
        
        viewModel.downloadPhoto(serverID: photo.server, id: photo.id, secret: photo.secret) { [weak self] data in
            self?.activityIndicator.stopAnimating()
            self?.image = UIImage(data: data)
            self?.imageView.image = self?.image
        } errorCallback: { error, _ in
            //TODO: Implement an error state
            debugPrint(error)
        }
    }
}
