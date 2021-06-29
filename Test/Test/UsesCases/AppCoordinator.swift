//
//  AppCoordinator.swift
//  Test
//
//  Created by stefano vecchiati on 29/06/21.
//

import UIKit

protocol AppBaseDelegate: AnyObject {
    func keyWindowChanged(_ window: UIWindow)
}

protocol AppCoordinatorDelegate: AppBaseDelegate {
}

class AppCoordinator: NSObject, Coordinator {
    enum Router: CoordinatorRouter {
        case home
    }

    private weak var delegate: AppBaseDelegate?
    private var window = UIWindow(frame: UIScreen.main.bounds)
    
    private var rootCoordinator: Coordinator?
    
    private var router: Router?
    
    
    init(delegate: AppBaseDelegate) {
        self.delegate = delegate

        super.init()
        
    }
    
    @discardableResult
    func start(_ router: CoordinatorRouter?) -> UIViewController? {
        
        self.router = router as? Router
        
        switch self.router {
        case .home:
            // HomeCoordinator doesn't exist yet, need to be created
//            rootCoordinator = HomeCoordinator(delegate: self)
            
            window.rootViewController = rootCoordinator?.start(nil)
            window.makeKeyAndVisible()
        case .none:
            //force a crash in the app, better make the app crash that do nothing or have an unexpactable state. In this way is easier to find bugs and solve them. But of course this is just an opinion, totally fine with the oposite, could be a good point of discussion how do things :).
            fatalError("oh no, you need to have a router for this coordinator")
        }

        defer {
            keyWindowChanged(window)
        }

        return window.rootViewController
    }
    
    private func revealNewWindow(with rootViewController: UIViewController?,
                                 withSnapshot snapShot: UIView) {
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        let oldRootViewController = window.rootViewController

        rootViewController?.view.addSubview(snapShot)
        newWindow.rootViewController = rootViewController
        newWindow.makeKeyAndVisible()

        let internalCompleted = { [weak self] in
            // dismiss any presented view controller to remove the retian cycle with the old window
            oldRootViewController?.presentedViewController?.dismiss(animated: false, completion: nil)
            self?.window = newWindow
            self?.delegate?.keyWindowChanged(newWindow)
        }

        UIView.animate(withDuration: 0.2, animations: {
            snapShot.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: snapShot.frame.width, height: snapShot.frame.height)
        }) { done in
            if done {
                snapShot.removeFromSuperview()
                internalCompleted()
            }
        }
    }
    
}

extension AppCoordinator: AppCoordinatorDelegate {
    
    func keyWindowChanged(_ window: UIWindow) {
        delegate?.keyWindowChanged(window)
    }
    
    
}
