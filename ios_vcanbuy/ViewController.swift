//
//  ViewController.swift
//  ios_vcanbuy
//
//  Created by 张志勇 on 2019/12/25.
//  Copyright © 2019 vcanbuy. All rights reserved.
//

import UIKit
import WebKit
class ViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:"https://www.douyu.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }}
