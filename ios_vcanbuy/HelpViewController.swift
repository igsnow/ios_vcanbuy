//
//  HelpViewController.swift
//  ios_vcanbuy
//
//  Created by 张志勇 on 2020/7/22.
//  Copyright © 2020 vcanbuy. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.green
        self.title = "igsnow"
    
        let backBtn:UIButton = UIButton(frame: CGRect(x: 0, y: 100, width: 50, height: 50))
        backBtn.backgroundColor = UIColor.red
        backBtn.setTitle("点我", for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        self.view.addSubview(backBtn)
        
    }
    
    @objc func backBtnAction() {
        print("click back button")
        let rootVC = UIApplication.shared.delegate as! AppDelegate
        let RootVC = RootViewController()
        rootVC.window?.rootViewController = RootVC
    }

}

