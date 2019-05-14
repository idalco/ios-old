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
import SVProgressHUD

class PortfolioVC: UIViewController {
    
    @IBOutlet weak var addNewButton: DCRoundedButton!
    @IBOutlet weak var collectionViewPortfolio: UICollectionView!
    private let refreshControl = UIRefreshControl()
    
    var photosArray: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpCollectionView()
        
        self.addNewButton.cornerRadius = 5
//        self.addNewButton.normalBackgroundColor = UIColor.FindaColours.Blue
        
        // Do any additional setup after loading the view.
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        self.updateImages()
    }

    private func setUpCollectionView(){
        if #available(iOS 10.0, *) {
            collectionViewPortfolio.refreshControl = refreshControl
        } else {
            collectionViewPortfolio.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: ((self.collectionViewPortfolio.frame.width)/2 - 30.1), height: ((self.collectionViewPortfolio.frame.width)/2 - 30.1))
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 6
        
        
        // (note, it's critical to actually set the layout to that!!)
        collectionViewPortfolio.collectionViewLayout = layout
    }
    
    @objc private func refreshData(_ sender: Any) {

        self.updateImages()
    }
    
    func updateImages() {
        PhotoManager.getPhotos(imageType: .Portfolio) { (response, result, photos) in
            if response {
                self.photosArray = photos
                self.collectionViewPortfolio.reloadData()
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
        config.showsPhotoFilters = false
        config.startOnScreen = .library
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.image) // Final image selected by the user
                SVProgressHUD.setBackgroundColor(UIColor.FindaColours.LightGrey)
                SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
                SVProgressHUD.show()
                FindaAPISession(target: .uploadPortfolioImage(image: photo.image), completion: { (response, result) in
                    SVProgressHUD.dismiss()
                    self.updateImages()
                    
                })
                
            }
            picker.dismiss(animated: true, completion: nil)
            
        }
        present(picker, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showImageSegue") {
            let vc = segue.destination as? ImageVC
            vc?.photo = sender as? Photo
            vc?.photoType = ImageType.Portfolio
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

//        cell.addDashedBorder(borderColour: UIColor.FindaColours.LightGrey, cornerRadius: 10)
//        cell.addSolidBorder(borderColour: UIColor.FindaColours.White, cornerRadius: 10, width: 2)
        let imageData = self.photosArray[indexPath.row].filename
        if let url = URL(string: imageData) {
            cell.image.af_setImage(withPortfolioURL: url, imageTransition: .crossDissolve(0.25))
        }
        
        cell.image.setRounded(radius: 10)
        if self.photosArray[indexPath.row].leadimage {
            cell.image.layer.borderWidth = 3
            cell.image.layer.borderColor = UIColor.FindaColours.Blue.cgColor
            cell.leadImageButton.isHidden = true
        } else {
            cell.leadImageButton.isHidden = false
            cell.image.layer.borderWidth = 0
            cell.image.layer.borderColor = UIColor.clear.cgColor
        }
        
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
        collectionViewPortfolio.reloadData()
    }
    
    @objc func selectLeadImage(sender: UIButton) -> Void {

        FindaAPISession(target: .selectLeadImage(id: self.photosArray[sender.tag].id)) { (response, result) in
            self.updateImages()
        }
        
        for photo in self.photosArray{
            photo.leadimage = false
        }
        self.photosArray[sender.tag].leadimage = true
        collectionViewPortfolio.reloadData()
    }

    
}
