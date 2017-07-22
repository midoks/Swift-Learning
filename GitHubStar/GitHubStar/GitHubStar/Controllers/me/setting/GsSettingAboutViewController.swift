//
//  GsSettingAboutViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/2/20.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import MessageUI

class GsSettingAboutViewController: UIViewController {
    
    var _tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = sysLang(key: "About")
        
        _tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.grouped)
        _tableView?.dataSource = self
        _tableView?.delegate = self
        self.view.addSubview(_tableView!)
        
        
        let tableHeadView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 25, width: self.view.frame.width, height: 50))
        imageView.image = UIImage(named: "welcome")
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        tableHeadView.addSubview(imageView)
        
        _tableView?.tableHeaderView = tableHeadView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Private Methods -

    
    //意见反馈 (work on real device)
    func adviseMailMe(){
        let mail = MFMailComposeViewController()
        
        if mail.isAccessibilityElement {
            mail.mailComposeDelegate = self
            mail.setToRecipients(["midoks@163.com"])
            mail.setSubject("GitHubStar-意见反馈")
            mail.setMessageBody("", isHTML: false)
            self.present(mail, animated: true) { () -> Void in
            }
        }
        //        else {
        //            SystemSettingPage.goMail()
        //        }
    }
    
    //评分地址
    func goAppScore(){
        //暂时未上线,用的别的appid
        let app_id = "1078637806"
        let score_url = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id="+app_id+"&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
        
        let appAddr:NSURL = NSURL(string: score_url)!
        UIApplication.shared.openURL(appAddr as URL)
    }
    
    //欢迎界面
    func goAppWelcome(){
        GuideViewController.setAppFail()
    
        let delegate = UIApplication.shared.delegate
        delegate?.window!!.rootViewController = GuideViewController()
    }
    
}

//MARK: - UITableViewDataSource && UITableViewDelegate -
extension GsSettingAboutViewController: UITableViewDataSource, UITableViewDelegate{
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        return cell
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    private func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        
        if indexPath.row == 0 {
            
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: nil)
            cell.textLabel?.text = sysLang(key: "Version")
            
            let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
            cell.detailTextLabel?.text = version
            
        } else if indexPath.row == 1 {
            cell.textLabel?.text = sysLang(key: "Help & Feedback")
            cell.accessoryType = .disclosureIndicator
        } else if indexPath.row == 2 {
            
            cell.textLabel?.text = sysLang(key: "Rate GitHubStar")
            cell.accessoryType = .disclosureIndicator
        } else if indexPath.row == 3 {
            cell.textLabel?.text = sysLang(key: "Welcome Page")
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if indexPath.row == 1 {
            self.adviseMailMe()
        } else if indexPath.row == 2 {
            self.goAppScore()
        } else if indexPath.row == 3 {
            self.goAppWelcome()
        }
    }
}

//MARK: - MFMailComposeViewControllerDelegate -
extension GsSettingAboutViewController: MFMailComposeViewControllerDelegate{
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        self.dismiss(animated: true) { () -> Void in
            
            //if result == MFMailComposeResultSent {
            //    self.showTextWithTime("反馈成功!!!", time: 2)
            //}
        }
    }
}
