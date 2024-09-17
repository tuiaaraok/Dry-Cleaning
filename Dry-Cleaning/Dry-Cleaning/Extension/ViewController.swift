//
//  ViewController.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 17.09.24.
//

import UIKit

extension UIViewController {
    func setNavigationBar(title: String?, button: UIButton?) {
        if let nextButton = button {
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextButton)
        }
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = UIFont.semibold(size: 24)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }
    
    @objc func clickedBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
}
