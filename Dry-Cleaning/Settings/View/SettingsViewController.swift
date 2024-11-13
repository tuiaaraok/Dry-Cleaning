//
//  SettingsViewController.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 18.09.24.
//

import UIKit
import MessageUI

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
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients(["erayaykurt0@icloud.com"])
            present(mailComposeVC, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(
                title: "Mail Not Available",
                message: "Please configure a Mail account in your settings.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
        let privacyVC = PrivacyPolicyViewController()
        self.navigationController?.pushViewController(privacyVC, animated: true)
    }
    
    @IBAction func clickedRateUs(_ sender: UIButton) {
        let appID = "6738089041"
        if let url = URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Unable to open App Store URL")
            }
        }
    }
    
    @objc func goToHome() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
