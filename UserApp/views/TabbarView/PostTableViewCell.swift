//
//  PostTableViewCell.swift
//  UserApp
//
//  Created by AnhPhamPC on 6/13/23.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbBody: UILabel!
    
    var delegate: PostCellDelegate?
    
    @IBAction func btComment(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.cellCommentButtonTapped(cell: self)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @objc func commentClick(sender: UITapGestureRecognizer) {
        if let delegate = delegate {
            delegate.cellCommentButtonTapped(cell: self)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpCell(post: PostModel){
        lbTitle.text = post.title
        lbBody.text = post.body
    }
    
}

