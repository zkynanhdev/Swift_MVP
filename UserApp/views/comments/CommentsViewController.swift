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
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var postId: Int?
    
    private let commentsPresenter = CommentsScreenPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentsPresenter.attachView(view: self)
        commentsPresenter.getComments(id: self.postId ?? -1)
        
        // register tableview
        let nib = UINib(nibName: "CommentTableViewCell", bundle: .main)
        tableview.register(nib, forCellReuseIdentifier: "cell")
        tableview.delegate = self
        tableview.dataSource = self
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

extension CommentsViewController: CommentsScreenView {
    func updateTableView(comments: [CommentModel]) {
        self.comments = comments
        self.tableview.reloadData()
    }
    
    func startLoading() {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
    
    func finishLoading() {
        self.spinner.isHidden = true
        self.spinner.stopAnimating()
    }
    
    func showDialog(title: String, message: String, canBeCancelled: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        if canBeCancelled {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}
