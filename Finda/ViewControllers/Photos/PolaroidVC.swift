//
//  PolaroidVC.swift
//  Finda
//
//  Created by Peter Lloyd on 14/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import DCKit
import YPImagePicker
import SVProgressHUD

class PolaroidVC: UIViewController {

    @IBOutlet weak var addNewButton: DCRoundedButton!
    @IBOutlet weak var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    
    var photosArray: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpCollectionView()
        
        self.addNewButton.cornerRadius = 5
        self.addNewButton.normalBackgroundColor = UIColor.FindaColors.Blue

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        self.updateImages()
    }
    
    private func setUpCollectionView(){
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: ((self.collectionView.frame.width)/2 - 4.1), height: ((self.collectionView.frame.width)/2 - 4.1))
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 6
        
        // (note, it's critical to actually set the layout to that!!)
        collectionView.collectionViewLayout = layout
    }
    
    @objc private func refreshData(_ sender: Any) {
        
        self.updateImages()
    }
    
    func updateImages(){
        PhotoManager.getPhotos(imageType: .Polaroids) { (response, result, photos) in
            if response {
                self.photosArray = photos
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
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
                SVProgressHUD.show()
                FindaAPISession(target: .uploadPolaroidImage(image: photo.image), completion: { (response, result) in
                    SVProgressHUD.dismiss()
//                    if response {
//                        SVProgressHUD.showSuccess(withStatus: "Uploaded")
//                    } else {
//                        SVProgressHUD.showError(withStatus: "Try again")
//                    }
                    self.updateImages()
                })
                
                //                print(photo.originalImage) // original image selected by the user, unfiltered
                //                print(photo.modifiedImage) // Transformed image, can be nil
                //                print(photo.exifMeta) // Print exif meta data of original image.
            }
            picker.dismiss(animated: true, completion: nil)
            
        }
        present(picker, animated: true, completion: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showImageSegue") {
            let vc = segue.destination as? ImageVC
            vc?.photo = sender as? Photo
            vc?.photoType = ImageType.Polaroids
        }
    }

}

extension PolaroidVC: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.photosArray.count > 0 ? 1:0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photosArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "showImageSegue", sender: self.photosArray[indexPath.row])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCVC
        
        let imageData = self.photosArray[indexPath.row].filename
        cell.addDashedBorder(borderColour: UIColor.FindaColors.BrightBlue, cornerRadius: 10)
        if let url = URL(string: imageData) {
            cell.image.af_setImage(withPolaroidsURL: url, imageTransition: .crossDissolve(0.25))
        }
        
//        cell.deleteButton.tag = indexPath.row
//        cell.deleteButton.addTarget(self, action: #selector(deleteImage(sender:)), for: UIControlEvents.touchUpInside)
      
        cell.deleteButton.isHidden = true
        
        cell.layoutIfNeeded()
        
        return cell
    }
    
    
    @objc func deleteImage(sender: UIButton) -> Void {
        
        FindaAPISession(target: .deleteImage(id: self.photosArray[sender.tag].id)) { (response, result) in
            self.updateImages()
        }
        photosArray.remove(at: sender.tag)
        collectionView.reloadData()
    }
    
}


