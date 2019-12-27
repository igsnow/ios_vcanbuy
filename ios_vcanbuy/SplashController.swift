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
    //延迟5s
    private var time:TimeInterval = 5.0
    
    private var cuntdownTimer:Timer?
    
    override func viewWillAppear(_ animated: Bool) {
        print("img")
        let frame = self.view.bounds
        let imgfile = "splash.jpeg"
        let image = UIImage(named:"\(imgfile)")
        let imgView = UIImageView(image: image)
        imgView.frame = CGRect(x:frame.size.width*CGFloat(0), y:CGFloat(0),
                               width:frame.size.width, height:frame.size.height)
        self.view.addSubview(imgView)
        
        timeButton = UIButton.init(frame: CGRect.init(x:CGFloat(frame.size.width) * CGFloat(0) , y: frame.size.height-100, width: 80, height: 40))
//        timeButton.alpha = 2;
//        timeButton.backgroundColor=UIColor.green;
        
        timeButton.setTitle("5s skip", for: .normal)
        timeButton.backgroundColor = UIColor.lightGray
        timeButton.setTitleColor(UIColor.white, for: .normal)
        timeButton.clipsToBounds = true
        timeButton.layer.cornerRadius = 20
        timeButton.addTarget(self, action: #selector(closeGuide), for: .touchUpInside);
        self.view.addSubview(timeButton);
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        print("ok")
        // Do any additional setup after loading the view.
        
//                timeButton.setTitle("5s后跳过", for: .normal)
//        timeButton.backgroundColor = UIColor.lightGray
//        timeButton.setTitleColor(UIColor.white, for: .normal)
        //        timeButton.clipsToBounds = true
        //        timeButton.layer.cornerRadius = 20
        
        //这里加个延迟参数
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + time){
            
            let rootVC = UIApplication.shared.delegate as! AppDelegate
            let mainController = ViewController()
//            rootVC.window?.rootViewController = mainController
            
            
//            let sb = UIStoryboard(name:"Main",bundle:nil)
//            let rootVC = sb.instantiateInitialViewController()
//            UIApplication.shared.keyWindow?.rootViewController = rootVC
        }
        
        //倒计时
        cuntdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)

    }
    
    @objc func updateTime(){
        time -= 1
        timeButton.setTitle(String(format:"%.fs skip",time), for: .normal)
    }
    
    // 点击点击按钮直接跳转到首页
    @objc func closeGuide(){
        let rootVC = UIApplication.shared.delegate as! AppDelegate
        let mainController = ViewController()
        rootVC.window?.rootViewController = mainController
    }
    
    //点击直接跳转
    @IBAction func pushAction(_ sender: Any) {
//        let sb = UIStoryboard(name:"Main",bundle:nil)
//        let rootVC = sb.instantiateInitialViewController()
//        UIApplication.shared.keyWindow?.rootViewController = rootVC
        
        
        let rootVC = UIApplication.shared.delegate as! AppDelegate
        let mainController = ViewController()
        rootVC.window?.rootViewController = mainController
        
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
