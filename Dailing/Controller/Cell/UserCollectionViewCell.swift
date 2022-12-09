//
//  AddUserCollectionViewCell.swift
//  Dailing
//
//  Created by 김동겸 on 2022/11/27.
//

import Foundation
import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var userImage: UIImageView! {
        didSet {
            userImage.layer.cornerRadius = 8
            userImage.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var userName: UILabel!
    
}
