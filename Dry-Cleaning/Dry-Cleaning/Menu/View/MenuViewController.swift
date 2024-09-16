//
//  MenuViewController.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 17.09.24.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var ordersCountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    let settingsButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsButton.backgroundColor = .white
        settingsButton.frame.size = CGSize(width: 44, height: 44)
        settingsButton.layer.cornerRadius = 22
        settingsButton.setImage(UIImage(named: "Settings"), for: .normal)
                setNavigationBar(title: nil, button: settingsButton)
    }
    
    @IBAction func clickedCreateOrder(_ sender: UIButton) {
    }
    
    @IBAction func clickedMyOrders(_ sender: UIButton) {
    }
    
    @IBAction func clickedStatistics(_ sender: UIButton) {
    }
}
