//
//  MainViewController.swift
//  MovieSSS
//
//  Created by midoks on 15/7/18.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, PictureSwitchingDelegate, UIScrollViewDelegate, UISearchBarDelegate {
    
    var main: UIScrollView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.title = "电影"
        
        //self.view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        self.view.backgroundColor = UIColor.whiteColor()
        
        let search = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width * 0.3, height: 40))
        search.placeholder = "搜索"
        search.delegate = self
        
        let leftButton = UIBarButtonItem(customView: search)
        self.navigationItem.leftBarButtonItem = leftButton
        
        
        //打印项目目录
        print("\(NSHomeDirectory())")
        
        //        mThreadTool.mOperation { () -> () in
        //            print("async")
        //        }
        
        initMain()
        
        //图片切换
        initImageSwitching()
    }
    
    func initMain(){
        
        //print(self.view.frame.height)
        //print(self.tabBarController?.tabBar.frame.height)               //tabbar高度
        //print(self.navigationController?.navigationBar.frame.height)    //导航高度
        //print(UIApplication.sharedApplication().statusBarFrame.height)  //状态高度
        //print(480-49-44-20)
        
        
        main = UIScrollView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        main!.contentSize = CGSizeMake(self.view.frame.width, 387)
        main!.backgroundColor = UIColor.whiteColor()
        main!.showsVerticalScrollIndicator = true
        main!.showsHorizontalScrollIndicator = false
        main!.scrollEnabled = true
        main!.delegate = self

        self.view.addSubview(main!)
    }
    
    
    //MARK: - 图片切换初始化 -
    func initImageSwitching(){
        let imageArray: [UIImage!] = [
            UIImage(named: "img_switching_first.jpg"),
            UIImage(named: "img_switching_second.jpg"),
            UIImage(named: "img_switching_third.jpg")]
        let imageSwitching = PictureSwitching(frame: CGRectMake(0, 0, self.view.frame.size.width, 200), imageArray:imageArray)
        imageSwitching.backgroundColor = UIColor.orangeColor()
        imageSwitching.delegate = self
        
        //self.automaticallyAdjustsScrollViewInsets = false
        self.main!.addSubview(imageSwitching)
    }
    
    //MARK: - 图片切换代理事件 -
    func PictureSwitchingEndScrolling(currentIndex: Int) {
        print("EndScrolling")
        print(currentIndex)
    }
    
    func PictureSwitchingTap(tapIndex: Int) {
        print("tap")
        print(tapIndex)
    }
    
    
    //MARK: - 当点击搜索时 -
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        let u = SearchViewController()
        let uNav = UINavigationController(rootViewController: u)
        self.presentViewController(uNav, animated: false) { () -> Void in
            print("Search Page")
        }
        return true
    }
    
}
