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
    
    
    func getPosts(userId: Int){
        Alamofire.request("https://jsonplaceholder.typicode.com/posts?userId=\(userId)",method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200 ..< 299).responseData {
                response in
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                        do {
                            self.posts = try decoder.decode([PostModel].self, from: data)
                            if(self.posts.isEmpty){
                                print("Not found Data")
                                self.hideSpinnner()
                            }else{
                                self.tableView.reloadData()
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

extension PostViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostTableViewCell
        cell.lbTitle.text = posts[indexPath.row].title
        cell.lbBody.text = posts[indexPath.row].body
        cell.showCommentAction = {
            let commentVc = CommentsViewController()
            commentVc.postId = self.posts[indexPath.row].id
            self.present(commentVc, animated: true)
            print("comment click")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select \(indexPath)")
//        let albumDetailVc = AlbumDetail()
//        albumDetailVc.albumId = albums[indexPath.row].id
//        self.navigationController?.pushViewController(albumDetailVc, animated: true)
    }
}
