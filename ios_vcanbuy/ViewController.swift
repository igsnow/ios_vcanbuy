//
//  ViewController.swift
//  ios_vcanbuy
//
//  Created by 张志勇 on 2019/12/25.
//  Copyright © 2019 vcanbuy. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON

class ViewController: UIViewController, WKUIDelegate , WKScriptMessageHandler{
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let myURL = URL(string:"http://m.vcanbuy.com")
//        let myURL = URL(string:"http://120.27.228.29:8081")
        let myURL = URL(string:"http://169.254.23.141:1017")

        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.dealWith(message: message)
    }
    
    
    func dealWith(message: WKScriptMessage) {
        guard let messageBody = message.body as? String else {
            return
        }
        let body = JSON.init(parseJSON: messageBody)
        print(body)
        
        let action = body["action"].stringValue
        _ = body["callbackId"].stringValue
        if action.isEmpty {
            return
        }
        // js调用swift方法置空剪切板
        switch action {
        case "deleteClipboardRecord":
            UIPasteboard.general.string = "";
        default:
            return
        }
    }
    
}


