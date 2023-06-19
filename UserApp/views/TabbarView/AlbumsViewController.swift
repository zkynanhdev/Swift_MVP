//
//  AlbumsViewController.swift
//  UserApp
//
//  Created by AnhPhamPC on 6/12/23.
//

import UIKit
import Alamofire

class AlbumsViewController: UIViewController {
    
    var user: UserModel? = nil
    var albums: [AlbumModel] = []
    private let albumPresenter = AlbumScreenPresenter()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbvc = self.tabBarController as! TabbarViewController
        user = tbvc.user
        
        albumPresenter.attachView(view: self)
        albumPresenter.getAlbums(id: user?.id ?? -1)
        
        
        // register tableview
        let nib = UINib(nibName: "UserTableViewCell", bundle: .main)
        tableview.register(nib, forCellReuseIdentifier: "cell")
        tableview.delegate = self
        tableview.dataSource = self
    }

}

extension AlbumsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTableViewCell
        cell.setUpCell(id: albums[indexPath.row].id, name: albums[indexPath.row].title)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select \(indexPath)")
        let albumDetailVc = AlbumDetail()
        albumDetailVc.albumId = albums[indexPath.row].id
        self.navigationController?.pushViewController(albumDetailVc, animated: true)
    }
}

extension AlbumsViewController: AlbumScreenView {
    func startLoading() {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
    
    func finishLoading() {
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
    }
    
    func updateTableView(albums: [AlbumModel]) {
        self.albums = albums
        self.tableview.reloadData()
    }
    
    func showDialog(title: String, message: String, canBeCancelled: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        if canBeCancelled {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        }
        self.present(alert, animated: true, completion: nil)
    }
}
