//
//  PwdViewController.swift
//  ios_vcanbuy
//
//  Created by 张志勇 on 2020/8/4.
//  Copyright © 2020 vcanbuy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SCLAlertView
import Foundation
import CommonCrypto

class PwdViewController: UIViewController {
    var session = URLSession(configuration: .default)
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var prefix: String?
    
    var disposeBag = DisposeBag()

    var sendButton: UIButton!
    
    var confirmButton: UIButton!
    
    var tipLabel: UILabel!
   
    var countdownTimer: Timer?
   
    var remainingSeconds: Int = 0 {
        willSet {
            sendButton.setTitle("\(newValue)秒后重新发送", for: .normal)
           
            if newValue <= 0 {
                sendButton.setTitle("重新发送", for: .normal)
                isCounting = false
            }
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PwdViewController.updateTime(_:)), userInfo: nil, repeats: true)
                
                remainingSeconds = 10
                
                sendButton.backgroundColor = UIColor.gray
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                
                sendButton.backgroundColor = UIColor.orange
            }
            
            sendButton.isEnabled = !newValue
        }
    }
    
    var mobileTip:String?
    
    var otpText:String?  // 输入的验证码
    
    var pwdText:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 测试md5
        let str = "igsnow"
        let sign = str.md5()
        print("md5 in \(sign)")
        
        if (appDelegate.isDev) {
            prefix = "http://120.27.228.29:8081"
        } else {
            prefix = "http://m.vcanbuy.com"
        }
        
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
        sendButton.frame = CGRect(x: frame.width - 145, y: 120, width: 130, height: 55)
        sendButton.backgroundColor = UIColor.orange
        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        sendButton.setTitle("重新发送", for: .normal)
        sendButton.addTarget(self, action: #selector(PwdViewController.sendButtonClick(_:)), for: .touchUpInside)
        
        self.view.addSubview(sendButton)
        
        let otpField = UITextField(frame: CGRect(x:15, y:120, width:frame.width - 165, height:55))
        otpField.borderStyle = UITextField.BorderStyle.line
        otpField.placeholder="请输入验证码"
        otpField.adjustsFontSizeToFitWidth=true  //当文字超出文本框宽度时，自动调整文字大小
        otpField.minimumFontSize=14  //最小可缩小的字号
        otpField.textAlignment = .left //水平居中对齐
        otpField.contentVerticalAlignment = .center  //垂直居中对齐
        otpField.clearButtonMode = .whileEditing  //编辑时出现清除按钮
        otpField.layer.borderWidth = 1.0
        let paddingOtpView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        otpField.leftView = paddingOtpView
        otpField.leftViewMode = .always
        self.view.addSubview(otpField)
       
        let pwdField = UITextField(frame: CGRect(x:15, y:185, width:frame.width - 30, height:55))
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
        
        confirmButton = UIButton()
        confirmButton.frame = CGRect(x: 15, y: 260, width: frame.width - 30, height: 55)
        confirmButton.backgroundColor = UIColor.orange
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        confirmButton.setTitle("确认修改", for: .normal)
        confirmButton.alpha = 0.5
        confirmButton.isEnabled = false
        confirmButton.addTarget(self, action: #selector(PwdViewController.confirmButtonClick), for: .touchUpInside)
        
        self.view.addSubview(confirmButton)
        
        tipLabel = UILabel(frame:  CGRect(x:0,
                                          y:320,
                                          width: CGFloat(frame.size.width),
                                          height: 50))
        mobileTip = appDelegate.secretMobile
        tipLabel.text = "已向手机 " + mobileTip! + " 发送验证码"
        tipLabel.textColor = UIColor.gray
        tipLabel.font = UIFont(name: "ArialUnicodeMS", size: 15)
        tipLabel.textAlignment = .center
        self.view.addSubview(tipLabel)
        
        // 双向绑定
        let confirmButtonEnabled:Observable<Bool>

        confirmButtonEnabled = Observable.combineLatest(otpField.rx.text.orEmpty, pwdField.rx.text.orEmpty) { (username, password) in
                return !username.isEmpty && !password.isEmpty
        }.distinctUntilChanged().share(replay: 1)
        
        // 确认按钮是否禁用
        confirmButtonEnabled.subscribe(onNext: { [weak self](valid) in
            self?.confirmButton.isEnabled = valid
            self?.confirmButton.alpha = valid ? 1 : 0.5
        }).disposed(by: disposeBag)
        
        otpField.rx.text.orEmpty.asObservable()
        .subscribe(onNext: {
            self.otpText = $0
        }).disposed(by: disposeBag)
        
        pwdField.rx.text.orEmpty.asObservable()
        .subscribe(onNext: {
            self.pwdText = $0
        }).disposed(by: disposeBag)
        
        
        
    }
    
    @objc func backBtnAction() {
        print("click back button")
        let rootVC = UIApplication.shared.delegate as! AppDelegate
        let RootVC = RootViewController()
        rootVC.window?.rootViewController = RootVC
    }
    
    @objc func sendButtonClick(_ sender: UIButton) {
        isCounting = true
        sendMsg()
    }
    
    @objc func updateTime(_ timer: Timer) {
        remainingSeconds -= 1
    }
    
    @objc func confirmButtonClick(_ sender: UIButton) {
        print("confirm rewrite", self.otpText!, self.pwdText!)
        let v1 = verifyOtp(msg: self.otpText!)
        if(v1) {
            let v2 = verifyPwd(msg: self.pwdText!)
            if(v2){
                rewritePwd()
            }else{
                SCLAlertView().showError("Error", subTitle: "密码格式不正确")
            }
        }else{
            SCLAlertView().showError("Error", subTitle: "验证码格式不正确")
        }
    }
    
    // 发送验证码
    func sendMsg() -> Void {
        let url = prefix! + "/gateway/msg/send_reset_password_sms_captcha"
        
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        // 设置要post的内容，字典格式
        let postData = ["mobile":self.appDelegate.realMobile!]
        print("postdata: ",postData)
        
        let postString = postData.compactMap({ (key, value) -> String in
            return "\(key)=\(String(describing: value))"
        }).joined(separator: "&")
        request.httpBody = postString.data(using: .utf8)
        let task = session.dataTask(with: request) {(data, response, error) in
            do {
                let r = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                print(r)
                if((r["success"]) != nil){
                    print("send msg ok")
                    DispatchQueue.main.async {
                        SCLAlertView().showSuccess("Success", subTitle: "验证码发送成功")
                    }
                }else{
                    print("send msg no ok")
                    DispatchQueue.main.async {
                        SCLAlertView().showError("Error", subTitle: "验证码发送失败")
                    }
                }
            } catch {
                print("无法连接到服务器")
                return
            }
        }
        task.resume()
    }
    
    // 正则校验验证码
    func verifyOtp(msg: String) -> Bool {
        let regex = "^\\d{4}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: msg)
        print(isValid ? "正确的验证码" : "错误的验证码")
        return isValid ? true : false
    }
    
    // 正则校验密码
    func verifyPwd(msg: String) -> Bool {
        let regex = "^(\\d|\\w|\\W|\\S){6,20}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: msg)
        print(isValid ? "正确的密码" : "错误的密码")
        return isValid ? true : false
    }
    
    // 修改密码
    func rewritePwd() -> Void {
        let url = prefix! + "/gateway/user/reset_password_by_mobile"
    
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        // 设置要post的内容，字典格式
        let postData = ["mobile": (self.appDelegate.realMobile)!, "password": (self.pwdText?.md5())!, "captcha":(self.otpText)!]
        print("postdata: ",postData)
       
        let postString = postData.compactMap({ (key, value) -> String in
            return "\(key)=\(String(describing: value))"
        }).joined(separator: "&")
        request.httpBody = postString.data(using: .utf8)
        let task = session.dataTask(with: request) {(data, response, error) in
           do {
               let r = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
               print(r)
            if((r["success"]) != nil){
                    print("rwrite ok")
                    DispatchQueue.main.async {
                        SCLAlertView().showSuccess("Success", subTitle: "密码修改成功")
                    }
               }else{
                    print("rwrite no ok")
                    DispatchQueue.main.async {
                        SCLAlertView().showError("Error", subTitle: "密码修改失败")
                    }
               }
           } catch {
               print("无法连接到服务器")
               return
           }
        }
        task.resume()
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension String {
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
}

