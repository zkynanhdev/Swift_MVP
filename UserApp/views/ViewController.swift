//
//  ViewController.swift
//  UserApp
//
//  Created by AnhPhamPC on 6/11/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var users: [UserModel] = []
    
    @IBOutlet weak var spinner:   UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    private let homeScreenPresenter = HomeScreenPresenter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User List"
        homeScreenPresenter.attachView(view: self)
        homeScreenPresenter.getUsers()

        // register tableview
        let nib = UINib(nibName: "UserTableViewCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func showDetailScreen(user: UserModel){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarVC = storyBoard.instantiateViewController(identifier: "TabbarViewController") as TabbarViewController
        tabbarVC.user = user
        self.navigationController?.pushViewController(tabbarVC, animated: true)
    }

}

extension ViewController: HomeScreenView {
    func startLoading() {
        spinner?.isHidden = false
        spinner?.startAnimating()
    }
    
    func finishLoading() {
        spinner?.stopAnimating()
        spinner?.isHidden = true
    }
    
    func updateTableView(users: [UserModel]) {
        self.users = users
        self.tableView.reloadData()
    }
    
    func showDialog(title: String, message: String, canBeCancelled: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        if canBeCancelled {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        }
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(users.count)")
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTableViewCell
        cell.setUpCell(id: users[indexPath.row].id, name: users[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select \(indexPath)")
            showDetailScreen(user:users[indexPath.row])
    }
}

