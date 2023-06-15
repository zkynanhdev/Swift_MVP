//
//  CommentProvider.swift
//  UserApp
//
//  Created by AnhPhamPC on 6/14/23.
//

import Foundation
import Alamofire

protocol CommentProvider {
    
    func getComments(id: Int, completion: @escaping (_ data: Any?, _ status: status, _ message: String) -> Void)
}

class CommentProviderImpl: CommentProvider {
    func getComments(id: Int, completion: @escaping (_ data: Any?, _ status: status, _ message: String) -> Void) {
        AF.request("https://jsonplaceholder.typicode.com/comments?postId=\(id)",method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200 ..< 299).responseData {
                response in
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                        do {
                            let comments = try decoder.decode([CommentModel].self, from: data)
                            completion(comments, status.success, "")
                        } catch {
                            completion(nil, status.failure, error.localizedDescription)
                        }
                case .failure(let error):
                    completion(nil, status.failure, error.localizedDescription)
                }
            }
    }
    
}
