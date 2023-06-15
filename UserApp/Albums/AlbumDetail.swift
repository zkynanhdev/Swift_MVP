//
//  AlbumDetail.swift
//  UserApp
//
//  Created by AnhPhamPC on 6/12/23.
//

import UIKit
import Alamofire

class AlbumDetail: UIViewController {
    
    var albumDetails: [AlbumDetailModel] = []
    var albumId: Int? = nil
    let spinner = SpinnerViewController()
    private let sectionInsets = UIEdgeInsets(
        top: 20.0,
      left: 10.0,
        bottom: 20.0,
      right: 10.0)

    @IBOutlet weak var collectionVC: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSpinner()
        
        let nib = UINib(nibName: "AlbumDetailCell", bundle: .main)
        
        collectionVC.register(nib, forCellWithReuseIdentifier: "cell")
        collectionVC.delegate = self
        collectionVC.dataSource = self
    }
    
    func showSpinner() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
        getAlbumDetails()
    }
    func hideSpinnner(){
        // then remove the spinner view controller
        self.spinner.willMove(toParent: nil)
        self.spinner.view.removeFromSuperview()
        self.spinner.removeFromParent()
    }
    
    func getAlbumDetails(){
        AlbumProviderImpl().getAlbumsDetail(albumId: self.albumId ?? -1) {
            data, status, message in
            if status == .success {
                self.albumDetails = data as! [AlbumDetailModel]
                if self.albumDetails.isEmpty {
                    print("Not found Data")
                } else {
                    self.collectionVC.reloadData()
                }
            } else {
                print(message)
            }
            self.hideSpinnner()
        }
    }
}

extension AlbumDetail: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AlbumDetailCell
        
        cell.setUpCell(album: albumDetails[indexPath.row])
        
        return cell
    }
    
}

extension AlbumDetail: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width - 40
        let widthPerItem = availableWidth / 3
            return CGSize(width: widthPerItem, height: widthPerItem + 20)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
      ) -> UIEdgeInsets {
        return sectionInsets
      }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
      ) -> CGFloat {
          return sectionInsets.left
      }

}


