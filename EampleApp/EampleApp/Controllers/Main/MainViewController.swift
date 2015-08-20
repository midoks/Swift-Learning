//
//  MainViewController.swift
//  MovieSSS
//
//  Created by midoks on 15/7/18.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, PictureSwitchingDelegate,
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
        //initTableView()
    }
    
    //MARK: - 初始化滚动视图 -
    func initMain(){
        self.mainSubviewCurrentHeight = 0
        self.mainHeight = 0
        self.mainHeight = self.getMainHeight()

        main = UIScrollView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        main!.contentSize = CGSizeMake(self.view.frame.width, self.mainHeight!)
        main!.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        main!.showsVerticalScrollIndicator = true
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
        self.mainSubviewCurrentHeight = self.mainSubviewCurrentHeight! + 100
        self.setMainHeight(self.mainSubviewCurrentHeight!)
        
        
        
        let viewIconWidth = self.view.frame.width / 4
        let viewIconHeight = 70.0

        
        let menu = UIView(frame: CGRect(x: 0, y: pos, width: self.view.frame.width, height: 100))
        //menu.backgroundColor = UIColor.blueColor()
        
        
        //print(viewIconWidth)
        
        for(var i=0; i<4; i++){
            let menuIconView = UIView(frame: CGRect(x: viewIconWidth * CGFloat(i), y: 0, width: viewIconWidth, height: CGFloat(viewIconHeight)))
            //menuIconView.backgroundColor = UIColor.greenColor()
            menu.addSubview(menuIconView)
         
         
            let menuIconButton = UIButton(frame: CGRect(x: 0, y: 0, width: viewIconWidth, height: 58))
            menuIconButton.center = CGPoint(x: viewIconWidth/2, y: CGFloat(viewIconHeight/2))
            menuIconButton.backgroundColor = UIColor.whiteColor()
            
            menuIconButton.setTitle("测试", forState: UIControlState.Normal)
            menuIconButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            menuIconButton.tintColor = UIColor.grayColor()
            
            let bgImage = self.imageWithColor(UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1),
                size: CGSize(width: 58, height: 58))

            menuIconButton.setBackgroundImage(bgImage, forState: UIControlState.Highlighted)
            //menuIconButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Application)
            
            
            menuIconButton.addTarget(self, action: Selector("t:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            
            
//            let menuIconImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 58, height: 58))
//            let menuIconImg = UIImage(named: "img_menu_water.png")
//            
//            menuIconImgView.frame.size.height = menuIconImg!.size.height
//            menuIconImgView.center = CGPoint(x: viewIconWidth/2, y: CGFloat(viewIconHeight/2))
//            menuIconImgView.image = menuIconImg
        
            
            menuIconView.addSubview(menuIconButton)
            
            
//            let menuSpliterLine = UIView(frame: CGRect(x: viewIconWidth * CGFloat(i), y: 0, width: 1, height: 100))
//            menuSpliterLine.backgroundColor = UIColor.grayColor()
//            menu.addSubview(menuSpliterLine)
            
        
            
        }
        
        
        self.main!.addSubview(menu)
    }
    
    func t(sender:UIButton){
        print("tt")
    }
    
    //生成纯色背景
    func imageWithColor(color:UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.height, size.height)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    //MARK: - TableView Init -
    func initTableView(){
        
        let pos = self.mainSubviewCurrentHeight!
        self.mainSubviewCurrentHeight = self.mainSubviewCurrentHeight! + 100
        self.setMainHeight(self.mainSubviewCurrentHeight!)
        
        let transform = CGAffineTransformMakeRotation(-1.5707963)
        
        let initTv = UITableView(frame: CGRect(x: 0, y: 200, width: 100, height: 320),
            style: UITableViewStyle.Plain)
        
        initTv.transform = transform
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
        return 100
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let transform = CGAffineTransformMakeRotation(1.5707963)
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "sign")
        
        
        //cell.textLabel!.textAlignment = NSTextAlignment.Center
        cell.textLabel!.text = "测试"
        
        cell.transform = transform
        
        return cell
    }
    
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
