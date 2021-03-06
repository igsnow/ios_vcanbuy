//
//  AdvertisingViewController.swift
//  ios_vcanbuy
//
//  Created by 张志勇 on 2019/12/27.
//  Copyright © 2019 vcanbuy. All rights reserved.
//

import UIKit

class SplashController: UIViewController {
    @IBOutlet weak var bigImg: UIImageView!
    @IBOutlet var timeButton: UIButton!
    // 倒计时5s
    private var time:TimeInterval = 5.0
    
    private var cuntdownTimer:Timer?
    
    override func viewWillAppear(_ animated: Bool) {
        print("load splash image")
        let frame = self.view.bounds
        
        // 获取网络图片
//        let urlStr = NSURL(string: "https://res.vcanbuy.com/misc/93b2c9fbb3401e66e29a345b5bff85bf.png")
//        let request = NSMutableURLRequest(url: urlStr! as URL);
//        // 设置缓存策略，有缓存使用缓存，无缓存请求服务器
//        request.cachePolicy = .returnCacheDataElseLoad
//        let cache = URLCache.shared;
//        let response = cache.cachedResponse(for: request as URLRequest);
//        if(response == nil){
//            print("no image cache");
//            let data = NSData(contentsOf: urlStr! as URL)
//            let image = UIImage(data: data! as Data)
//            let imageView = UIImageView(image: image)
//            imageView.frame = CGRect(x:frame.size.width*CGFloat(0), y:CGFloat(0),
//                                     width:frame.size.width, height:frame.size.height)
//            self.view.addSubview(imageView)
//        }else{
//            print("has image cache");
//            let image = UIImage(data: (response?.data)!)
//            let imageView = UIImageView(image: image)
//            imageView.frame = CGRect(x:frame.size.width*CGFloat(0), y:CGFloat(0),
//                                     width:frame.size.width, height:frame.size.height)
//            self.view.addSubview(imageView)
//        }
        
        let image = UIImage(named: "splash.png")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x:frame.size.width*CGFloat(0), y:CGFloat(0),
                                 width:frame.size.width, height:frame.size.height)
        self.view.addSubview(imageView)
        
        
        // 给闪图底部添加logo图
        let imgfile = "logo"
        let logoImg = UIImage(named:"\(imgfile)")
        let logoView = UIImageView(image: logoImg)
        let logoFrame = logoView.bounds
        // 水平居中
        logoView.frame = CGRect(x: CGFloat(frame.size.width - logoFrame.size.width * 1.5) / CGFloat(2), y:frame.size.height - 100,
                                width:logoFrame.size.width * 1.5, height:logoFrame.size.height * 1.5)
        self.view.addSubview(logoView)
        
        // 添加右上角倒计时按钮
        timeButton = UIButton.init(frame: CGRect.init(x:frame.size.width-70 , y: 28, width: 55, height: 25))
        timeButton.setTitle("5s skip", for: .normal)
        timeButton.backgroundColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 0.85)
        timeButton.setTitleColor(UIColor.white, for: .normal)
        timeButton.clipsToBounds = true
        timeButton.layer.cornerRadius = 12
        timeButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        timeButton.addTarget(self, action: #selector(closeGuide), for: .touchUpInside);
        self.view.addSubview(timeButton);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("load view")
        // 启动图延长800毫秒后再加载闪图，不然系统默认时间太短，感觉直接进入闪图了
        Thread.sleep(forTimeInterval: 0.8)

        // Do any additional setup after loading the view.
        
        // 倒计时
        cuntdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)

    }
    
    @objc func updateTime(){
        time -= 1
        timeButton.setTitle(String(format:"%.fs skip",time), for: .normal)
        print("countdown time: ",time)
        if(self.time <= 0.0){
            self.cuntdownTimer?.invalidate()
            self.loadPage()
        }
    }
    
    // 点击点击按钮直接跳转到首页或者引导页
    @objc func closeGuide(){
        // 如果点击跳过按钮使定时器失效，避免内存泄漏
        self.cuntdownTimer?.invalidate()
        self.loadPage()
    }
    
    func loadPage() -> Void{
        let rootVC = UIApplication.shared.delegate as! AppDelegate
        // 根据是否是第一次启动加载引导页还是直接跳转到首页
        if (!(UserDefaults.standard.bool(forKey: "first"))) {
            UserDefaults.standard.set(true, forKey:"first")
            print("is first launch")
            let guideVC = GuideController()
            rootVC.window?.rootViewController  = guideVC;
        }else{
            print("not first launch")
            let mainController = RootViewController()
            rootVC.window?.rootViewController = mainController
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
