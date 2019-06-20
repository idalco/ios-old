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
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    var photosArray: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpCollectionView()
        
        self.addNewButton.cornerRadius = 5
//        self.addNewButton.normalBackgroundColor = UIColor.FindaColours.Blue

        // Do any additional setup after loading the view.
//        self.title = "Polaroids"
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
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
        layout.itemSize = CGSize(width: ((self.collectionView.frame.width)/2 - 30.1), height: ((self.collectionView.frame.width)/2 - 30.1))
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 6
        
        // (note, it's critical to actually set the layout to that!!)
        collectionView.collectionViewLayout = layout
    }
    
    @objc private func refreshData(_ sender: Any) {
        
        self.updateImages()
    }
    
    func updateImages() {
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
        config.showsPhotoFilters = false
        config.startOnScreen = .library
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.image) // Final image selected by the user
                SVProgressHUD.setBackgroundColor(UIColor.FindaColours.LightGrey)
                SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
                SVProgressHUD.show()
                FindaAPISession(target: .uploadPolaroidImage(image: photo.image), completion: { (response, result) in
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
            vc?.photoType = ImageType.Polaroids
        }
    }
    
    func saveImageOrder() {
        var newOrder: [Int] = []
        for photo in self.photosArray {
            newOrder.append(photo.id)
        }
        FindaAPISession(target: .saveImageOrder(imageOrder: newOrder, imageType: "polaroids")) { (response, result) in
        }
    }

}

extension PolaroidVC: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.photosArray.count > 0 ? 1:0
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movePhoto = self.photosArray[sourceIndexPath.item]
        self.photosArray.remove(at: sourceIndexPath.item)
        self.photosArray.insert(movePhoto, at: destinationIndexPath.item)
        collectionView.reloadData()
        saveImageOrder()
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

        cell.image.setRounded(radius: 10)
        if let url = URL(string: imageData) {
            cell.image.af_setImage(withPolaroidsURL: url, imageTransition: .crossDissolve(0.25))
        }
      
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
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            break
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            break
        case .ended:
            collectionView.endInteractiveMovement()
            break
        default:
            collectionView.cancelInteractiveMovement()
            break
        }
    }
    
}


