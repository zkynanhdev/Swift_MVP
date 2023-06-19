//
//  AlbumPresenter.swift
//  UserApp
//
//  Created by AnhPhamPC on 6/19/23.
//
import UIKit
import Alamofire

protocol AlbumScreenView: AnyObject, CommonView {
    func updateTableView(albums: [AlbumModel])
}

class AlbumScreenPresenter {
    
    weak var albumView: AlbumScreenView?
    
    func attachView(view: AlbumScreenView?){
        if let view = view {
            self.albumView = view
        }
    }
    
    func getAlbums(id: Int) {
        self.albumView?.startLoading()
        AF.request("https://jsonplaceholder.typicode.com/albums?userId=\(id)",method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200 ..< 299).responseData {
                response in
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                        do {
                            let albums = try decoder.decode([AlbumModel].self, from: data)
                            DispatchQueue.main.async {
                                self.albumView?.finishLoading()
                                self.albumView?.updateTableView(albums: albums)
                            }
                        } catch {
                            self.albumView?.finishLoading()
                            self.albumView?.showDialog(title: "Error occured", message: "\(error.localizedDescription)", canBeCancelled: true)
                        }
                case .failure(let error):
                    self.albumView?.finishLoading()
                    self.albumView?.showDialog(title: "Error occured", message: "\(error.localizedDescription)", canBeCancelled: true)
                }
            }
    }
}
