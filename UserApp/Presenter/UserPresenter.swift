//
//  UserPresenter.swift
//  UserApp
//
//  Created by AnhPhamPC on 6/19/23.
//

import UIKit
import Alamofire

protocol HomeScreenView: AnyObject, CommonView {
    func updateTableView(users: [UserModel])
}

class HomeScreenPresenter {
    
    weak var homeView: HomeScreenView?
    
    func attachView(view: HomeScreenView?){
        if let view = view {
            self.homeView = view
        }
    }
    
    func getUsers() {
        self.homeView?.startLoading()
        AF.request("https://jsonplaceholder.typicode.com/users",method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200 ..< 299).responseData {
                response in
                switch response.result {
                case .success(let data):
                        let decoder = JSONDecoder()
                        do {
                            let users = try decoder.decode([UserModel].self, from: data)
                            DispatchQueue.main.async{
                                self.homeView?.finishLoading()
                                self.homeView?.updateTableView(users: users)
                            }
                        } catch {
                            self.homeView?.finishLoading()
                            self.homeView?.showDialog(title: "Error occured", message: "\(error.localizedDescription)", canBeCancelled: true)
                        }
                case .failure(let error):
                    self.homeView?.finishLoading()
                    self.homeView?.showDialog(title: "Error occured", message: "\(error.localizedDescription)", canBeCancelled: true)
                }
            }
    }
}
