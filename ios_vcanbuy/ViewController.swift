//
//  ViewController.swift
//  ios_vcanbuy
//
//  Created by 张志勇 on 2019/12/25.
//  Copyright © 2019 vcanbuy. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import SwiftyJSON

struct VCBText {
    static var confirm: String {
           return NSLocalizedString("confirm", comment: "")
    }
}

class ViewController: UIViewController, WKUIDelegate , WKScriptMessageHandler{
    
    var webView: WKWebView!
    var params :String = ""
    var callbackId : String = ""
    var disposeBag: DisposeBag = DisposeBag()

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
        let myURL = URL(string:"http://169.254.88.144:1017")

        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup before view appears.
        super.viewWillAppear(animated)
        self.setupNotificationHandler()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let str:String = UIPasteboard.general.string ?? "";
        if !str.isEmpty{
            self.nativeCall(function: "onClipboardListener",params:str);
        }
    }
    
    // swift给js广播消息
    private func setupNotificationHandler() {
        NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification).takeUntil(self.rx.deallocated).subscribe({ (value) in
                   let str:String = UIPasteboard.general.string ?? "";
                    print("clipboard: ",str);
                   if !str.isEmpty{
                       self.nativeCall(function: "onClipboardListener",params:str);
                   }
               }).disposed(by: self.disposeBag);
           
    }
    
    func nativeCall(function:String,params:String){
        self.webView.evaluateJavaScript("window['" + function + "'] && " + function + "('"+(params )+"')", completionHandler: { (item, error) in
               
           })
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

// 代理以便能够执行webview中js的alert
extension ViewController {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        if !webView.isLoading && message != "" {
            let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
            let confirmAction = UIAlertAction.init(title: VCBText.confirm, style: .default) { (action) in
                completionHandler()
            }
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            completionHandler()
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
        print(message)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        print(prompt)
    }
}

