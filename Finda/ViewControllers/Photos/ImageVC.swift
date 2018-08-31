//
//  ImageVC.swift
//  Finda
//
//  Created by Peter Lloyd on 31/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit

class ImageVC: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var leadImageButton: UIButton!
    @IBOutlet weak var deleteImageButton: UIButton!
    
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.leadImageButton.setFAIcon(icon: .FACheck, forState: .normal)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let filename = photo?.filename, let url = URL(string: filename){
            self.image.af_setImage(withPortfolioURL: url, imageTransition: .crossDissolve(0.2))
        }
        if let lead = photo?.leadimage {
            self.setLead(lead: lead)
            
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction private func deleteImage(){
        guard let id = self.photo?.id else { return }
        FindaAPISession(target: .deleteImage(id: id)) { (response, result) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction private func selectLeadImage(){
        guard let id = self.photo?.id else { return }
        self.setLead(lead: true)
        FindaAPISession(target: .selectLeadImage(id: id)) { (response, result) in
            if !response {
                self.setLead(lead: false)
            }
        }
        
        
    }
    
    private func setLead(lead: Bool){
        if lead {
            self.image.layer.borderColor = UIColor.FindaColors.BrightBlue.cgColor
            self.image.layer.borderWidth = 3
            self.leadImageButton.isHidden = true
        } else {
            self.image.layer.borderColor = UIColor.clear.cgColor
            self.image.layer.borderWidth = 0
            self.leadImageButton.isHidden = false
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}