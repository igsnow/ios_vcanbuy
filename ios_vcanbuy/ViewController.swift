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

class ViewController: UIViewController, WKUIDelegate ,WKNavigationDelegate, WKScriptMessageHandler{
    
    var webView: WKWebView!
    var params :String = ""
    var callbackId : String = ""
    var disposeBag: DisposeBag = DisposeBag()

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // 处理顶部状态栏透明的问题
        self.setupWebView()

        // 清除缓存
        self.clearCache()
        
        // 接收单例数据
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let hash = appDelegate.value ?? "home"
        print(hash)

//        let myURL = URL(string:"http://m.vcanbuy.com")
        let myURL = URL(string:"http://120.27.228.29:8081/#/" + hash)

        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup before view appears.
        super.viewWillAppear(animated)
        
        // 隐藏导航栏顶部
        self.navigationController?.navigationBar.isHidden = true
        self.setupNotificationHandler()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let str:String = UIPasteboard.general.string ?? "";
        if !str.isEmpty{
            self.nativeCall(function: "onClipboardListener",params:str);
        }
    }
    
    func setupWebView() {
            let webConfiguration = WKWebViewConfiguration()
        
            let userController = WKUserContentController()
            userController.add(self, name: "deleteClipboardRecord")
            webConfiguration.userContentController = userController
        
            webView = WKWebView(frame:.zero , configuration: webConfiguration)
            webView.uiDelegate = self
            view.addSubview(webView)
        
            webView.translatesAutoresizingMaskIntoConstraints = false

            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":webView]))
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":webView]))
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
        print("js call ios~~~~~~~~")
        self.webView.evaluateJavaScript("window['" + function + "'] && " + function + "('"+(params )+"')", completionHandler: { (item, error) in
               
           })
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("删除剪切板了~~~~~~~~~~~: ",message.body)
        UIPasteboard.general.string = "";
        let str:String = UIPasteboard.general.string ?? "";
        print("clipboard: ",str);

//        self.dealWith(message: message)
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
    
    // 防止userContentController内存泄漏
    deinit {
         webView.configuration.userContentController.removeScriptMessageHandler(forName: "deleteClipboardRecord")
    }
    
    // 去除webview缓存
    func clearCache() {
        if #available(iOS 9.0, *) {
            let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
            let date = NSDate(timeIntervalSince1970: 0)
            print("clear cache~~~")
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler:{ })
        } else {
            var libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, false).first!
            libraryPath += "/Cookies"
            
            do {
                try FileManager.default.removeItem(atPath: libraryPath)
            } catch {
                print("error")
            }
            URLCache.shared.removeAllCachedResponses()
        }
    }
    
    
    // 清除webview对h5页面的缓存
//    func clearCache() {
//        // iOS9.0以上使用的方法
//        if #available(iOS 9.0, *) {
//            print("ios9+++")
//            let dataStore = WKWebsiteDataStore.default()
//            dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), completionHandler: { (records) in
//                for record in records{
//                    // 清除本站的cookie
//                    if record.displayName.contains("120.27.228.29"){
//                        print("M站缓存：", record)
//                        // 这个判断注释掉的话是清理所有的cookie
//                        WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {
//                            // 清除成功
//                            print("清除成功\(record)")
//                        })
//                    }
//                }
//            })
//        } else {
//            print("ios8+++")
//            // ios8.0以上使用的方法
//            let libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
//            let cookiesPath = libraryPath! + "/Cookies"
//            try!FileManager.default.removeItem(atPath: cookiesPath)
//        }
//    }
    
}

// 代理以便能够执行webview中js的alert
//extension ViewController {
//
//    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
//        if !webView.isLoading && message != "" {
//            let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
//            let confirmAction = UIAlertAction.init(title: VCBText.confirm, style: .default) { (action) in
//                completionHandler()
//            }
//            alert.addAction(confirmAction)
//            self.present(alert, animated: true, completion: nil)
//        } else {
//            completionHandler()
//        }
//    }
//
//    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
//        completionHandler(true)
//        print(message)
//    }
//
//    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
//        print(prompt)
//    }
//}
//
