//
//  GuideController.swift
//  ios_vcanbuy
//
//  Created by 张志勇 on 2019/12/26.
//  Copyright © 2019 vcanbuy. All rights reserved.
//

import UIKit

class GuideController: UIViewController,UIScrollViewDelegate {
    
    //页面数量
    var numOfPages = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = self.view.bounds
        // scrollView的初始化
        let scrollView = UIScrollView()
        scrollView.frame = self.view.bounds
        scrollView.delegate = self
        // 为了能让内容横向滚动，设置横向内容宽度为3个页面的宽度总和
        scrollView.contentSize = CGSize(width:frame.size.width * CGFloat(numOfPages),
                                        height:frame.size.height)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        for i in 1...numOfPages{
            let imgfile = "GUIDE-\(Int(i)).png"
            let image = UIImage(named:"\(imgfile)")
            let imgView = UIImageView(image: image)
            imgView.frame = CGRect(x:frame.size.width*CGFloat(i - 1), y:CGFloat(0),
                                   width:frame.size.width, height:frame.size.height)
            scrollView.addSubview(imgView)
            if i == numOfPages {
                let button = UIButton.init(frame: CGRect.init(x:CGFloat(frame.size.width) * CGFloat(i - 1) , y: frame.size.height-150, width: frame.size.width, height: 100))
                button.alpha = 2;
                button.backgroundColor=UIColor.white;
                button.addTarget(self, action: #selector(closeGuide), for: .touchUpInside);
                scrollView.addSubview(button);
            }
        }
        scrollView.contentOffset = CGPoint.zero
        self.view.addSubview(scrollView)
    }
    
    // 点击第四张图的按钮跳转到首页
    @objc func closeGuide(){
        let rootVC = UIApplication.shared.delegate as! AppDelegate
        let mainController = ViewController()
        rootVC.window?.rootViewController = mainController
    }
}
