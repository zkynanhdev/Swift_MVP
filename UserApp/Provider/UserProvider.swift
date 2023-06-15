//
//  UserProvider.swift
//  UserApp
//
//  Created by AnhPhamPC on 6/14/23.
//

import Foundation
import Alamofire

protocol UserProvider {
    func getUsers(completion: @escaping (_ data: Any?, _ status: status, _ message: String) -> Void)
}

class UserProviderImpl: UserProvider {
    
    func getUsers(completion: @escaping (_ data: Any?, _ status: status, _ message: String) -> Void) {
        AF.request("https://jsonplaceholder.typicode.com/users",method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200 ..< 299).responseData {
                response in
                switch response.result {
                case .success(let data):
                        let decoder = JSONDecoder()
                        do {
                            let users = try decoder.decode([UserModel].self, from: data)
                            completion(users, status.success, "")
                        } catch {
                            completion(nil, status.failure, error.localizedDescription)
                        }
                case .failure(let error):
                    completion(nil, status.failure, error.localizedDescription)
                }
            }
    }
    
}
