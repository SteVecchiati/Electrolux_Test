//
//  HomeView.swift
//  Test
//
//  Created by stefano vecchiati on 29/06/21.
//

import UIKit
import Stevia

protocol HomeViewDelegate: AnyObject {
    func presentAlert(alert: UIAlertController)
}

class HomeView: UIView {
    
    private let viewModel: HomeViewModel
    
    unowned let delegate: HomeViewDelegate
    
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let collectionViewCollumn = 2
    
    init(delegate: HomeViewDelegate) {
        
        viewModel = HomeViewModel(delegate: delegate)
        
        self.delegate = delegate
        
        super.init(frame: CGRect.zero)
    
        sv(
            collectionView
        )
       
        setConstraints()
        setCollectionView()
        setApperance()
        
        filterForTag(tag: QueryItemSearchPhoto(tags: "Electrolux"))

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func filterForTag(tag: QueryItemSearchPhoto) {
        
        viewModel.searchPhotos(tag: tag) { [weak self] in
            
            self?.collectionView.reloadData()
            
        } errorCallback: { [weak self] error, _ in
            
            debugPrint(error)
            
            let alert = UIAlertController(title: NSLocalizedString("error_alert_title", comment: "ErrorAlert"), message: NSLocalizedString("error_alert_description", comment: "ErrorAlert"), preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: NSLocalizedString("error_alert_retry", comment: "ErrorAlert"), style: .default, handler: { [weak self] _ in
                
                self?.filterForTag(tag: QueryItemSearchPhoto(tags: "Electrolux"))
                
            }))
            self?.delegate.presentAlert(alert: alert)
            
        }
        
    }
    
    
    func setConstraints() {
        layout(
            0,
            |-8 - collectionView - 8-|,
            0
        )
    }
    
    func setApperance() {
        backgroundColor = .lightGray
    }
    
    func setCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)

        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = .zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: String(describing: ImageCell.self))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let widthSize = collectionView.frame.width / CGFloat(collectionViewCollumn) - 8
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSize(width: widthSize, height: widthSize)
    }
    
}

extension HomeView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photosModel.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCell.self), for: indexPath) as! ImageCell
        cell.update(photo: viewModel.photosModel[indexPath.item], viewModel: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ImageCell
        cell?.isSelected = true
    }
}

