//
//  ProfileFormViewController.swift
//  Finda
//

import UIKit
import Eureka
import SVProgressHUD
import CoreLocation

struct AirportChoice {
    let code: String
    let name: String
}

class ProfileFormViewController: FormViewController {
    
    var user: User? {
        didSet {
            if isViewLoaded { renderData() }
        }
    }
    
    var profileImageView: UIImageView!
    let picker = UIImagePickerController()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let resetTutorialSection = Section()
//        <<< ButtonRow("resetTutorial") {
//                $0.title = "Reset Tutorial"
//            }.onCellSelection({ (cell, row) in
//                let userDefaults = UserDefaults.standard
//                userDefaults.set(false, forKey: "hasRunBefore")
//                userDefaults.synchronize()
//                self.helpShowPage(HelpPageBox(.onboarding), sender: self)
//            })
        
        let userDetailsSection = Section() { section in
            var header = HeaderFooterView<ProfileFormHeaderView>(.class)
            header.onSetupView = { view, _ in
                self.profileImageView = view.imageView
                if let imgString = self.user?.avatar {
                    self.profileImageView.kf.setImage(with: URL(string: imgString))
                }
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.chooseAvatar))
                self.profileImageView.addGestureRecognizer(tap)
                self.profileImageView.isUserInteractionEnabled = true
            }
            header.height = {128}
            section.header = header
            }
//            <<< TextRow("username") {
//                $0.title = "Username"
//            }.onCellHighlightChanged { cell, row in
//                if !cell.isHighlighted {
//                    self.saveChanges(persist: false)
//                }
//            }
            <<< EmailRow("email") {
                $0.title = "Email"
            }.onCellHighlightChanged { cell, row in
                if !cell.isHighlighted {
                    self.saveChanges(persist: false)
                }
            }
            <<< NameRow("first_name") {
                $0.title = "First Name"
            }.onCellHighlightChanged { cell, row in
                if !cell.isHighlighted {
                    self.saveChanges(persist: false)
                }
            }
            <<< NameRow("last_name") {
                $0.title = "Last Name"
            }.onCellHighlightChanged { cell, row in
                if !cell.isHighlighted {
                    self.saveChanges(persist: false)
                }
            }
        
        form +++ userDetailsSection
//            +++ resetTutorialSection
        
        form.delegate = self
        
        renderData()
        
//        user = currentUser(sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Profile"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SVProgressHUD.dismiss()
        
        saveChanges()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderData() {
        // fill in form data from user model
        form.setValues(["email": user?.email, "first_name": user?.firstName, "last_name": user?.lastName])
        tableView.reloadData()
    }
    
    
    
    // MARK: Actions
    
    @objc func chooseAvatar() {
        // launch photo chooser
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        
    }
    
    func saveChanges(persist: Bool = true) {
        let data = form.values()
        
        user?.email = data["email"] as! String
        user?.firstName = data["first_name"] as! String
        user?.lastName = data["last_name"] as! String
        
        if persist {
            updateUserProfile(user: user!, sender: self, completion: {(error) in
                if let error = error {
                    // TODO: handle error
                    print("Error saving profile: \(error)")
                }
            })
        }
    }
}

extension ProfileFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.image = pickedImage
            
            // encode and upload photo
            updateAvatar(avatar: pickedImage, sender: self, completion: {(error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: "Error uploading photo!")
                }
            })
        }
        
        dismiss(animated:true, completion: nil)
    }
}

extension ProfileFormViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // extract coordinates
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        // stop location updates
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
        }
    }
}
