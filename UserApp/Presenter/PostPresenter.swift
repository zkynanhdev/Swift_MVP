//
//  PostPresenter.swift
//  UserApp
//
//  Created by AnhPhamPC on 6/19/23.
//

import UIKit
import Alamofire

protocol PostScreenView: AnyObject, CommonView {
    func updateTableView(posts: [PostModel])
}

class PostScreenPresenter {
    
    weak var postView: PostScreenView?
    
    func attachView(view: PostScreenView?){
        if let view = view {
            self.postView = view
        }
    }
    
    func getPosts(id: Int) {
        self.postView?.startLoading()
        AF.request("https://jsonplaceholder.typicode.com/posts?userId=\(id)",method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200 ..< 299).responseData {
                response in
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                        do {
                            let posts = try decoder.decode([PostModel].self, from: data)
                            DispatchQueue.main.async {
                                self.postView?.finishLoading()
                                self.postView?.updateTableView(posts: posts)
                            }
                        } catch {
                            self.postView?.finishLoading()
                            self.postView?.showDialog(title: "Error occured", message: "\(error.localizedDescription)", canBeCancelled: true)
                        }
                case .failure(let error):
                    self.postView?.finishLoading()
                    self.postView?.showDialog(title: "Error occured", message: "\(error.localizedDescription)", canBeCancelled: true)
                }
            }
    }
}
