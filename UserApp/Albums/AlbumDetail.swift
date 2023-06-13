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
        Alamofire.request("https://jsonplaceholder.typicode.com/photos?albumId=\(self.albumId ?? 0)",method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200 ..< 299).responseData {
                response in
                switch response.result {
                case .success(let data):
                        let decoder = JSONDecoder()
                        do {
                            self.albumDetails = try decoder.decode([AlbumDetailModel].self, from: data)
                            if(self.albumDetails.isEmpty){
                                print("Not found Data")
                                self.hideSpinnner()
                            }else{
                                self.collectionVC.reloadData()
                                self.hideSpinnner()
                            }
                        } catch {
                            print(error.localizedDescription)
                            self.hideSpinnner()
                        }
                case .failure(let error):
                    print(error)
                }
            }
    }
}

extension AlbumDetail: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AlbumDetailCell
        
        let item = albumDetails[indexPath.row]
        cell.title.text = item.title
        cell.image.load(url: item.url ?? "")
        
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

extension UIImageView{
    func load(url: String) {
        guard let url = URL(string: url) else {
                    return
                }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

