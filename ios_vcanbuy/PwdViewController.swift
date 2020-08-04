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
                                          y:50,
                                          width: CGFloat(frame.size.width),
                                          height: 50))
        
        titleLabel.text = "Vcanbuy"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "Arial-BoldMT", size: 20)
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)
        
        // 文本
        let label = UILabel(frame:  CGRect(x:30,
                                           y:100,
                                           width: CGFloat(frame.size.width) - 60,
                                           height: CGFloat(frame.size.height) - 150))
        
       let str = """
        一个人要么提得起，要么放得下，最可悲的是既提不起又放不下，犹豫来犹豫去，在中间摇摆不定。但是，往往犹豫的人能找到足够的理由证明他的行为是对的。

        """
        label.textColor = UIColor.black
        label.numberOfLines = 0
        
        //通过富文本来设置行间距
        let paraph = NSMutableParagraphStyle()
        //将行间距设置为28
        paraph.lineSpacing = 15
        paraph.firstLineHeadIndent = 20
        paraph.alignment = .left
        // 溢出省略
        paraph.lineBreakMode = .byTruncatingTail
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15),
                          NSAttributedString.Key.paragraphStyle: paraph]
        label.attributedText = NSAttributedString(string: str, attributes: attributes)
        
        self.view.addSubview(label)
        
    }
    
    @objc func backBtnAction() {
        print("click back button")
        let rootVC = UIApplication.shared.delegate as! AppDelegate
        let RootVC = RootViewController()
        rootVC.window?.rootViewController = RootVC
    }

}

