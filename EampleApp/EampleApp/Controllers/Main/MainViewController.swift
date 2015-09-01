//
//  MainViewController.swift
//  MovieSSS
//
//  Created by midoks on 15/7/18.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, PictureSwitchingDelegate, MDCrossRangeIconDelegate,
UIScrollViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var main: UIScrollView?
    var mainHeight: CGFloat?
    
    //滚动跳,当前的子元素高度
    var mainSubviewCurrentHeight: CGFloat?
    
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
        
        //初始化滚动条
        initMain()
        //图片切换
        initImageSwitching()
        //分类列表
        initCategoryList()
        //横向列表
        initTableView()
    }
    
    //MARK: - 初始化滚动视图 -
    func initMain(){
        self.mainSubviewCurrentHeight = 0
        self.mainHeight = 0
        self.mainHeight = self.getMainHeight()
        
        main = UIScrollView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        main!.contentSize = CGSizeMake(self.view.frame.width, self.mainHeight!)
        main!.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        main!.showsVerticalScrollIndicator = false
        main!.showsHorizontalScrollIndicator = false
        main!.scrollEnabled = true
        main!.delegate = self
        
        
        self.view.addSubview(main!)
    }
    
    //获取滚动视图的高
    func getMainHeight()->CGFloat{
        if(self.mainHeight == 0){
            self.mainHeight = self.view.frame.height
                - (self.tabBarController?.tabBar.frame.height)!                 //tabbar高度
                - (self.navigationController?.navigationBar.frame.height)!      //导航高度
                - UIApplication.sharedApplication().statusBarFrame.height       //状态高度
        }
        return self.mainHeight!
    }
    
    //设置滚动时图的高
    func setMainHeight(height: CGFloat){
        if(self.main!.contentSize.height < height){
            self.main!.contentSize.height = height
        }
    }
    
    //增加滚动视图高度
    func addMainHeight(height: CGFloat){
        self.main!.contentSize.height =  self.main!.contentSize.height + height
    }
    
    //MARK: - 图片切换初始化 -
    func initImageSwitching(){
        
        self.mainSubviewCurrentHeight = 200
        self.setMainHeight(self.mainSubviewCurrentHeight!)
        
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
        //print("EndScrolling")
        //print(currentIndex)
    }
    
    func PictureSwitchingTap(tapIndex: Int) {
        //print("tap")
        //print(tapIndex)
    }
    
    //MARK: - 分类列表 -
    func initCategoryList(){
        let pos = self.mainSubviewCurrentHeight!
        self.mainSubviewCurrentHeight = self.mainSubviewCurrentHeight! + 240 + 5
        self.setMainHeight(self.mainSubviewCurrentHeight!)
        
        //print(pos)
        //print(self.mainSubviewCurrentHeight)
        
        let menu = MDCrossRangeIcon(frame: CGRectMake(0, pos + 5, self.view.frame.width, 240))
        menu.delegate = self
        
        
        let t = UIImage(imageLiteral: "img_menu_qrcode")
        
        menu.addImage(UIImage(named: "img_menu_water.png")!, title: "第一个标题")
        menu.addImage(UIImage(named: "img_menu_water.png")!, title: "第二个标题")
        menu.addImage(UIImage(named: "img_menu_water.png")!, title: "第三个标题")
        menu.addImage(UIImage(named: "img_menu_water.png")!, title: "测试")
        
        menu.addImage(UIImage(named: "img_menu_water.png")!, title: "测试")
        menu.addImage(UIImage(named: "img_menu_water.png")!, title: "测试")
        menu.addImage(UIImage(named: "img_menu_water.png")!, title: "测试")
        menu.addImage(UIImage(named: "img_menu_water.png")!, title: "测试")
        
        menu.addImage(UIImage(named: "img_menu_water.png")!, title: "测试")
        menu.addImage(UIImage(named: "img_menu_water.png")!, title: "测试")
        menu.addImage(UIImage(named: "img_menu_water.png")!, title: "测试")
        menu.addImage(t!, title: "OK")
        
        menu.render()
        self.main!.addSubview(menu)
    }
    
    //MARK: - 分类列表代理 -
    func MDCrossRangeIconTouch(index: Int) {
        //print(index)
        let s = String(index)
        let alertV = UIAlertView(title: "您的结果", message: s, delegate: nil, cancelButtonTitle: "我知道了")
        alertV.show()
    }
    
    //MARK: - TableView Init -
    func initTableView(){
        let pos = self.mainSubviewCurrentHeight!
        self.mainSubviewCurrentHeight = self.mainSubviewCurrentHeight! + 320 + 10
        self.setMainHeight(self.mainSubviewCurrentHeight!)
        
        
        let initTv = UITableView(frame: CGRect(x: 0, y: pos + 5, width: self.view.frame.width, height: 320),
            style: UITableViewStyle.Plain)

        initTv.showsVerticalScrollIndicator = false
        initTv.pagingEnabled = true
        
        initTv.delegate = self
        initTv.dataSource = self
        
        self.main!.addSubview(initTv)
    }
    
    //MARK: - UITableViewDelegate -
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //每组多少行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "sign")
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    
        let viewContent = MainTableShowView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: 60))
        let image = UIImage(imageLiteral: "img_menu_water")!
        
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss.S"
        
        let s = timeFormatter.stringFromDate(date)
        
        
        viewContent.addContent(image,title: "标题",detail: "详情",time: s)
        cell.addSubview(viewContent)
        return cell
    }
    
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //跳到详情页
        let detailed = DetailedViewController()
        self.navigationController?.pushViewController(detailed, animated: true)
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
