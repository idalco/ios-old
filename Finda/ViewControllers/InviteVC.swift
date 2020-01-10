//
//  InviteVC.swift
//  Finda
//
//  Created by Peter Lloyd on 20/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import DCKit

class InviteVC: UIViewController {
    
    @IBOutlet weak var leadImage: UIImageView!
    @IBOutlet weak var referralButton: DCBorderedButton!
    @IBOutlet weak var referralsLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var daysLabelContent: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var referralsArray: [Referral] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        referralButton.addTarget(self, action:#selector(self.share), for: UIControl.Event.touchUpInside)

        leadImage.layer.masksToBounds = true
        leadImage.layer.cornerRadius = leadImage.bounds.width / 2
        
        daysLabel.layer.masksToBounds = true
        daysLabel.layer.cornerRadius = daysLabel.bounds.width / 2
        
        self.title = "Invite Friends"
        
        let startDate = Date()
        let endDateString = "15.03.2020"

        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"

        if let endDate = formatter.date(from: endDateString) {
            let components = Calendar.current.dateComponents([.day], from: startDate, to: endDate)
            daysLabelContent.text = "\(components.day!)d left"
        } else {
            daysLabelContent.text = ""
        }
                
        // Do any additional setup after loading the view.
        
        FindaAPISession(target: .getReferrals) { (response, result) in
            if response {
                
                let verifiedCount = result["userdata"]["verified"].intValue
                if verifiedCount > 0 {
                    self.referralsLabel.text = "Successful referrals (\(verifiedCount))"
                
                    for referral in result["userdata"]["referrals"].arrayValue {
                        self.referralsArray.append(Referral(data: referral))
                    }
                
                    self.setUpCollectionView()
                } else {
                    self.referralsLabel.text = "Your friends will appear here"
                    self.referralsLabel.textAlignment = .center
                }
            }
        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        let modelManager = ModelManager()
        referralButton.setTitle("Your personal referral code: \(modelManager.referrerCode())", for: .normal)
        
        self.collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menu(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    
    @objc func share(_ sender: Any) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let modelManager = ModelManager()
            
        let textToShare = "I would like to invite you to model on FINDA, a smart and transparent model booking platform where you are in charge of your own bookings and receive quick payments. Click here to move faster through the waiting list: https://finda.co/?aff_id=\(modelManager.referrerCode()) or make sure to use my referral code if signing up via the app: \(modelManager.referrerCode())."

        if let myWebsite = URL(string: "https://finda.co/?aff_id=\(modelManager.referrerCode())") {
            let objectsToShare = [textToShare, myWebsite, image ?? #imageLiteral(resourceName: "FindaLogoBlack")] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            //

            activityVC.popoverPresentationController?.sourceView = sender as? UIView
            self.present(activityVC, animated: true, completion: nil)
        }
            
    }
    
    private func setUpCollectionView() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 96, height: 96)
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 6
        
        // (note, it's critical to actually set the layout to that!!)
        collectionView.collectionViewLayout = layout
    }
    
}

extension InviteVC: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.referralsArray.count > 0 ? 1:0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.referralsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "invitecell", for: indexPath) as! InviteCVC

        let imageData = self.referralsArray[indexPath.row].avatar
        
        if let url = URL(string: imageData) {
            cell.referralAvatar.af_setImage(withPortfolioURL: url, imageTransition: .crossDissolve(0.25))
        }
        
        cell.referralAvatar.setRounded(radius: 32)
        cell.referralName.text = self.referralsArray[indexPath.row].firstname + " " + self.referralsArray[indexPath.row].lastname
        
        if self.referralsArray[indexPath.row].status == 0 {
            cell.referralStatus.image = UIImage(named: "clockicon")
        } else {
            cell.referralStatus.image = UIImage(named: "tickicon")
        }
        
        cell.layoutIfNeeded()
        return cell
    }
    
    
    
    
}
