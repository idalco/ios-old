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
    @IBOutlet weak var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    
    var photosArray: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpCollectionView()
        
        self.addNewButton.cornerRadius = 5
        self.addNewButton.normalBackgroundColor = UIColor.FindaColors.Purple
        
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
        PhotoManager.getPhotos(imageType: .Portfolio) { (response, result, photos) in
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
                FindaAPISession(target: .uploadPortfolioImage(image: photo.image), completion: { (response, result) in
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showImageSegue") {
            let vc = segue.destination as? ImageVC
            vc?.photo = sender as? Photo
        }
    }

}

extension PortfolioVC: UICollectionViewDelegate, UICollectionViewDataSource {
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PortfolioCVC

        cell.addDashedBorder(borderColour: UIColor.FindaColors.BrightBlue, cornerRadius: 10)
        let imageData = self.photosArray[indexPath.row].filename
        
        if let url = URL(string: imageData) {
            cell.image.af_setImage(withPortfolioURL: url, imageTransition: .crossDissolve(0.25))
        }
        
        if self.photosArray[indexPath.row].leadimage {
            cell.image.layer.borderWidth = 3
            cell.image.layer.borderColor = UIColor.FindaColors.BrightBlue.cgColor
            cell.leadImageButton.isHidden = true
        } else {
            cell.leadImageButton.isHidden = false
            cell.image.layer.borderWidth = 0
            cell.image.layer.borderColor = UIColor.clear.cgColor
        }
        
        
        
        //
        //        cell.deleteButton.tag = indexPath.row
        //        cell.deleteButton.addTarget(self, action: #selector(deleteImage(sender:)), for: UIControlEvents.touchUpInside)
        //        cell.leadImageButton.tag = indexPath.row
        //        cell.leadImageButton.addTarget(self, action: #selector(selectLeadImage(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.deleteButton.isHidden = true
        cell.leadImageButton.isHidden = true
        
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
    
    @objc func selectLeadImage(sender: UIButton) -> Void {

        FindaAPISession(target: .selectLeadImage(id: self.photosArray[sender.tag].id)) { (response, result) in
            self.updateImages()
        }
        
        for photo in self.photosArray{
            photo.leadimage = false
        }
        self.photosArray[sender.tag].leadimage = true
        collectionView.reloadData()
    }

    
}
