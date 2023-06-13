//
//  PostModel.swift
//  UserApp
//
//  Created by AnhPhamPC on 6/13/23.
//

import Foundation

class PostModel: Codable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
}

class CommentModel: Codable {
    var postId: Int
    var id: Int
    var name: String
    var email: String
    var body: String
}
