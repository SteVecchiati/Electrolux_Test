//
//  HomeView.swift
//  Test
//
//  Created by stefano vecchiati on 29/06/21.
//

import UIKit
import Stevia

protocol HomeViewDelegate: AnyObject {
}

class HomeView: UIView {
    
    private let viewModel: HomeViewModel
    
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let collectionViewCollumn = 2
    
    init(delegate: HomeViewDelegate) {
        
        viewModel = HomeViewModel(delegate: delegate)
        
        super.init(frame: CGRect.zero)
    
        sv(
            collectionView
        )
       
        setConstraints()
        setCollectionView()
        setApperance()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: String(describing: ImageCell.self))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let widthSize = collectionView.frame.width / CGFloat(collectionViewCollumn) - 8
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSize(width: widthSize, height: widthSize)
    }
    
}

extension HomeView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.elements.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCell.self), for: indexPath) as! ImageCell
        cell.update(string: viewModel.elements[indexPath.item])
        return cell
    }
}

