//
//  UserModel.swift
//  UserApp
//
//  Created by AnhPhamPC on 6/11/23.
//

import Foundation

struct UserModel: Codable {
    var id: Int
    var name: String?
    var username: String?
    var email: String?
    var address: AddressModel?
    var phone: String?
    var website: String?
    var company: CompanyModel?
}

struct AddressModel: Codable {
    var street: String?
    var suite: String?
    var city: String?
    var zipcode: String?
    var geo: [String:String]?
}

struct CompanyModel: Codable {
    var name: String?
    var catchPhrase: String?
    var bs: String?
}
