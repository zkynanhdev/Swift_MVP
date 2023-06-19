//
//  PostViewController.swift
//  UserApp
//
//  Created by AnhPhamPC on 6/12/23.
//

import UIKit
import Alamofire

class PostViewController: UIViewController {
    
    var user: UserModel? = nil
    var posts: [PostModel] = []
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    private let postPresenter = PostScreenPresenter()
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbvc = self.tabBarController as! TabbarViewController
        self.user = tbvc.user
        
        // fetch data
        postPresenter.attachView(view: self)
        postPresenter.getPosts(id: user?.id ?? -1)
        
        // register tableview
        let nib = UINib(nibName: "PostTableViewCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension PostViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostTableViewCell
        
        cell.setUpCell(post: posts[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select \(indexPath)")
//        let albumDetailVc = AlbumDetail()
//        albumDetailVc.albumId = albums[indexPath.row].id
//        self.navigationController?.pushViewController(albumDetailVc, animated: true)
    }
}

extension PostViewController: PostCellDelegate {
    func cellCommentButtonTapped(cell: PostTableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)!
        let commentVc = CommentsViewController()
        commentVc.postId = self.posts[indexPath.row].id
        self.present(commentVc, animated: true)
    }
    
}

extension PostViewController: PostScreenView {
    func startLoading() {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
    
    func finishLoading() {
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
    }
    
    func updateTableView(posts: [PostModel]) {
        self.posts = posts
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


