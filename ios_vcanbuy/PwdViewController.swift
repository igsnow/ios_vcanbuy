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

class PwdViewController: UIViewController {
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var disposeBag = DisposeBag()

    var sendButton: UIButton!
    
    var confirmButton: UIButton!
   
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
        
        let tipLabel = UILabel(frame:  CGRect(x:0,
                                          y:320,
                                          width: CGFloat(frame.size.width),
                                          height: 50))
        let secretMobile = appDelegate.secretMobile
        tipLabel.text = "已向手机 " + secretMobile! + " 发送验证码"
        tipLabel.textColor = UIColor.gray
        tipLabel.font = UIFont(name: "ArialUnicodeMS", size: 15)
        tipLabel.textAlignment = .center
        self.view.addSubview(tipLabel)
        
        let label = UILabel(frame:CGRect(x:20, y:400, width:300, height:30))
        self.view.addSubview(label)
        
        // 双向绑定
//        let input = otpField.rx.text.orEmpty.asDriver().throttle(0.3)
//        input.drive(pwdField.rx.text).disposed(by: disposeBag)
//        input.map{"当前字数：\($0.count)"}.drive(label.rx.text).disposed(by: disposeBag)
//
//        input.map{$0.count > 5}.drive(confirmButton.rx.isEnabled).disposed(by:  disposeBag)

        
        //        Observable.combineLatest(otpField.rx.text.orEmpty, pwdField.rx.text.orEmpty) {
        //        textValue1, textValue2 -> String in
        //            return "你输入的号码是：\(textValue1)-\(textValue2)"
        //        }
        //        .map { $0 }
        //        .bind(to: label.rx.text)
        //        .disposed(by: disposeBag)

        let confirmButtonEnabled:Observable<Bool>

        confirmButtonEnabled = Observable.combineLatest(otpField.rx.text.orEmpty, pwdField.rx.text.orEmpty) { (username, password) in
                return !username.isEmpty && !password.isEmpty
        }.distinctUntilChanged().share(replay: 1)
        
        confirmButtonEnabled.subscribe(onNext: { [weak self](valid) in
            self?.confirmButton.isEnabled = valid
            self?.confirmButton.alpha = valid ? 1 : 0.5
        }).disposed(by: disposeBag)
        
        

        
        
        
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
    
    @objc func confirmButtonClick(_ sender: UIButton) {
        print("confirm rewrite")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

