//
//  PrivacyPolicyViewController.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 12.11.24.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController {
    private var webView: WKWebView!
    private let urlString = "https://docs.google.com/document/d/1e3f_P9y2BRjbnNGl-Jt9A0-iLMsnlQW-7yE6dmOnSRM/mobilebasic"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: self.view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(webView)
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
