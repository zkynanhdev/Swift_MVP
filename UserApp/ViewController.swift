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

    let spinner = SpinnerViewController()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User List"
        // add the spinner view controller
        showSpinner()

        // register tableview
        let nib = UINib(nibName: "UserTableViewCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func showSpinner() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
        getListUser()
    }
    func hideSpinnner(){
        // then remove the spinner view controller
        self.spinner.willMove(toParent: nil)
        self.spinner.view.removeFromSuperview()
        self.spinner.removeFromParent()
    }
    
    func showDetailScreen(user: UserModel){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarVC = storyBoard.instantiateViewController(identifier: "TabbarViewController") as TabbarViewController
        tabbarVC.user = user
        self.navigationController?.pushViewController(tabbarVC, animated: true)
    }
    
    
    func getListUser(){
        Alamofire.request("https://jsonplaceholder.typicode.com/users",method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200 ..< 299).responseData {
                response in
                switch response.result {
                case .success(let data):
                        let decoder = JSONDecoder()
                        do {
                            self.users = try decoder.decode([UserModel].self, from: data)
                            self.tableView.reloadData()
                            self.hideSpinnner()
                        } catch {
                            print(error.localizedDescription)
                        }
                case .failure(let error):
                    print(error)
                }
            }
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
        cell.lbID.text = users[indexPath.row].id.description
        cell.lbName.text = users[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select \(indexPath)")
            showDetailScreen(user:users[indexPath.row])
    }
}

