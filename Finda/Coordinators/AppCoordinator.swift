//
//  AppCoordinator.swift
//  Finda
//

import UIKit
import Coordinator
import SVProgressHUD
import Eureka

final class AppCoordinator: NavigationCoordinator, NeedsDependency {
    var dependencies: AppDependency? {
        didSet {
            updateChildCoordinatorDependencies()
            processQueuedMessages()
        }
    }
    
    // user model
    var currentUser: User?
    
    // modals
    lazy var noInternetModal = NoInternetViewController.init(nibName: "NoInternetViewController", bundle: nil)
    
    //    AppCoordinator is root coordinator, top-level object in the UI hierarchy
    //    It keeps references to all the data source objects
    var reachabilityManager: ReachabilityManager!
    var loginManager: LoginManager!
    var dataManager: DataManager!
    var helpManager: HelpManager!
    var accountManager: AccountManager!
    
    // all app sections
    enum Section {
        case account(AccountCoordinator.Page?)
        case help(HelpCoordinator.Page?)
    }
    
    // *** SET THE INITIAL PAGE HERE ***
//    var section: Section = .destination(.chooseDestination)
    var section: Section = .help(.faq)
    
    @objc func loginHandler(notification: Notification) {
        if notification.name == NSNotification.Name.userLoggedIn {
            self.currentUser = notification.object as? User
            self.dependencies?.accountManager?.userLoggedIn()
        } else if notification.name == NSNotification.Name.userLoggedOut {
            self.currentUser = nil
            self.dependencies?.accountManager?.userLoggedOut()
        }
    }
    
    @objc func reachabilityChanged(notification: Notification) {
        if reachabilityManager.isOnline() {
            // hide modal
            if rootViewController.presentedViewController == noInternetModal {
                rootViewController.dismiss(animated: true, completion: nil)
            }
        } else {
            // display modal
            rootViewController.present(noInternetModal, animated: true, completion: nil)
        }
    }
    
    func setEureka() {
        // set font for all row types
        ButtonRow.defaultCellSetup = { cell, row in
            if let label = cell.textLabel {
                label.font = UIFont(name: "Gotham-Book", size: label.font.pointSize)
                label.textColor = .red // ?
            }
        }
        NameRow.defaultCellSetup = { cell, row in
            if let label = cell.textLabel {
                label.font = UIFont(name: "Gotham-Book", size: label.font.pointSize)
            }
            cell.textField.font = UIFont(name: "Gotham-Book", size: cell.textField.font!.pointSize)
        }
        EmailRow.defaultCellSetup = { cell, row in
            if let label = cell.textLabel {
                label.font = UIFont(name: "Gotham-Book", size: label.font.pointSize)
            }
            cell.textField.font = UIFont(name: "Gotham-Book", size: cell.textField.font!.pointSize)
        }
        PasswordRow.defaultCellSetup = { cell, row in
            if let label = cell.textLabel {
                label.font = UIFont(name: "Gotham-Book", size: label.font.pointSize)
            }
            cell.textField.font = UIFont(name: "Gotham-Book", size: cell.textField.font!.pointSize)
        }
        
        SliderRow.defaultCellSetup = { cell, row in
            if let label = cell.textLabel {
                label.font = UIFont(name: "Gotham-Book", size: label.font.pointSize)
            }
        }
        SegmentedRow<String>.defaultCellSetup = { cell, row in
            // set font family and set back
            if let label = cell.textLabel {
                label.font = UIFont(name: "Gotham-Book", size: label.font.pointSize)
            }
        }
        SwitchRow.defaultCellSetup = { cell, row in
            if let label = cell.textLabel {
                label.font = UIFont(name: "Gotham-Book", size: label.font.pointSize)
            }
        }
        
        // set font for all row types
        ListCheckRow<String>.defaultCellSetup = { cell, row in
            if let label = cell.textLabel {
                label.font = UIFont(name: "Gotham-Book", size: label.font.pointSize)
            }
        }
    }

    
    override func start(with completion: @escaping () -> Void = {}) {
        
        // get/set hasRunBefore flag
        let userDefaults = UserDefaults.standard
        let hasRunBefore = userDefaults.bool(forKey: "hasRunBefore")

//        ?? run tutorial here?
//        if (!hasRunBefore) {
//            section = .help(.onboarding)
//        }
        
        // update the flag
        userDefaults.set(true, forKey: "hasRunBefore")
        userDefaults.synchronize() // forces the app to update the UserDefaults
        
        // set appearance proxies
        UINavigationBar.appearance().backgroundColor = UIColor.FindaColors.Purple
        UINavigationBar.appearance().tintColor = UIColor.FindaColors.White
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.FindaColors.White]
        UINavigationBar.appearance().isTranslucent = false        
        
