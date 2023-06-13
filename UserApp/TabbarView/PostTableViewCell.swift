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
    
    @IBOutlet weak var comment: UIStackView!
    
    var showCommentAction : (() -> Void)? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.commentClick))
        self.comment.addGestureRecognizer(gesture)
        self.comment.isUserInteractionEnabled = true
    }
    
    @objc func commentClick(sender: UITapGestureRecognizer) {
        if let commentClick = self.showCommentAction {
            commentClick()
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
