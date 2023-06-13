//
//  CommentsViewController.swift
//  UserApp
//
//  Created by AnhPhamPC on 6/13/23.
//

import UIKit
import Alamofire

class CommentsViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var comments: [CommentsModel] = []
    
    var postId: Int = -1
    
    let spinner = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSpinner()
        
        // register tableview
        let nib = UINib(nibName: "CommentTableViewCell", bundle: .main)
        tableview.register(nib, forCellReuseIdentifier: "cell")
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    func showSpinner() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
        getComments(postId: self.postId)
    }
    func hideSpinnner(){
        // then remove the spinner view controller
        self.spinner.willMove(toParent: nil)
        self.spinner.view.removeFromSuperview()
        self.spinner.removeFromParent()
    }
    
    func getComments(postId: Int){
        Alamofire.request("https://jsonplaceholder.typicode.com/comments?postId=\(postId)",method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200 ..< 299).responseData {
                response in
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                        do {
                            self.comments = try decoder.decode([CommentsModel].self, from: data)
                            if(self.comments.isEmpty){
                                print("Not found Data")
                                self.hideSpinnner()
                            }else{
                                self.tableview.reloadData()
                                self.hideSpinnner()
                            }
                        } catch {
                                print(error.localizedDescription)
                                self.hideSpinnner()
                        }
                case .failure(let error):
                    print(error)
                }
            }
    }

}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommentTableViewCell
        cell.lbName.text = comments[indexPath.row].name
        cell.lbEmail.text = comments[indexPath.row].email
        cell.lbBody.text = comments[indexPath.row].body
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select \(indexPath)")
    }
}
