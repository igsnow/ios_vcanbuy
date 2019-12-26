//
//  GuideController.swift
//  ios_vcanbuy
//
//  Created by 张志勇 on 2019/12/26.
//  Copyright © 2019 vcanbuy. All rights reserved.
//

import UIKit

class GuideController: UIViewController{
    
    
    
    //页面数量
    let numOfPages = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = self.view.bounds
        //scrollView的初始化
        let scroll = UIScrollView()
        scroll.frame = self.view.bounds
        
        //为了能让内容横向滚动，设置横向内容宽度为3个页面的宽度总和
        scroll.contentSize = CGSize(width:frame.size.width * CGFloat(numOfPages),
                                    height:frame.size.height)
        
        
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        
        
        
        for i in 0..<numOfPages{
            let img1 = UIImageView(image: UIImage(named:"image\(i+1)"))
            img1.frame = CGRect(x:frame.size.width*CGFloat(i), y:CGFloat(0),
                                width:frame.size.width, height:frame.size.height)
            scroll.addSubview(img1)
        }
        
        let button = UIButton()
        button.frame = CGRect(x:frame.size.width*2.6, y:frame.size.height*0.9,
                              width:frame.size.width/2, height:frame.size.height/8)
        button.setImage(UIImage(named:"next"), for: .normal)
        scroll.addSubview(button)
        button.addTarget(self, action:#selector(tapped), for:.touchUpInside)
        
        self.view.addSubview(scroll)
        
        
        
    }
    
    @objc func tapped(){
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "VC") as! ViewController
        self.present(vc, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
