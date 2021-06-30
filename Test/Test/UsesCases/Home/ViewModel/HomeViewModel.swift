//
//  HomeViewModel.swift
//  Test
//
//  Created by stefano vecchiati on 29/06/21.
//

import Foundation

class HomeViewModel {
    private unowned var delegate: HomeViewDelegate
    
    private var service: StandardService = StandardService()
    
    var photosModel: [Photo] = []
    
    init(delegate: HomeViewDelegate) {
        self.delegate = delegate
    }
}

// Let's make the call here, for keeping separate the logic and have things with more order
extension HomeViewModel {
    
    func searchPhotos(tag: QueryItemSearchPhoto, callback: (() -> Void)?, errorCallback: ((Error, URLRequestConvertible) -> Void)?) {
        let endpoint = APIRouter.searchPhotos(tag)
        service.makeCall(endpoint: endpoint,
                          modelType: PhotosModel.self,
                          errorType: String.self)
            .done { [weak self] model in
                self?.photosModel = model.photos.photo
                callback?()
            }
            .catch { error in
                errorCallback?(error, endpoint)
            }
    }
    
    
}
