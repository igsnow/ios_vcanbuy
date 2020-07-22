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

        self.view.backgroundColor = UIColor.white
        
        // 返回首页按钮
        let backBtn:UIButton = UIButton(frame: CGRect(x: 0, y: 50, width: 50, height: 30))
        backBtn.backgroundColor = UIColor.orange
        backBtn.setTitle("Back", for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        self.view.addSubview(backBtn)
        
        let frame = self.view.bounds
        print(frame)
        
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
        要么你狗熊到底，孬种到底，你很真实，表里如一，也能受人尊重，因为大家都喜欢弱者。在弱者身边能显出你的强大和优势，你会干得更有劲。而在强者身边只会显出你的弱小，你会感到自卑。
        就像你们在万行身边感到自卑一样。如果你转变心念，像万行一样努力十年、二十年，你也会成为强者。我希望你们都有这样的勇气。
        不敢做老虎，你就做绵羊。所以绵羊就是绵羊，老虎就是老虎，宝马就是宝马，桑塔纳就是桑塔纳，它们的本质是不一样的。
        绵羊的活法是对的，老虎的活法也是对的；桑塔纳的价格是合理的，宝马的价格也是合理的。
        所以，我是绵羊，就亮出我的风格；我是老虎，也要亮出我的风格，让你们看清楚，我从不掩饰。
        我经常告诉大家我就是这个东西，不需要什么包装，你喜欢这个东西就捡回家，不喜欢就不要动它，不要去批判它。
        一个人怎么过都是一生，胆小怕事，贪生怕死，做事前怕狼后怕虎，死要面子，这样活着是一辈子；老子天下第一，什么来了都不怕，都大胆去迎接，放开手脚去干，也是活一辈子，而且还活得很爽快。

        """
        label.textColor = UIColor.black
//        label.backgroundColor  = UIColor.green
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

