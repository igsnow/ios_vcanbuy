//
//  PwdViewController.swift
//  ios_vcanbuy
//
//  Created by 张志勇 on 2020/8/4.
//  Copyright © 2020 vcanbuy. All rights reserved.
//

import UIKit

class PwdViewController: UIViewController {
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

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
        DispatchQueue.main.async {
            self.isCounting = true
        }
        
        self.view.backgroundColor = UIColor.white
        
        // 返回首页按钮
        let backBtn:UIButton = UIButton(frame: CGRect(x: 15, y: 50, width: 50, height: 30))
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
        
        titleLabel.text = "修改密码"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)
        
        sendButton = UIButton()
        sendButton.frame = CGRect(x: frame.width - 145, y: 120, width: 130, height: 50)
        sendButton.backgroundColor = UIColor.orange
        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        sendButton.setTitle("获取验证码", for: .normal)
        sendButton.addTarget(self, action: #selector(PwdViewController.sendButtonClick(_:)), for: .touchUpInside)
        
        self.view.addSubview(sendButton)
        
        let otpField = UITextField(frame: CGRect(x:15, y:120, width:frame.width - 165, height:50))
        otpField.borderStyle = UITextField.BorderStyle.line
        otpField.placeholder="请输入验证码"
        otpField.adjustsFontSizeToFitWidth=true  //当文字超出文本框宽度时，自动调整文字大小
        otpField.minimumFontSize=14  //最小可缩小的字号
        otpField.textAlignment = .left //水平居中对齐
        otpField.contentVerticalAlignment = .center  //垂直居中对齐
        otpField.clearButtonMode = .whileEditing  //编辑时出现清除按钮
        let paddingOtpView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        otpField.leftView = paddingOtpView
        otpField.leftViewMode = .always
        self.view.addSubview(otpField)
        
        let pwdField = UITextField(frame: CGRect(x:15, y:180, width:frame.width - 30, height:50))
        pwdField.borderStyle = UITextField.BorderStyle.line
        pwdField.placeholder="请输入新密码"
        pwdField.adjustsFontSizeToFitWidth=true
        pwdField.minimumFontSize=14
        pwdField.textAlignment = .left
        pwdField.contentVerticalAlignment = .center
        pwdField.clearButtonMode = .whileEditing
        let paddingPwdView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        pwdField.leftView = paddingPwdView
        pwdField.leftViewMode = .always
        self.view.addSubview(pwdField)
        
        let confirmButton = UIButton()
        confirmButton.frame = CGRect(x: 15, y: 250, width: frame.width - 30, height: 50)
        confirmButton.backgroundColor = UIColor.orange
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        confirmButton.setTitle("确认修改", for: .normal)
        confirmButton.addTarget(self, action: #selector(PwdViewController.sendButtonClick(_:)), for: .touchUpInside)
        
        self.view.addSubview(confirmButton)
        
        let tipLabel = UILabel(frame:  CGRect(x:0,
                                          y:300,
                                          width: CGFloat(frame.size.width),
                                          height: 50))
        let secretMobile = appDelegate.secretMobile
        tipLabel.text = "已向手机 " + secretMobile! + " 发送验证码"
        tipLabel.textColor = UIColor.gray
        tipLabel.font = UIFont(name: "ArialUnicodeMS", size: 15)
        tipLabel.textAlignment = .center
        self.view.addSubview(tipLabel)
    
        
    }
    
    @objc func backBtnAction() {
        print("click back button")
        let rootVC = UIApplication.shared.delegate as! AppDelegate
        let RootVC = RootViewController()
        rootVC.window?.rootViewController = RootVC
    }
    
    @objc func sendButtonClick(_ sender: UIButton) {
        print("start timer")
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

