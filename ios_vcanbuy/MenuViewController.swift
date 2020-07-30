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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.orange
        
        self.setupUI()
    }

    func setupUI() {
    
        // 头像
        let iconImageView = UIImageView(frame: CGRect(x: 10, y: 64+10, width: 60, height: 60))
        iconImageView.image = UIImage(named: "icon.jpg")
        self.view.addSubview(iconImageView)
        // 姓名
        let greetLabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX+10, y: iconImageView.frame.origin.y, width: 200, height: 30))
        greetLabel.text = "你好！"
        greetLabel.textColor = UIColor.white
        self.view.addSubview(greetLabel)
        
        let thLabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX+10, y: iconImageView.frame.origin.y + 25, width: 200, height: 30))
        thLabel.text = "TH208888"
        thLabel.textColor = UIColor.white
        self.view.addSubview(thLabel)
        
        let nameLabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX+10, y: iconImageView.frame.origin.y + 50, width: 200, height: 30))
        nameLabel.text = "(生产育忠)"
        nameLabel.textColor = UIColor.white
        self.view.addSubview(nameLabel)
         
//        let starImageView = UIImageView(frame: CGRect(x: nameLabel.frame.origin.x, y: nameLabel.frame.maxY, width: 100, height: 30))
//        starImageView.backgroundColor = UIColor.yellow
//        self.view.addSubview(starImageView)
        
        let intrudeLabel = UILabel(frame: CGRect(x: iconImageView.frame.origin.x, y: iconImageView.frame.maxY+10, width: 260, height: 30))
        intrudeLabel.font = UIFont.systemFont(ofSize: 20)
        intrudeLabel.text = "购物就上Vcanbuy"
        intrudeLabel.textColor = UIColor.white
//        self.view.addSubview(intrudeLabel)
        
        let tableHeight = UIScreen.main.bounds.height-iconImageView.frame.maxY
        let tableViewFrame = CGRect(x: iconImageView.frame.origin.x, y: intrudeLabel.frame.maxY+10, width: 300, height: tableHeight)
        let tableView = UITableView(frame: tableViewFrame, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = UIColor.clear
        // 去除所有cell的分割线
        tableView.separatorStyle = .none
        
        self.view.addSubview(tableView)
        
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
            print("帮助手册")
            let rootVC = UIApplication.shared.delegate as! AppDelegate
            let HelpVC = HelpViewController()
            rootVC.window?.rootViewController = HelpVC
        }
        else if (indexPath.row == 1){
            print("会员权益")
        }
        else if (indexPath.row == 2){
            print("我的钱包")
        }
        else if (indexPath.row == 3){
            print("我的优惠券")
        }
        else if (indexPath.row == 4){
            print("我的积分")
        }
        else if (indexPath.row == 5){
            print("在线客服")
        }
    }
}
