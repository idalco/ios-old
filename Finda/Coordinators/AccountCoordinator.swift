//
//  AccountCoordinator.swift
//  Finda
//

import Foundation
import Coordinator

final class AccountCoordinator: NavigationCoordinator, NeedsDependency {
    var dependencies: AppDependency? {
        didSet { updateChildCoordinatorDependencies() }
    }
    
    override init(rootViewController: UINavigationController? = nil) {
        let nc = rootViewController ?? UINavigationController()
        super.init(rootViewController: nc)
        
        nc.delegate = self
    }
    
    //    Declaration of all local pages (ViewControllers)
    enum Page {
        case login
        case register
        case profile
//        case filters
    }
    var page: Page = .login
    
    func display(page: Page) {
        rootViewController.parentCoordinator = self
        rootViewController.delegate = self
        
        setupActivePage(page)
    }
    
//    // present from existing view controller
//    func present(page: Page, from controller: UIViewController) {
//        setupActivePage(page) // must not call any display/present methods after setup in setupActivePage
//        controller.present(rootViewController, animated: true, completion: nil)
//    }
    
    //    Coordinator lifecycle
    override func start(with completion: @escaping () -> Void = {}) {
        super.start(with: completion)
        
        setupActivePage()
    }
    
    //    MARK:- Coordinating Messages
    //    must be placed here, due to current Swift/ObjC limitations
    
    override func dismissLoginRegister(sender: Any?) {
        parent?.coordinatorDidFinish(self, completion: {})
    }
        
    override func updateUserSettings(user: User, sender: Any?, completion: @escaping (Error?) -> Void) {
        guard let manager = dependencies?.accountManager else {
            completion(AccountError.notLoggedIn)
            return
        }
        manager.updateUserSettings(user: user, sender: self, completion: completion)
    }
    
    override func updateUserProfile(user: User, sender: Any?, completion: @escaping (Error?) -> Void) {
        guard let manager = dependencies?.accountManager else {
            completion(AccountError.notLoggedIn)
            return
        }
        manager.updateUserProfile(user: user, sender: self, completion: completion)
    }
    
    override func updateAvatar(avatar: UIImage, sender: Any?, completion: @escaping (Error?) -> Void) {
        guard let manager = dependencies?.accountManager else {
            completion(AccountError.notLoggedIn)
            return
        }
        manager.updateAvatar(avatar: avatar, sender: sender, completion: completion)
    }
    
    override func fetchCurrentUser(sender: Any?, completion: @escaping (User?, Error?) -> Void) {
        guard let manager = dependencies?.accountManager else {
            completion(nil, AccountError.notLoggedIn)
            return
        }
        manager.currentUser(callback: { (user, error) in
            guard let user = user else {
                completion(nil, error)
                return
            }
            completion(user, nil)
        })
        
    }
    
    override func loginWithCredentials(sender: Any?, email: String, password: String, completion: @escaping (Bool) -> Void) {
        if let loginManager = dependencies?.loginManager {
            loginManager.loginWithProvider(provider: .finda, email: email, password: password, token: nil) { (success, response, error) in
                completion(success)
            }
        }
    }
    
    override func registerWithCredentials(sender: Any?, name: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        if let loginManager = dependencies?.loginManager {
            loginManager.registerAccount(name: name, email: email, password: password) { (success, response, error) in
                completion(success)
            }
        }
    }
    
}

fileprivate extension AccountCoordinator {
    func setupActivePage(_ enforcedPage: Page? = nil) {
        let p = enforcedPage ?? page
        page = p
        
        switch p {
        case .login:
            let vc = LoginRegisterViewController(formMode: .login, nibName: "LoginRegisterViewController", bundle: nil)
            show(vc)
        case .register:
            let vc = LoginRegisterViewController(formMode: .register, nibName: "LoginRegisterViewController", bundle: nil)
            show(vc)
            
        case .profile:
            let vc = ProfileFormViewController()
            if let accountManager = dependencies?.accountManager {
                vc.user = accountManager.currentUser
            }
            show(vc)
        }
    }
}
