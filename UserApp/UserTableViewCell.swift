//
//  UserTableViewCell.swift
//  UserApp
//
//  Created by AnhPhamPC on 6/12/23.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lbID: UILabel!
    @IBOutlet weak var lbName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell(id: Int?, name: String?) {
        lbID.text = id?.description
        lbName.text = name
    }
    
}
