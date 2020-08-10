//
//  MenuViewController.swift
//  ios_vcanbuy
//
//  Created by 张志勇 on 2020/7/21.
//  Copyright © 2020 vcanbuy. All rights reserved.
//

import UIKit
import SCLAlertView

class MenuViewController: UIViewController {

    var session = URLSession(configuration: .default)
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var prefix: String?

    var titlesArray = ["用户条款", "我的钱包", "我的订单", "我的箱子", "我的优惠券", "切换语言", "修改密码"]
    var iconImageView: UIImageView?
    var thLabel: UILabel?
    var nameLabel: UILabel?
    var avatar: String?
    var account: String?
    var name: String?
    var mobile: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        if (appDelegate.isDev) {
            prefix = "http://120.27.228.29:8081"
        } else {
            prefix = "http://m.vcanbuy.com"
        }

        self.view.backgroundColor = UIColor.orange

        self.setupUI()

    }

    func setupUI() {

        // 用户头像
        let iconImageView = UIImageView(frame: CGRect(x: 20, y: 80, width: 80, height: 80))
        iconImageView.image = UIImage(named: "avatar")
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
        iconImageView.layer.masksToBounds = true
        self.view.addSubview(iconImageView)
        self.iconImageView = iconImageView

        // 用户信息
        let greetLabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + 10, y: iconImageView.frame.origin.y, width: 200, height: 30))
        greetLabel.text = "你好！"
        greetLabel.textColor = UIColor.white
        self.view.addSubview(greetLabel)

        let thLabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + 10, y: iconImageView.frame.origin.y + 25, width: 200, height: 30))
        thLabel.text = "尊敬的用户"
        thLabel.textColor = UIColor.white
        self.view.addSubview(thLabel)
        self.thLabel = thLabel

        let nameLabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + 10, y: iconImageView.frame.origin.y + 50, width: 200, height: 30))
        nameLabel.text = "请先登录"
        nameLabel.textColor = UIColor.white
        self.view.addSubview(nameLabel)
        self.nameLabel = nameLabel

        // 跳转列表
        let tableHeight = UIScreen.main.bounds.height - iconImageView.frame.maxY
        let tableViewFrame = CGRect(x: iconImageView.frame.origin.x, y: iconImageView.frame.maxY + 20, width: 300, height: tableHeight)
        let tableView = UITableView(frame: tableViewFrame, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = UIColor.clear
        // 去除所有cell的分割线
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)

        // 获取用户信息
        getUserINfo()

    }

    func getUserINfo() -> Void {

        let url: String = prefix! + "/gateway/user/get_user_by_id"
        let request = URLRequest(url: URL(string: url)!)
        let task = session.dataTask(with: request) { (data, response, error) in
            do {
                let r = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                
                if(r["success"]! as! Bool == true){
                    let data = r.value(forKey: "data") as! NSDictionary
                    if data["user_d_o"] is NSNull {
                        print("请先登录")
                    } else {
                        let user_d_o = data.value(forKey: "user_d_o") as! NSDictionary
                        self.account = user_d_o.value(forKey: "account") as? String
                        self.avatar = user_d_o.value(forKey: "avatar") as? String
                        self.name = user_d_o.value(forKey: "name") as? String
                        self.mobile = user_d_o.value(forKey: "mobile") as? String

                        print("account: ", self.account!)
                        print("avatar: ", self.avatar!)
                        print("name: ", self.name!)
                        print("mobile: ", self.mobile!)
                        DispatchQueue.main.async {
                            self.thLabel?.text = self.account
                            self.nameLabel?.text = self.name

    //                        let imgUrl = self.avatar
    //                        let urlStr = NSURL(string: imgUrl!)
    //                        let data = NSData(contentsOf: urlStr! as URL)
    //                        if(data != nil){
    //                            self.iconImageView?.image = UIImage(data: data! as Data)
    //                        }else{
    //                            self.iconImageView?.image = UIImage(named: "avatar")
    //                        }

                        }
                    }
                }else{
                    print("用户信息获取失败")
                }
                
            } catch {
                DispatchQueue.main.async {
                    SCLAlertView().showError("Error", subTitle: "系统错误")
                }
                return
            }
        }
        task.resume()

    }

}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {

    // UITableViewDataSource方法，可选
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // UITableViewDataSource方法，必选
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }

    // UITableViewDataSource方法，必选
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.imageView?.image = UIImage(named: "icon.jpg")
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = titlesArray[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        return cell

    }

    // UITableViewDelegate方法，可选
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            jump(path: "home", vc: HelpViewController())
        } else if (indexPath.row == 1) {
            if (isLogin()) {
                jump(path: "myWallet")
            } else {
                jump(path: "login")
            }
        } else if (indexPath.row == 2) {
            if (isLogin()) {
                jump(path: "orderListOwn")
            } else {
                jump(path: "login")
            }
        } else if (indexPath.row == 3) {
            if (isLogin()) {
                jump(path: "orderListAgent")
            } else {
                jump(path: "login")
            }
        } else if (indexPath.row == 4) {
            if (isLogin()) {
                jump(path: "myCoupon")
            } else {
                jump(path: "login")
            }
        } else if (indexPath.row == 5) {
            jump(path: "changeLanguage")
        } else if (indexPath.row == 6) {
            if (isLogin()) {
//                alertMsg()
                
                // 加密展示的手机号66-950607788 => 66-95****788
               let startIndex = (self.mobile?.index(self.mobile!.startIndex, offsetBy: 6))!
               let endIndex = self.mobile?.index(self.mobile!.startIndex, offsetBy: 8)
               let secretMobile = self.mobile?.replacingCharacters(in: startIndex...endIndex!, with: "****")
               appDelegate.secretMobile = secretMobile
                appDelegate.realMobile = self.mobile
                self.jump(path: "home", vc:PwdViewController())

            } else {
                jump(path: "login")
            }
        }
    }

    // 单例传值跳转到相应的h5页面
    func jump(path: String, vc: UIViewController = RootViewController()) -> Void {
        appDelegate.value = path
        appDelegate.window?.rootViewController = vc
    }

    // 判断h5页面是否登录
    func isLogin() -> Bool {
        if let cookies = HTTPCookieStorage.shared.cookies {
            if (cookies.count == 0) {
                return false
            } else {
                return true
            }
        }
        return false
    }

    // ios原生提醒框之修改密码
    func alertMsg() -> Void {

        // 加密展示的手机号66-950607788 => 66-95****788
        let startIndex = (self.mobile?.index(self.mobile!.startIndex, offsetBy: 6))!
        let endIndex = self.mobile?.index(self.mobile!.startIndex, offsetBy: 8)
        let secretMobile = self.mobile?.replacingCharacters(in: startIndex...endIndex!, with: "****")
        appDelegate.secretMobile = secretMobile
        
        let alertController = UIAlertController(title: "修改登录密码",
                message: "将给手机" + secretMobile! + "发送验证码", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            action in
            self.sendMsg()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)

    }

    // 发送验证码
    func sendMsg() -> Void {

        let url = prefix! + "/gateway/msg/send_reset_password_sms_captcha"
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        // 设置要post的内容，字典格式
        let postData = ["mobile":(self.mobile)!]
        print("postdata: ",postData)
        
        let postString = postData.compactMap({ (key, value) -> String in
            return "\(key)=\(String(describing: value))"
        }).joined(separator: "&")
        request.httpBody = postString.data(using: .utf8)
        let task = session.dataTask(with: request) {(data, response, error) in
            do {
                let r = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                print(r)
                if(r["success"]! as! Bool == true){
                    DispatchQueue.main.async {
                        self.jump(path: "home", vc:PwdViewController())
                    }
                }else{
                    if(r["error_code"]! as! Int == 666){
                        DispatchQueue.main.async {
                            SCLAlertView().showError("Error", subTitle: "请勿频繁操作")
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        SCLAlertView().showError("Error", subTitle: "验证码发送失败")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    SCLAlertView().showError("Error", subTitle: "系统错误")
                }
                return
            }
        }
        task.resume()
    }

}
