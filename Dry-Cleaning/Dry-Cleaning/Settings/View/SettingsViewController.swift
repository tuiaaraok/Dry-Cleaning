//
//  SettingsViewController.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 18.09.24.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet var sectionViews: [UIView]!
    private let homeButton = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        homeButton.backgroundColor = .white
        homeButton.frame.size = CGSize(width: 44, height: 44)
        homeButton.layer.cornerRadius = 22
        homeButton.setImage(UIImage(named: "Home"), for: .normal)
        homeButton.imageView?.contentMode = .center
        homeButton.addTarget(self, action: #selector(goToHome), for: .touchUpInside)
        setNavigationBar(title: nil, button: homeButton)
        sectionViews.forEach { view in
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.25
            view.layer.shadowOffset = CGSize(width: 0, height: 4)
            view.layer.shadowRadius = 4
            view.layer.cornerRadius = 18
        }
    }
    
    @IBAction func clickedContactUs(_ sender: UIButton) {
    }
    
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
    }
    
    @IBAction func clickedRateUs(_ sender: UIButton) {
    }
    
    @objc func goToHome() {
        self.navigationController?.popViewController(animated: true)
    }
}
