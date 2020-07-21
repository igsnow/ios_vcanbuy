//
//  MainViewController.swift
//  ios_vcanbuy
//
//  Created by 张志勇 on 2020/7/21.
//  Copyright © 2020 vcanbuy. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var searchBar: UISearchBar?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.setupNav()
        self.setupSearchBar()
    }
    
    func setupSearchBar() {
        // 创建UISearchBar
        let searchBar = UISearchBar(frame: CGRect(x: 20, y: 64+10, width: UIScreen.main.bounds.width-2*20, height: 50))
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "搜索"
        searchBar.delegate = self
        
        self.view.addSubview(searchBar)
        self.searchBar = searchBar
    }
    
    func setupNav() {
        // 创建UISegmentedControl
        let items = ["消息", "电话"]
        let segmentedControl = UISegmentedControl(items: items)
        // 设置默认选中
        segmentedControl.selectedSegmentIndex = 0
        // 设置点击事件
        segmentedControl.addTarget(self, action: #selector(segmentedControlClick(_ :)), for: .valueChanged)
        self.navigationItem.titleView = segmentedControl
    }
    @objc func segmentedControlClick(_ segmentedControl: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            print("选中了消息")
        }
        else {
            print("选中了电话")
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar?.resignFirstResponder()
    }
}
extension MainViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("搜索条件：\(String(describing: searchBar.text))")
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
