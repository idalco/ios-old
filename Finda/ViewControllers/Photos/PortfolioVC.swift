//
//  PhotosVC.swift
//  Finda
//
//  Created by Peter Lloyd on 13/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import DCKit
import YPImagePicker

class PortfolioVC: UIViewController {
    
    @IBOutlet weak var addNewButton: DCRoundedButton!
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.avatarImage.setRounded()
        
        self.addNewButton.cornerRadius = 5
        
        let model = ModelManager()
        if let url = URL(string: model.avatar()){
            self.avatarImage.af_setImage(withURL: url)
        }
        
        PhotoManager.getPhotos(imageType: .Portfolio) { (response, result, photos) in
            if response {
                
            }

        }

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addImage(_ sender: Any) {
        var config = YPImagePickerConfiguration()
        config.showsFilters = false
        config.startOnScreen = .library
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
//                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                FindaAPISession(target: .uploadPortfolioImage(image: photo.image), completion: { (response, result) in
                    if response {
                        print(result)
                    }
                })
                picker.dismiss(animated: true, completion: nil)
//                print(photo.originalImage) // original image selected by the user, unfiltered
//                print(photo.modifiedImage) // Transformed image, can be nil
//                print(photo.exifMeta) // Print exif meta data of original image.
            }
            
        }
        present(picker, animated: true, completion: nil)
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
