//
//  RootViewController.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 12.11.24.
//

import UIKit
import FirebaseRemoteConfig
import WebKit

class RootViewController: UIViewController {
    private var remoteConfig: RemoteConfig!
    private var privacyViewController: PrivacyViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFirstLaunch() {
            if !NetworkManager.shared.isConnected {
                showAlert("No network connection available")
            }
        }
        
        if let savedUrl = (UIApplication.shared.delegate as? AppDelegate)?.getSavedUrl() {
            loadWebView(with: savedUrl, showAgreeButton: false)
        } else if isFirstLaunch() {
            initializeRemoteConfig()
        } else {
            if UserDefaults.standard.bool(forKey: .passedOnBoardKey) {
                let menuVC = MenuViewController(nibName: "MenuViewController", bundle: nil)
                let navigationController = NavigationViewController(rootViewController: menuVC)
                navigationController.setAsRoot()
            } else {
                if let splashVC = storyboard?.instantiateViewController(withIdentifier: "SplashViewController") {
                    self.navigationController?.pushViewController(splashVC, animated: true)
                }
            }
            
        }
    }
    
    private func loadWebView(with urlString: String, showAgreeButton: Bool) {
        privacyViewController = PrivacyViewController()
        privacyViewController?.currentUrlString = urlString
        privacyViewController?.showAgreeButton = showAgreeButton
        privacyViewController?.completion = { [weak self] in
            guard let self = self else { return }
            if UserDefaults.standard.bool(forKey: .passedOnBoardKey) {
                let menuVC = MenuViewController(nibName: "MenuViewController", bundle: nil)
                let navigationController = NavigationViewController(rootViewController: menuVC)
                navigationController.setAsRoot()
            } else {
                if let splashVC = storyboard?.instantiateViewController(withIdentifier: "SplashViewController") {
                    self.navigationController?.pushViewController(splashVC, animated: true)
                }
            }
        }
        self.navigationController?.pushViewController(privacyViewController!, animated: true)
    }
    
    private func initializeRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 3600
        remoteConfig.configSettings = settings
        fetchRemoteConfigLink()
    }
    
    private func fetchRemoteConfigLink() {
        remoteConfig.fetchAndActivate { [weak self] status, error in
            guard error == nil else {
                print("Failed to fetch RemoteConfig: \(error!)")
                return
            }
            
            if let privacyLink = self?.remoteConfig["privacyLink"].stringValue, !privacyLink.isEmpty {
                self?.loadWebView(with: privacyLink, showAgreeButton: true)
            } else {
                print("Privacy link is empty in RemoteConfig.")
            }
        }
    }
    

    private func isFirstLaunch() -> Bool {
        return !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Network Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
