//
//  MDAppNotice.swift
//
//  Created by midoks on 16/1/24.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import MessageUI

class MDAppNotice: NSObject,MFMailComposeViewControllerDelegate {
    
    let MDAppNoticeCurrentVesion = "MDAppNoticeCurrentVesion"
    let MDAppNoticeRateCurrentVesion = "MDAppNoticeRateCurrentVesion"
    let MDAppNoticeFirstUseDate = "MDAppNoticeFirstUseDate"
    let MDAppNoticeUseCount = "MDAppNoticeUseCount"
    let MDAppNoticeReminderRequestDate = "MDAppNoticeReminderRequestDate"
    
    private static var instance:MDAppNotice?
    
    //应用ID
    var _appId:String?
    //几天后提示(天)
    private var _daysUnitilPormpt:Double = 3.0
    //使用次数
    private var _useUnitilPormpt:Int = 10
    //时间间隔(天)
    private var _timeBeforeReminding:Double = 1.0
    //调试模式
    private var _debug:Bool = false
    
    private let _userDefaults = UserDefaults.standard
    
    //Mark: - 实例化 -
    static func singleton() -> MDAppNotice {
        if((instance == nil)){
            instance = MDAppNotice()
        }
        return instance!
    }
    
    deinit {
        _userDefaults.synchronize()
    }
    
    //MARK: - Private Methods -
    //获取当前的视图 -
    private func getCurrentVc() -> UIViewController{
        let window = UIApplication.shared.keyWindow
        return (window?.rootViewController)!
    }
    
    
    
    //意见反馈 (work on real device)
    private func adviseMailMe(){
        let mail = MFMailComposeViewController()
        
        if mail.isAccessibilityElement {
            
            mail.mailComposeDelegate = self
            mail.setToRecipients(["midoks@163.com"])
            mail.setSubject("GitHubStar-吐槽")
            mail.setMessageBody("", isHTML: false)
            
            let vc = self.getCurrentVc()
            vc.present(mail, animated: true) { () -> Void in
            }
        }
    }
    
    //去评分 (work on real device)
    private func goAppScore(){
        let app_id = self._appId!
        let score_url = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id="+app_id+"&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
        
        let appAddr:NSURL = NSURL(string: score_url)!
        UIApplication.shared.openURL(appAddr as URL)
    }
    
    
    //MARK: - Public Methods -
    //设置应用ID
    func setAppId(appId:String){
        self._appId = appId
    }
    
    //设置debug
    func setDebug(status:Bool){
        self._debug = status
    }
    
    //设置多少天后,可以是使用
    func setDaysUnitilPormpt(daysUnitilPormpt:Double){
        self._daysUnitilPormpt = daysUnitilPormpt
    }
    
    //设置提醒次数
    func setUseUnitilPormpt(useUnitilPormpt:Int){
        self._useUnitilPormpt = useUnitilPormpt
    }
    
    //设置上次显示到现在显示，至少要间隔多久
    func setTimeBeforeReminding(timeBeforeReminding:Double){
        _timeBeforeReminding = timeBeforeReminding
    }
    
    //展示提示
    private func showView(){
        let appNotice = UIAlertController(title: "给我评分", message: "喜欢我就给我个好评吧，我会继续努力做的更好!", preferredStyle: .alert)
        
        let goodNotice = UIAlertAction(title: "去评价", style: UIAlertActionStyle.default) { (info) -> Void in
            self.goAppScore()
        }
        appNotice.addAction(goodNotice)
        
        let badNotice = UIAlertAction(title: "我要吐槽", style: .default) { (info) -> Void in
            self.adviseMailMe()
        }
        appNotice.addAction(badNotice)
        
        let cancel = UIAlertAction(title: "不，谢谢", style: UIAlertActionStyle.cancel, handler: nil)
        appNotice.addAction(cancel)
        
        let vc = self.getCurrentVc()
        //vc.automaticallyAdjustsScrollViewInsets = false
        vc.present(appNotice, animated: true) { () -> Void in
            
        }
    }
    
    //增加用户次数
    private func initAppData(){
        
        var appVersion = _userDefaults.string(forKey: MDAppNoticeCurrentVesion)
        let appCurrentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        
        if appVersion == nil {
            appVersion = appCurrentVersion
            _userDefaults.set(appVersion, forKey: MDAppNoticeCurrentVesion)
        }
        
        if appVersion == appCurrentVersion {
            
            //记录时间
            var timeInterval = _userDefaults.double(forKey: MDAppNoticeFirstUseDate)
            if timeInterval == 0 {
                timeInterval = NSDate(timeIntervalSinceNow: 0).timeIntervalSince1970
                _userDefaults.set(timeInterval, forKey: MDAppNoticeFirstUseDate)
            }
            
        } else {
            //init
            _userDefaults.set(appCurrentVersion, forKey: MDAppNoticeCurrentVesion)
            _userDefaults.set(1, forKey: MDAppNoticeUseCount)
            _userDefaults.set(NSDate(timeIntervalSinceNow: 0).timeIntervalSince1970, forKey: MDAppNoticeFirstUseDate)
            _userDefaults.set(0, forKey: MDAppNoticeReminderRequestDate)
        }
        
    }
    
    func appNoticeHaveMet() -> Bool {
        
        if self._debug {
            return true
        }
        
        let dateFirstLaunch = _userDefaults.double(forKey: MDAppNoticeFirstUseDate)
        let timeUntilRate = 60*60*24*self._daysUnitilPormpt
        let nowTimeLaunch = NSDate(timeIntervalSinceNow: 0).timeIntervalSince1970
        
        if ((nowTimeLaunch - dateFirstLaunch) < timeUntilRate) {
            return false
        }
        
        let useCount = _userDefaults.integer(forKey: MDAppNoticeUseCount)
        if useCount > self._useUnitilPormpt {
            return false
        }
        
        let reminderRequestDate = _userDefaults.double(forKey: MDAppNoticeReminderRequestDate)
        let nowRequestDate = NSDate(timeIntervalSinceNow: 0).timeIntervalSince1970
        let sepDate = 60*60*24*self._timeBeforeReminding
        
        
        //print(nowRequestDate - reminderRequestDate)
        //print(sepDate)
        
        if (nowRequestDate - reminderRequestDate) < sepDate {
            return false
        }
        _userDefaults.set(nowRequestDate, forKey: MDAppNoticeReminderRequestDate)
        
        
        return true
    }
    
    //增加使用数次
    private func addUseCount(){
        
        //增加使用次数
        var useCount = _userDefaults.integer(forKey: MDAppNoticeUseCount)
        useCount = useCount + 1
        _userDefaults.set(useCount, forKey: MDAppNoticeUseCount)
        
        if self._debug {
            print("MDAppNotice Use count: \(useCount)")
        }
    }
    
    private func incrementAndRate(){
        self.initAppData()
        
        if self.appNoticeHaveMet() {
            
            self.addUseCount()
            self.showView()
        }
    }
    
    //开始
    func appLaunched(){
        
        DispatchQueue.global().async {
            if self._debug {
                self.showView()
            } else {
                self.incrementAndRate()
            }
        }
    
    }
    
}
