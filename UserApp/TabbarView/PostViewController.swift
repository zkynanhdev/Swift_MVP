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
    
    let spinner = SpinnerViewController()
    @IBOutlet weak var tableView: UITableView!
    
    func showSpinner() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
        getPosts(userId: user?.id ?? -1)
    }
    func hideSpinnner(){
        // then remove the spinner view controller
        self.spinner.willMove(toParent: nil)
        self.spinner.view.removeFromSuperview()
        self.spinner.removeFromParent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tbvc = self.tabBarController as! TabbarViewController
        user = tbvc.user
        showSpinner()
        
        // register tableview
        let nib = UINib(nibName: "PostTableViewCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func getPosts(userId: Int) {
        PostProviderImpl().getPosts(id: userId) {
            data, status, message in
            if status == .success {
                self.posts = data as! [PostModel]
                if self.posts.isEmpty {
                    print("Not found Data")
                } else {
                    self.tableView.reloadData()
                }
            } else {
                print(message)
            }
            self.hideSpinnner()
        }
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


