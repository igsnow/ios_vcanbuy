//
//  PwdViewController.swift
//  ios_vcanbuy
//
//  Created by 张志勇 on 2020/8/4.
//  Copyright © 2020 vcanbuy. All rights reserved.
//

import UIKit

class PwdViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        
       

        
    }
    
    @objc func backBtnAction() {
        print("click back button")
        let rootVC = UIApplication.shared.delegate as! AppDelegate
        let RootVC = RootViewController()
        rootVC.window?.rootViewController = RootVC
    }

}

