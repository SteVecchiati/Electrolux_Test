//
//  HomeViewModel.swift
//  Test
//
//  Created by stefano vecchiati on 29/06/21.
//

import UIKit

class HomeViewModel: NSObject {
    private unowned var delegate: HomeViewDelegate
    
    private var service: StandardService = StandardService()
    
    var photosModel: [Photo] = []
    
    var selectedPhoto: UIImage?
    
    init(delegate: HomeViewDelegate) {
        self.delegate = delegate
    }
    
    
    
    
    
    //MARK: - Save Photo to Library
    func saveToLibrary() {
        guard selectedPhoto != nil else {
            fatalError("saveToLibrary function called when I don't have a selected photo")
            
        }
        UIImageWriteToSavedPhotosAlbum(selectedPhoto!, self, #selector(processedImage), nil)
    }
        
     
    @objc private func processedImage(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        
        var alert: UIAlertController
            if let _ = error {
                // we got back an error :(
                alert = UIAlertController(title: NSLocalizedString("error_alert_title", comment: "ErrorAlert"), message: NSLocalizedString("error_alert_description", comment: "ErrorAlert"), preferredStyle: .alert)
                
            } else {
           
                alert = UIAlertController(title: NSLocalizedString("photo_saved_title", comment: "SavedPhoto"), message: NSLocalizedString("photo_saved_message", comment: "SavedPhoto"), preferredStyle: .alert)
            }
        
            alert.addAction(UIAlertAction(title: NSLocalizedString("alert_okay", comment: "Alert"), style: .default))
            delegate.presentAlert(alert: alert)
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
    
    func downloadPhoto(serverID: String, id: String, secret: String, callback: ((Data) -> Void)?, errorCallback: ((Error, URLRequestConvertible) -> Void)?) {
        let endpoint = APIRouter.downloadPhoto(serverID, id, secret)
        DispatchQueue.global(qos: .utility).async {
            self.service.makeCall(endpoint: endpoint,
                          errorType: String.self)
            .done(on: DispatchQueue.main) { response in
                callback?(response.1)
            }
            .catch(on: DispatchQueue.main) { error in
                errorCallback?(error, endpoint)
            }
        }
    }
    
    
    
}
