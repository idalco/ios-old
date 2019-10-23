//
//  AffiliateVC.swift
//  Finda
//
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import DCKit

class AffiliateVC: UIViewController {
    
    
    @IBOutlet weak var shareButton: DCBorderedButton!
    @IBOutlet weak var affiliateLinkText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Affiliate Program"
        
        let modelManager = ModelManager()
        if modelManager.referrerCode() != "" {
            self.affiliateLinkText.text = "Your personal affiliate code is: \(modelManager.referrerCode())"
        }
        
        shareButton.addTarget(self, action: #selector(shareTextButton(_:)), for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menu(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    
    @IBAction func shareTextButton(_ sender: UIButton) {

        let modelManager = ModelManager()
        // text to share
        let text = "https://finda.co/?aff_id=\(modelManager.referrerCode())"

        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)

    }

}

