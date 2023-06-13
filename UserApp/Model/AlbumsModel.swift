//
//  AlbumsModel.swift
//  UserApp
//
//  Created by AnhPhamPC on 6/12/23.
//

import Foundation


struct AlbumDetailModel: Codable {
    var albumId: Int
    var id: Int
    var title: String?
    var url: String?
    var thumbnailUrl: String?
}

struct AlbumModel: Codable{
    var userId: Int
    var id: Int
    var title: String?
}
