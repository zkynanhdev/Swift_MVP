//
//  PostProvider.swift
//  UserApp
//
//  Created by AnhPhamPC on 6/14/23.
//

import Foundation
import Alamofire

protocol PostProvider {
    func getPosts(id: Int, completion: @escaping (_ data: Any?, _ status: status, _ message: String) -> Void)
}

class PostProviderImpl: PostProvider {
    func getPosts(id: Int, completion: @escaping (_ data: Any?, _ status: status, _ message: String) -> Void) { AF.request("https://jsonplaceholder.typicode.com/posts?userId=\(id)",method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200 ..< 299).responseData {
                response in
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                        do {
                            let posts = try decoder.decode([PostModel].self, from: data)
                            completion(posts, status.success, "")
                        } catch {
                            completion(nil, status.failure, error.localizedDescription)
                        }
                case .failure(let error):
                    completion(nil, status.failure, error.localizedDescription)
                }
            }
    }
    
    
}
