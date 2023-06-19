//
//  AlbumDetailPresenter.swift
//  UserApp
//
//  Created by AnhPhamPC on 6/19/23.
//

import UIKit
import Alamofire

protocol AlbumDetailScreenView: AnyObject, CommonView {
    func updateTableView(albumDetails: [AlbumDetailModel])
}

class AlbumDetailScreenPresenter {
    
    weak var albumDetailView: AlbumDetailScreenView?
    
    func attachView(view: AlbumDetailScreenView?){
        if let view = view {
            self.albumDetailView = view
        }
    }
    
    func getAlbumsDetail(albumId: Int) {
        self.albumDetailView?.startLoading()
        AF.request("https://jsonplaceholder.typicode.com/photos?albumId=\(albumId)",method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200 ..< 299).responseData {
                response in
                switch response.result {
                case .success(let data):
                        let decoder = JSONDecoder()
                        do {
                            let albumDetails = try decoder.decode([AlbumDetailModel].self, from: data)
                            DispatchQueue.main.async {
                                self.albumDetailView?.finishLoading()
                                self.albumDetailView?.updateTableView(albumDetails: albumDetails)
                            }
                        } catch {
                            self.albumDetailView?.finishLoading()
                            self.albumDetailView?.showDialog(title: "Error occured", message: "\(error.localizedDescription)", canBeCancelled: true)
                        }
                case .failure(let error):
                    self.albumDetailView?.finishLoading()
                    self.albumDetailView?.showDialog(title: "Error occured", message: "\(error.localizedDescription)", canBeCancelled: true)
                }
            }
    }
}
