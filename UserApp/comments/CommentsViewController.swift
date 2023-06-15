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
    
    var comments: [CommentModel] = []
    
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
        CommentProviderImpl().getComments(id: postId) {
            data, status, message in
            if status == .success {
                self.comments = data as! [CommentModel]
                if self.comments.isEmpty {
                    print("Not found Data")
                } else {
                    self.tableview.reloadData()
                }
            } else {
                print(message)
            }
            self.hideSpinnner()
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
        
        cell.setUpView(comment: comments[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select \(indexPath)")
    }
}
