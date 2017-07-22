//
//  RootViewController.swift
//  GitHubStar
//
//  Created by midoks on 15/11/26.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController {
    
    let Recommend       = GsRecommendViewController()
    var RecommendNav    = GsBaseNavViewController()
    
    
    let Search      = GsSearchViewController()
    var SearchNav   = GsBaseNavViewController()

    let User        = GsMeViewController()
    var UserNav     = GsBaseNavViewController()
    
//    override func viewWillAppear(animated: Bool) {
//        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
//    }

    override func viewDidLoad() {
//        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        super.viewDidLoad()
        
        print(NSHomeDirectory())
        
        MDLangLocalizable.singleton().initSysLang()
        MDLangLocalizable.singleton().setTable(_table: "LaunchScreen")
        //MDLangLocalizable.singleton().debug(true)
        
        //初始数据
        _ = UserModelList.instance()
        _ = ProjectModel.instance()
        self.setTabBars()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func setTabBars(){
    
        //推荐
        RecommendNav    = GsBaseNavViewController(rootViewController: Recommend)
        let RecommendButton = UITabBarItem(title: sysLang(key: "Recommand"), image: UIImage(named: "bar_recommand"), tag: 2)
        //RecommendButton.selectedImage = UIImage(named: "bar_me")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        RecommendNav.tabBarItem = RecommendButton
        
        //查找
        SearchNav   = GsBaseNavViewController(rootViewController: Search)
        let SearchButton = UITabBarItem(title: sysLang(key: "Discover"), image: UIImage(named: "bar_search"), tag: 1)
        SearchNav.tabBarItem = SearchButton
        
        //用户界面
        let UserTabBarItem = UITabBarItem(title: sysLang(key: "Me"), image: UIImage(named: "bar_me"), tag: 0)
        UserNav     = GsBaseNavViewController(rootViewController: User)
        User.tabBarItem = UserTabBarItem
        
        let vc = [
            RecommendNav,
            SearchNav,
            UserNav
        ]
        
        
        Github.instance.initConfig(clientID: "6f073e614d01ec9d3af7", clientSecret: "5d30b5f16bd1020d5acac6c66e01a0afc78a2ed1")
        
        //设置应用
        GitHubApi.instance.initConfig(clientID: "6f073e614d01ec9d3af7", clientSecret: "5d30b5f16bd1020d5acac6c66e01a0afc78a2ed1")
        if self.isLogin() {
            let userData =  UserModelList.instance().selectCurrentUser()
            let token = userData["token"] as! String
            GitHubApi.instance.setToken(token: token)
            
        }
        
        self.setViewControllers(vc, animated: false)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 2 {
            Recommend.refreshData()
        }
    }
    
    
}
