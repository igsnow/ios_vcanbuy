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
    // 延迟5s
    private var time:TimeInterval = 5.0
    
    private var cuntdownTimer:Timer?
    
    override func viewWillAppear(_ animated: Bool) {
        print("load splash image")
        let frame = self.view.bounds
        let imgfile = "splash.jpeg"
        let image = UIImage(named:"\(imgfile)")
        let imgView = UIImageView(image: image)
        imgView.frame = CGRect(x:frame.size.width*CGFloat(0), y:CGFloat(0),
                               width:frame.size.width, height:frame.size.height)
        self.view.addSubview(imgView)
        
        timeButton = UIButton.init(frame: CGRect.init(x:frame.size.width-70 , y: 25, width: 55, height: 25))
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
        // self.view.backgroundColor = UIColor.red
        print("load view")
        // Do any additional setup after loading the view.
        
        // 这里加个延迟参数
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + time){
            print("out time",self.time)
            // 当倒计时走完时跳转页面
            // 这里有个问题，不知是不是bug,当第一次启动时倒计时走到1秒就跳转了，但是后续启动时会走到0秒才会跳转，做了兼容
            if(self.time == 1.0 || self.time == 0.0){
                self.loadPage()
            }
        }
        
        // 倒计时
        cuntdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)

    }
    
    @objc func updateTime(){
        time -= 1
        timeButton.setTitle(String(format:"%.fs skip",time), for: .normal)
    }
    
    // 点击点击按钮直接跳转到首页或者引导页
    @objc func closeGuide(){
        // 如果点击跳过按钮使定时器失效
        self.cuntdownTimer?.invalidate()
        self.loadPage()
    }
    
    func loadPage() -> Void{
         print("in time",self.time)
        let rootVC = UIApplication.shared.delegate as! AppDelegate
        // 根据是否是第一次启动加载引导页还是直接跳转到首页
        if (!(UserDefaults.standard.bool(forKey: "first"))) {
            UserDefaults.standard.set(true, forKey:"first")
            print("is first launch")
            let guideVC = GuideController()
            rootVC.window?.rootViewController  = guideVC;
        }else{
            print("not first launch")
            let mainController = ViewController()
            rootVC.window?.rootViewController = mainController
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