        // set default setup for Eureka form cells
        setEureka()
        
        // customise progress hud
        SVProgressHUD.setBackgroundColor(UIColor.FindaColors.Purple)
        SVProgressHUD.setForegroundColor(UIColor.FindaColors.DarkYellow)
        SVProgressHUD.setMinimumDismissTimeInterval(2.0)
        
        // listen for login/logout
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(loginHandler(notification:)), name: NSNotification.Name.userLoggedIn, object: nil)
        notificationCenter.addObserver(self, selector: #selector(loginHandler(notification:)), name: NSNotification.Name.userLoggedOut, object: nil)
        
        // listen for reachability changes
        notificationCenter.addObserver(self, selector: #selector(reachabilityChanged(notification:)), name: .reachabilityChanged, object: nil)
        
        // prepare managers
        self.reachabilityManager = ReachabilityManager()
        let api = FindaService(reachabilityManager: reachabilityManager)
        self.dataManager = DataManager(api: api)
        self.loginManager = LoginManager(api: api, dataManager: dataManager, shouldClearKeychain: !hasRunBefore)
        
        if loginManager.status == .loggedOutSavedCredentials {
            // authenticate before loading other managers
            self.loginManager.loginWithSavedCreds() {(success, response, error) in
                if success {
                    self.currentUser = response?.userData
                } else {
                    // TODO: handle failed login - saved credentials invalid?
                }
                
            }
        } else if loginManager.status == .loggedIn {
            api.authToken = self.loginManager.authToken
            dataManager.fetchCurrentUser(callback: {(user, error) in
                if let user = user {
                    self.currentUser = user
                }
            })
        }

        accountManager = AccountManager(dataManager: dataManager)
        helpManager = HelpManager(dataManager: dataManager)

        // load managers into dependencies object
        dependencies = AppDependency(apiManager: api, dataManager: dataManager, loginManager: loginManager, keychainProvider: nil, helpManager: helpManager, accountManager: accountManager)
        
        // finally ready
        super.start(with: completion)
        
        //    now, here comes the logic which
        //    content Coordinator to load
        setupActiveSection()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //    MARK:- CoordinatingResponder
    override func didChangeFilters(sender: Any?) {
    }
   
    override func didLogin(sender: Any?) {
    }
    
    override func didLogout(sender: Any?) {
    }
    
    override func isLoggedIn(sender: Any?) -> Bool {
        guard let loginManager = dependencies?.loginManager else {
            return false
        }
        return loginManager.status == .loggedIn
    }
    
    override func currentUser(sender: Any?) -> User? {
        if let accountManager = dependencies?.accountManager {
            if let user = accountManager.currentUser {
                self.currentUser = user
            }
        }
        return currentUser
    }
    
    override func accountShowPage(_ page: AccountPageBox, sender: Any?) {
        // switch to account section and show requested page
        
        setupActiveSection(.account(page.unbox))
    }
    
    override func helpShowPage(_ page: HelpPageBox, sender: Any?) {
        
        setupActiveSection(.help(page.unbox))
    }
    
    override func dismissHelp(sender: Any?) {
        // is this needed?
    }
    
    
    
}


fileprivate extension AppCoordinator {
    
    
    //    MARK:- Internal API
    func setupActiveSection(_ enforcedSection: Section? = nil) {
        if let enforcedSection = enforcedSection {
            section = enforcedSection
        }
        switch section {
            case .help(let page):
                showHelp(page)
            case .account(let page):
                showAccount(page)
        }
    }
    
    func showHelp(_ page: HelpCoordinator.Page?) {
        let identifier = String(describing: HelpCoordinator.self)
        //    if Coordinator is already created...
        if let c = childCoordinators[identifier] as? HelpCoordinator {
            c.dependencies = dependencies
            //    just display this page
            if let page = page {
                c.display(page: page)
            }
            return
        }
        
        //    otherwise, create the coordinator and start it
        let c = HelpCoordinator(rootViewController: rootViewController)
        c.dependencies = dependencies
        if let page = page {
            c.page = page
        }
        startChild(coordinator: c)
    }
    
    func showAccount(_ page: AccountCoordinator.Page?) {
        let identifier = String(describing: AccountCoordinator.self)
        //    if Coordinator is already created...
        if let c = childCoordinators[identifier] as? AccountCoordinator {
            c.dependencies = dependencies
            //    just display this page
            if let page = page {
                c.display(page: page)
            }
            return
        }
        
        //    otherwise, create the coordinator and start it
        let c = AccountCoordinator(rootViewController: rootViewController)
        c.dependencies = dependencies
        if let page = page {
            c.page = page
        }
        startChild(coordinator: c)
    }
}
