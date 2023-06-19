//
//  CommentsPresenter.swift
//  UserApp
//
//  Created by AnhPhamPC on 6/19/23.
//

import UIKit
import Alamofire

protocol CommentsScreenView: AnyObject, CommonView {
    func updateTableView(comments: [CommentModel])
}

class CommentsScreenPresenter {
    
    weak var commentsView: CommentsScreenView?
    
    func attachView(view: CommentsScreenView?){
        if let view = view {
            self.commentsView = view
        }
    }
    
    func getComments(id: Int) {
        AF.request("https://jsonplaceholder.typicode.com/comments?postId=\(id)",method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200 ..< 299).responseData {
                response in
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                        do {
                            let comments = try decoder.decode([CommentModel].self, from: data)
                            DispatchQueue.main.async {
                                self.commentsView?.finishLoading()
                                self.commentsView?.updateTableView(comments: comments)
                            }
                        } catch {
                            self.commentsView?.finishLoading()
                            self.commentsView?.showDialog(title: "Error occured", message: "\(error.localizedDescription)", canBeCancelled: true)
                        }
                case .failure(let error):
                    self.commentsView?.finishLoading()
                    self.commentsView?.showDialog(title: "Error occured", message: "\(error.localizedDescription)", canBeCancelled: true)
                }
            }
    }
}
