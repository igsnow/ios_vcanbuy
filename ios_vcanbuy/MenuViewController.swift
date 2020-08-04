//
//  MenuViewController.swift
//  ios_vcanbuy
//
//  Created by 张志勇 on 2020/7/21.
//  Copyright © 2020 vcanbuy. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    let titlesArray = ["用户条款", "我的钱包", "我的订单", "我的箱子", "我的优惠券", "切换语言", "修改密码"]
    var iconImageView:UIImageView?
    var thLabel:UILabel?
    var nameLabel:UILabel?
    var avatar:String?
    var account :String?
    var name:String?

              
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.orange
        
        self.setupUI()
      
    }

    func setupUI() {
        
        // 用户头像
        let iconImageView = UIImageView(frame: CGRect(x: 20, y: 80, width: 80, height: 80))
        iconImageView.image = UIImage(named: "logo")
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
        iconImageView.layer.masksToBounds = true
        self.view.addSubview(iconImageView)
        self.iconImageView = iconImageView
        
        // 用户信息
        let greetLabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX+10, y: iconImageView.frame.origin.y, width: 200, height: 30))
        greetLabel.text = "你好！"
        greetLabel.textColor = UIColor.white
        self.view.addSubview(greetLabel)
        
        let thLabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX+10, y: iconImageView.frame.origin.y + 25, width: 200, height: 30))
        thLabel.text = "尊敬的用户"
        thLabel.textColor = UIColor.white
        self.view.addSubview(thLabel)
        self.thLabel = thLabel
        
        let nameLabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX+10, y: iconImageView.frame.origin.y + 50, width: 200, height: 30))
        nameLabel.text = "请先登录"
        nameLabel.textColor = UIColor.white
        self.view.addSubview(nameLabel)
        self.nameLabel = nameLabel
         
        // 跳转列表
        let tableHeight = UIScreen.main.bounds.height-iconImageView.frame.maxY
        let tableViewFrame = CGRect(x: iconImageView.frame.origin.x, y: iconImageView.frame.maxY+20, width: 300, height: tableHeight)
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var prefix:String?
        if(appDelegate.isDev){
            prefix = "http://120.27.228.29:8081"
        }else{
            prefix = "http://m.vcanbuy.com"
        }
        
        let url:String = prefix! + "/gateway/user/get_user_by_id"
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: URL(string: url)!)
        let task = session.dataTask(with: request) {(data, response, error) in
            do {
                let r = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                let data = r.value(forKey: "data") as! NSDictionary
               
                if data["user_d_o"] is NSNull {
                    print("请先登录")
                }else {
                    let user_d_o = data.value(forKey: "user_d_o") as! NSDictionary
                    self.account = user_d_o.value(forKey: "account") as? String
                    self.avatar = user_d_o.value(forKey: "avatar") as? String
                    self.name = user_d_o.value(forKey: "name") as? String
                    print("account: ",self.account!)
                    print("avatar: ",self.avatar!)
                    print("name: ",self.name!)
                    
                    DispatchQueue.main.async {
                        self.thLabel?.text = self.account
                        self.nameLabel?.text = self.name
                    
                        let imgUrl = "https://i.stack.imgur.com/KxUuh.jpg?s=32&g=1"
                        let urlStr = NSURL(string: imgUrl)
                        let data = NSData(contentsOf: urlStr! as URL)

                        if(data != nil){
                            self.iconImageView?.image = UIImage(data: data! as Data)
                        }else{
                            self.iconImageView?.image = UIImage(named: "logo")
                        }
                        
                    }
                    
                }
                

            } catch {
                print("无法连接到服务器")
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
            jump(path: "home", vc:HelpViewController())
        }
        else if (indexPath.row == 1){
            if(isLogin()){
                jump(path: "myWallet")
            }else{
                jump(path: "login")
            }
        }
        else if (indexPath.row == 2){
            if(isLogin()){
                jump(path: "orderListOwn")
            }else{
                 jump(path: "login")
            }
        }
        else if (indexPath.row == 3){
            if(isLogin()){
                jump(path: "orderListAgent")
            }else{
                jump(path: "login")
            }
        }
        else if (indexPath.row == 4){
            if(isLogin()){
                jump(path: "myCoupon")
            }else{
                jump(path: "login")
            }
        }
        else if (indexPath.row == 5){
            jump(path: "changeLanguage")
        }
        else if (indexPath.row == 6){
            print("修改密码")
        }
    }
    
    // 单例传值跳转到相应的h5页面
    func jump(path: String, vc:UIViewController = RootViewController()) -> Void {
        let rootVC = UIApplication.shared.delegate as! AppDelegate
        rootVC.value = path
        rootVC.window?.rootViewController = vc
    }
    
    // 判断h5页面是否登录
    func isLogin() -> Bool {
        if let cookies = HTTPCookieStorage.shared.cookies {
            if(cookies.count == 0){
                return false
            }else{
                return true
            }
        }
        return false
    }
}
