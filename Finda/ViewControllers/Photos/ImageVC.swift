//
//  ImageVC.swift
//  Finda
//
//  Created by Peter Lloyd on 31/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import SwiftyGif

class ImageVC: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var leadImageButton: UIButton!
    @IBOutlet weak var deleteImageButton: UIButton!
    @IBOutlet weak var loadingView: UIImageView!
    
    var photo: Photo?
    var photoType: ImageType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.leadImageButton.setFAIcon(icon: .FACheck, iconSize: 20, forState: .normal)
        
//        self.leadImageButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        
        let leadImageButtonIcon = NSMutableAttributedString(string: "")
        if let fafont = UIFont(name: "FontAwesome5FreeSolid", size: 20) {
            leadImageButtonIcon.addAttribute(.font, value: fafont, range: NSMakeRange(0, 1))
            leadImageButtonIcon.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1), range: NSMakeRange(0, 1))
        }
        self.leadImageButton.setAttributedTitle(leadImageButtonIcon, for: .normal)
        
//        self.leadImageButton.setTitle(String.fontAwesomeIcon(name: .check), for: .normal)
        self.leadImageButton.isHidden = true
        self.deleteImageButton.isHidden = true

        let gifManager = SwiftyGifManager(memoryLimit:20)

        do {
            let gif = try UIImage(gifName: "loading-icon.gif")
            self.loadingView.setGifImage(gif, manager: gifManager)
        } catch _ {
        }

        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.barTintColor = UIColor.FindaColours.Burgundy
        
        if self.image.image == nil {
            self.makeLoadingView()
            if let filename = photo?.filename, let url = URL(string: filename){
                if photoType == ImageType.Portfolio {
                    self.image.af_setImage(withPortfolioSourceURL: url, imageTransition: .crossDissolve(0.2)) { (response) in
                        if response {
                            self.removeLoadingView()
                        }
                    }
                } else if photoType == ImageType.Polaroids {
                    self.image.af_setImage(withPolaroidsSourceURL: url, imageTransition: .crossDissolve(0.2)) { (response) in
                        if response {
                            self.removeLoadingView()
                        }
                    }
                }
            }
        }
        
//        if let lead = photo?.leadimage {
//            self.setLead(lead: lead)
//
//        }
    
    }
    private func makeLoadingView() {
        self.loadingView.isHidden = false
        self.loadingView.startAnimatingGif()
        
        self.deleteImageButton.isHidden = true
        self.leadImageButton.isHidden = true
    }
    
    private func removeLoadingView() {
        self.loadingView.stopAnimatingGif()
        self.loadingView.isHidden = true
        
        self.deleteImageButton.isHidden = false
        if let lead = photo?.leadimage {
            self.setLead(lead: lead)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.barTintColor = UIColor.FindaColours.Burgundy
        self.removeLoadingView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction private func deleteImage() {
        guard let id = self.photo?.id else { return }
        FindaAPISession(target: .deleteImage(id: id)) { (response, result) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction private func selectLeadImage() {
        guard let id = self.photo?.id else { return }
        self.setLead(lead: true)
        FindaAPISession(target: .selectLeadImage(id: id)) { (response, result) in
            if !response {
                self.setLead(lead: false)
            }
        }
        
        
    }
    
    private func setLead(lead: Bool) {
        if photoType == ImageType.Portfolio {
            if lead {
                self.image.layer.borderColor = UIColor.FindaColours.Pink.cgColor
                self.image.layer.borderWidth = 3
                self.leadImageButton.isHidden = true
            } else {
                self.image.layer.borderColor = UIColor.clear.cgColor
                self.image.layer.borderWidth = 0
                self.leadImageButton.isHidden = false
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//    }
 

}
