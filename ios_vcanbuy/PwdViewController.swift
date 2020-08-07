//
//  PwdViewController.swift
//  ios_vcanbuy
//
//  Created by 张志勇 on 2020/8/4.
//  Copyright © 2020 vcanbuy. All rights reserved.
//

import UIKit

class PwdViewController: UIViewController {
    
    var sendButton: UIButton!
   
    var countdownTimer: Timer?
   
    var remainingSeconds: Int = 0 {
        willSet {
            sendButton.setTitle("(\(newValue)秒后重新获取)", for: .normal)
           
            if newValue <= 0 {
                sendButton.setTitle("获取验证码", for: .normal)
                isCounting = false
            }
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PwdViewController.updateTime(_:)), userInfo: nil, repeats: true)
                
                remainingSeconds = 60
                
                sendButton.backgroundColor = UIColor.gray
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                
                sendButton.backgroundColor = UIColor.orange
            }
            
            sendButton.isEnabled = !newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 进入页面，60s倒计时开始
//        isCounting = true

        self.view.backgroundColor = UIColor.white
        
        // 返回首页按钮
        let backBtn:UIButton = UIButton(frame: CGRect(x: 0, y: 50, width: 50, height: 30))
        backBtn.backgroundColor = UIColor.orange
        backBtn.setTitle("Back", for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        self.view.addSubview(backBtn)
        
        let frame = self.view.bounds
        
        // 标题
        let titleLabel = UILabel(frame:  CGRect(x:0,
                                          y:40,
                                          width: CGFloat(frame.size.width),
                                          height: 50))
        
        titleLabel.text = "更改密码"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "Arial-BoldMT", size: 20)
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)
        
        sendButton = UIButton()
        sendButton.frame = CGRect(x: frame.width - 130, y: 100, width: 120, height: 40)
        sendButton.backgroundColor = UIColor.orange
        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        sendButton.setTitle("获取验证码", for: .normal)
        sendButton.addTarget(self, action: #selector(PwdViewController.sendButtonClick(_:)), for: .touchUpInside)
        
        self.view.addSubview(sendButton)
        
    
        
    }
    
    @objc func backBtnAction() {
        print("click back button")
        let rootVC = UIApplication.shared.delegate as! AppDelegate
        let RootVC = RootViewController()
        rootVC.window?.rootViewController = RootVC
    }
    
    @objc func sendButtonClick(_ sender: UIButton) {
        isCounting = true
    }
    
    @objc func updateTime(_ timer: Timer) {
        remainingSeconds -= 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

