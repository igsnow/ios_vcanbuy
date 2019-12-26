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
        //scrollView的初始化
        let scrollView = UIScrollView()
        scrollView.frame = self.view.bounds
        scrollView.delegate = self
        //为了能让内容横向滚动，设置横向内容宽度为3个页面的宽度总和
        scrollView.contentSize = CGSize(width:frame.size.width * CGFloat(numOfPages),
                                        height:frame.size.height)
        print("\(frame.size.width*CGFloat(numOfPages)),\(frame.size.height)")
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        for i in 0..<numOfPages{
            let imgfile = "GUIDE-\(Int(i+1)).png"
            print(imgfile)
            let image = UIImage(named:"\(imgfile)")
            let imgView = UIImageView(image: image)
            imgView.frame = CGRect(x:frame.size.width*CGFloat(i), y:CGFloat(0),
                                   width:frame.size.width, height:frame.size.height)
            scrollView.addSubview(imgView)
        }
        scrollView.contentOffset = CGPoint.zero
        self.view.addSubview(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrolled:\(scrollView.contentOffset)")
        let twidth = CGFloat(numOfPages-1) * self.view.bounds.size.width
        //如果在最后一个页面继续滑动的话就会跳转到主页面
        if scrollView.contentOffset.x > twidth {
            //            let mainStoryboard = UIStoryboard(name:"Main", bundle:nil)
            //            let viewController = mainStoryboard.instantiateInitialViewController()
            //           self.present(MainVC(), animated: true, completion: nil)
            let rootVC = UIApplication.shared.delegate as! AppDelegate
            let mainController = ViewController()

            rootVC.window?.rootViewController = mainController
        }
    }
}
