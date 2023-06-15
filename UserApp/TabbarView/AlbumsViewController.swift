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
    
    let spinner = SpinnerViewController()
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbvc = self.tabBarController as! TabbarViewController
        user = tbvc.user
        showSpinner()
        
        
        // register tableview
        let nib = UINib(nibName: "UserTableViewCell", bundle: .main)
        tableview.register(nib, forCellReuseIdentifier: "cell")
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    func showSpinner() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
        getListAlbums(userId: user?.id ?? 0)
    }
    func hideSpinnner(){
        // then remove the spinner view controller
        self.spinner.willMove(toParent: nil)
        self.spinner.view.removeFromSuperview()
        self.spinner.removeFromParent()
    }
    
    func getListAlbums(userId: Int) {
        AlbumProviderImpl().getAlbums(id: userId) {
            data, status, message in
            if status == .success {
                self.albums = data as! [AlbumModel]
                if self.albums.isEmpty {
                    print("Not found Data")
                } else {
                    self.tableview.reloadData()
                }
            } else {
                print(message)
            }
            self.hideSpinnner()
        }
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
