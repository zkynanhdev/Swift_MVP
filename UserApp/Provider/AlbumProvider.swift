//
//  AlbumProvider.swift
//  UserApp
//
//  Created by AnhPhamPC on 6/14/23.
//

import Foundation
import Alamofire

protocol AlbumProvider {
    func getAlbums(id: Int, completion: @escaping (_ data: Any?, _ status: status, _ message: String) -> Void)
    func getAlbumsDetail(albumId: Int, completion: @escaping (_ data: Any?, _ status: status, _ message: String) -> Void)
}


class AlbumProviderImpl: AlbumProvider {
    
    func getAlbums(id: Int, completion: @escaping (_ data: Any?, _ status: status, _ message: String) -> Void) {
        AF.request("https://jsonplaceholder.typicode.com/albums?userId=\(id)",method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200 ..< 299).responseData {
                response in
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                        do {
                            let albums = try decoder.decode([AlbumModel].self, from: data)
                            completion(albums, status.success, "")
                        } catch {
                            completion(nil, status.failure, error.localizedDescription)
                        }
                case .failure(let error):
                    completion(nil, status.failure, error.localizedDescription)
                }
            }
    }
    
    func getAlbumsDetail(albumId: Int, completion: @escaping (_ data: Any?, _ status: status, _ message: String) -> Void) {
        AF.request("https://jsonplaceholder.typicode.com/photos?albumId=\(albumId)",method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200 ..< 299).responseData {
                response in
                switch response.result {
                case .success(let data):
                        let decoder = JSONDecoder()
                        do {
                            let albumDetails = try decoder.decode([AlbumDetailModel].self, from: data)
                            completion(albumDetails, status.success, "")
                        } catch {
                            completion(nil, status.success, error.localizedDescription)
                        }
                case .failure(let error):
                    completion(nil, status.success, error.localizedDescription)
                }
            }
    }
}
