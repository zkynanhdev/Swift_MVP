//
//  AlbumDetailCell.swift
//  UserApp
//
//  Created by AnhPhamPC on 6/12/23.
//

import UIKit

class AlbumDetailCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.image.layer.cornerRadius = 10
    }

}
