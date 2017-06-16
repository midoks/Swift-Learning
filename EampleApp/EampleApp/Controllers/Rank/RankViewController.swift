//
//  RankViewController.swift
//  MovieSSS
//
//  Created by midoks on 15/7/19.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit

class RankViewController: UIViewController, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        self.title = "排行榜"
        
        self.initWithView()
    }
    
    func initWithView(){
    
        let YPoint = (self.navigationController?.navigationBar.frame.height)!      //导航高度
            + UIApplication.shared.statusBarFrame.height       //状态高度
        let TopTapHeight = self.view.frame.height
            - (self.tabBarController?.tabBar.frame.height)!                 //tabbar高度
            - (self.navigationController?.navigationBar.frame.height)!      //导航高度
            - UIApplication.shared.statusBarFrame.height       //状态高度
        
        print(self.view.frame)
        print((self.tabBarController?.tabBar.frame.height)!)
        
        //顶部导航视图
        let view = MDTopTapView(frame: CGRect(x: 0, y: YPoint, width: self.view.frame.width, height: TopTapHeight))
        self.view.addSubview(view)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
