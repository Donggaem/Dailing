//
//  ModalViewController.swift
//  Dailing
//
//  Created by 김동겸 on 2022/12/09.
//

import UIKit

class ModalViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var paramtitle = ""
    var paramcontent = ""
    var paramimage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = paramtitle
        contentLabel.text = paramcontent
        
        let url = URL(string: paramimage)
        imageView.kf.setImage(with: url)
    
    }

}
