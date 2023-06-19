//
//  CommentTableViewCell.swift
//  UserApp
//
//  Created by AnhPhamPC on 6/13/23.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbEmail: UILabel!

    @IBOutlet weak var lbBody: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpView(comment: CommentModel){
        lbName.text = comment.name
        lbEmail.text = comment.email
        lbBody.text = comment.body
    }
    
}
