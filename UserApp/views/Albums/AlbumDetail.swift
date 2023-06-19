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
    
    private let albumDetailPresenter = AlbumDetailScreenPresenter()
    
    private let sectionInsets = UIEdgeInsets(
        top: 20.0,
      left: 10.0,
        bottom: 20.0,
      right: 10.0)

    @IBOutlet weak var collectionVC: UICollectionView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumDetailPresenter.attachView(view: self)
        albumDetailPresenter.getAlbumsDetail(albumId: self.albumId ?? -1)
        
        let nib = UINib(nibName: "AlbumDetailCell", bundle: .main)
        
        collectionVC.register(nib, forCellWithReuseIdentifier: "cell")
        collectionVC.delegate = self
        collectionVC.dataSource = self
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

extension AlbumDetail: AlbumDetailScreenView {
    func updateTableView(albumDetails: [AlbumDetailModel]) {
        self.albumDetails = albumDetails
        self.collectionVC.reloadData()
    }
    
    func startLoading() {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
    
    func finishLoading() {
        self.spinner.isHidden = true
        self.spinner.stopAnimating()
    }
    
    func showDialog(title: String, message: String, canBeCancelled: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        if canBeCancelled {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


