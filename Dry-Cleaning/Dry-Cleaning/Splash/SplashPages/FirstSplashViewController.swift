//
//  FirstSplashViewController.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 17.09.24.
//

import UIKit

class FirstSplashViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pageImageView: UIImageView!
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.font = .semibold(size: 24)
        descriptionLabel.font = .semibold(size: 18)
        if index == 1 {
            pageImageView.image = UIImage(named: "OnBoard2")
        }
    }
}

