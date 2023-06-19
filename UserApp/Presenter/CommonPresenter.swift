//
//  CommonPresenter.swift
//  UserApp
//
//  Created by AnhPhamPC on 6/19/23.
//

import Foundation

protocol CommonView {
    func startLoading()
    func finishLoading()
    func showDialog(title: String, message: String, canBeCancelled: Bool)
}
