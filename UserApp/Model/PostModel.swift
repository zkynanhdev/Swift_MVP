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

protocol PostCellDelegate {
    func cellCommentButtonTapped(cell: PostTableViewCell)
}

