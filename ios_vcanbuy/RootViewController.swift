//
//  RootViewController.swift
//  ios_vcanbuy
//
//  Created by 张志勇 on 2020/7/21.
//  Copyright © 2020 vcanbuy. All rights reserved.
//

import UIKit

// 枚举
enum MenuState {
    case Collapsed // 未显示（收起）
    case Expanding // 展开中
    case Expanded // 展开
}

class RootViewController: UIViewController {

    // 主页导航控制器
    var mainNav: UINavigationController?
    // 主页控制器
    var mainVC: ViewController!

    // 菜单页控制器
    var menuVC: MenuViewController?
    // 菜单当前状态
    var currentState = MenuState.Collapsed {
        /**
        didSet方法：在新的值被设定后立即调用。
        在初始化的时候赋值，是不调用didSet方法的。
        */
        didSet {
            let shouldShowShadow = currentState != .Collapsed
            showShadowForMainViewController(shouldShowShadow)
        }
    }
    
    // 菜单打开后主页在屏幕右侧露出部分的宽度
    let menuViewExpandedOffset:CGFloat = 120.0
    
    // 侧滑菜单黑色半透明遮罩层
    var blackCover: UIView?
    
    // 最小缩放比例
    let minProportion: CGFloat = 0.8
    
// MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化主视图
        let main = ViewController()

        self.mainNav = UINavigationController(rootViewController: main)
        self.view.addSubview((self.mainNav?.view)!)
        
        // 创建mainVC控制器
        mainVC = mainNav!.viewControllers.first as! ViewController!

        
        // 添加leftBarButtonItem
        let leftItemBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let btnImage = UIImage(named: "icon.jpg")
        leftItemBtn.setBackgroundImage(btnImage, for: .normal)
        leftItemBtn.layer.masksToBounds = true
        leftItemBtn.layer.cornerRadius = leftItemBtn.frame.height / 2
        leftItemBtn.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem(customView: leftItemBtn)
        self.mainVC?.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        // 添加拖动手势
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.mainNav?.view.addGestureRecognizer(panGestureRecognizer)
        
        // 单击收起菜单手势
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerClick))
        self.mainNav?.view.addGestureRecognizer(tapGestureRecognizer)

    }
    // 单击收起菜单手势响应
    @objc func tapGestureRecognizerClick() {
        // 如果菜单是展开的点击主页部分则会收起
        if currentState == .Expanded {
            animateMainView(false)
        }
    }
    
    // 拖动手势响应
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // 刚刚开始滑动
            // 判断拖动的方向
            let dragFromLeftToRight = recognizer.velocity(in: view).x > 0
            // 如果刚刚开始滑动的时候还处于主页面，从左向右滑动加入侧面菜单
            if currentState == .Collapsed && dragFromLeftToRight {
                currentState = .Expanding
                // 添加菜单控制器
                addMenuViewController()
            }
            
        case .changed:
            // 正在滑动，则偏移主视图的坐标实现跟随手指位置移动
            let screenWidth = self.view.bounds.size.width
            var centerX = recognizer.view!.center.x + recognizer.translation(in: view).x
            // 页面滑动到最左侧的话就不许继续往左移动
            if centerX < screenWidth/2 {
                centerX = screenWidth/2
            }
            // 计算缩放比例
            var proportion:CGFloat = (centerX - screenWidth/2) / (self.view.bounds.width - menuViewExpandedOffset)
            proportion = 1 - (1 - minProportion) * proportion
            // 执行视差特效
            blackCover?.alpha = (proportion - minProportion) / (1 - minProportion)
            // 主页面滑到最左侧的话就不许继续往左移动
            recognizer.view?.center.x = centerX
            // 拖拽的动画效果
            recognizer.setTranslation(CGPoint.zero, in: view)
            // 缩放主页面
            recognizer.view!.transform =
                CGAffineTransform.init(scaleX: proportion, y: proportion)

        case .ended:
            // 滑动结束，根据滑动是否过半，判断后面时自动展开还是收缩
            let hasMovedhanHalfway = (recognizer.view?.center.x)! > view.bounds.width
            animateMainView(hasMovedhanHalfway)

        default:
            break

        }
    }
    // 显示菜单
    @objc func showMenu() {
        // 如果菜单是展开的则会收起，否则就展开
        if currentState == .Expanded {
            animateMainView(false)
        }
        else {
            addMenuViewController()
            animateMainView(true)
        }
    }
    // 添加菜单控制器
    func addMenuViewController() {
        if menuVC == nil {
            menuVC = MenuViewController()
            // 插入当前视图并置顶
            self.view.insertSubview(menuVC!.view, belowSubview: (self.mainNav?.view)!)
            // 在侧滑菜单之上增加黑色遮罩层，目的是实现视差特效
//            blackCover = UIView(frame: self.view.frame)
            // 和上面一种写法创建UIView一样。注：offsetBy：宽高与父视图一样，只是设置x，y在父视图的偏移量
            blackCover = UIView(frame: self.view.frame.offsetBy(dx: 0, dy: 0))
            blackCover!.backgroundColor = UIColor.black
            self.view.insertSubview(blackCover!, belowSubview: (self.mainNav?.view)!)
        }
    }
    // 执行动画效果
    func animateMainView(_ shouldExpand: Bool) {
        if shouldExpand {
            // 更新当前状态
            currentState = .Expanded
            // 动画
            let mainPosition = view.bounds.size.width * (1 + minProportion / 2) - menuViewExpandedOffset
            doTheAnimate(mainPosition: mainPosition, mainProPortion: minProportion, blackCoverAlpha: 0)
        }
        else {
            doTheAnimate(mainPosition: view.bounds.width/2, mainProPortion: 1, blackCoverAlpha: 1, completion: { (finished) in
                // 动画结束之后更新状态
                self.currentState = .Collapsed
                // 移除左侧视图
                self.menuVC?.view.removeFromSuperview()
                // 释放内存
                self.menuVC = nil
                // 移除黑色遮罩层
                self.blackCover?.removeFromSuperview()
                // 释放内存
                self.blackCover = nil
            })
        }
    }
    // 主页移动动画，黑色遮罩层动画
    func doTheAnimate(mainPosition: CGFloat, mainProPortion: CGFloat, blackCoverAlpha: CGFloat, completion: ((Bool) -> Void)! = nil) {
    
        // usingSpringWithDamping: 若设置为1.0则没有弹簧效果
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.mainNav?.view.center.x = mainPosition
            self.blackCover?.alpha = blackCoverAlpha
            // 缩放主页面
            self.mainNav?.view.transform = CGAffineTransform(scaleX: mainProPortion, y: mainProPortion)

            }, completion: completion)
    }
    // 给主页面边缘添加、取消阴影
    func showShadowForMainViewController(_ shouldShowShadow: Bool) {
        if shouldShowShadow {
            // 需要遮挡不透明度为0.8
            self.mainNav?.view.layer.shadowOpacity = 0.8
        }
        else {
            self.mainNav?.view.layer.shadowOpacity = 0.0
        }
    }
}

