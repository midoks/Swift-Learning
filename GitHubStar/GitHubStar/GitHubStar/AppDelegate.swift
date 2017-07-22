//
//  AppDelegate.swift
//  GitHubStar
//
//  Created by midoks on 15/11/26.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        
        GitTheme()
        
        if GuideViewController.isFristOpen() {
            self.window?.rootViewController = GuideViewController()
        } else {
            self.window?.rootViewController = RootViewController()
        }
        
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
//    func appWithStat(){
//    
//        //MTA统计
//        MTAConfig.getInstance().debugEnable = false
//        //MTAConfig.getInstance().statEnable = true
//        //MTAConfig.getInstance().crashCallback()
//        MTAConfig.getInstance().appkey = "IF9Z5BPL2W9U"
//        MTAConfig.getInstance().account = "3202088655"
//        //MTAConfig.getInstance().statReportURL = "https://pingma.qq.com/mstat/report"
//        
//        if MTA.startWithAppkey("IF9Z5BPL2W9U", checkedSdkVersion: MTA_SDK_VERSION) {
//            print("MTA Success!!")
//        }
//        
//        let start = BaiduMobStat.defaultStat()
//        let version = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as? String
//        start.shortAppVersion = version
//        start.enableDebugOn = false
//        start.startWithAppId("19a5c9a088")
//    }
    
    func GitTheme(){
    
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        UINavigationBar.appearance().tintColor = UIColor.white
        //UINavigationBar.appearance().setBackgroundImage(imageWithColor(UIColor.primaryColor()), forBarMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        //UINavigationBar.appearance().clipsToBounds = true
        UINavigationBar.appearance().barTintColor =  UIColor.primaryColor()
    }

}

