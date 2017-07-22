//
//  GsSettingLanguageViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/2/15.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

class GsSettingLanguageViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        return cell
    }

    
    var _tableView: UITableView?
    
    
    //系统语言改变
    var currentLang:String = MDLangLocalizable.singleton().currentLanguage()
    var currentSelectedLang:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(self.currentLang)
        
        self.initView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //初始化视图
    func initView(){
        
        self.title = sysLang(key: "Language")
        
        //左边
        let leftButton = UIBarButtonItem(title: sysLang(key: "Cancel"), style: UIBarButtonItemStyle.plain, target: self, action: Selector(("close:")))
        self.navigationItem.leftBarButtonItem  = leftButton

        //右边
        let rightButton = UIBarButtonItem(title: sysLang(key: "Save"), style: UIBarButtonItemStyle.plain, target: self, action: Selector(("save:")))
        self.navigationItem.rightBarButtonItem = rightButton
        
        
        _tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.plain)
        _tableView?.dataSource = self
        _tableView?.delegate = self
        
        self.view.addSubview(_tableView!)
    }
    
    //MARK: - UITableViewDataSource && UITableViewDelegate -
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    private func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        
        let v = self.currentLang
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "简体中文"
            if v.hasPrefix("zh-Hans") {
                cell.accessoryType = .checkmark
            }
            
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "English"
            if v.hasPrefix("en") {
                cell.accessoryType = .checkmark
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let cells = tableView.indexPathsForVisibleRows
        var rowCell = UITableViewCell()
        for i in cells! {
            rowCell = tableView.cellForRow(at: i)!
            rowCell.accessoryType = .none
        }
        
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        cell?.accessoryType = .checkmark
        
        let lang =  cell?.textLabel?.text
        if lang == "English" {
            self.currentSelectedLang = "en"
        } else if lang == "简体中文" {
            self.currentSelectedLang = "zh-Hans"
        }
    }
    
    //MARK: - Private Method -
    
    //设置语言
    func setLang(lang:String) {
        MDLangLocalizable.singleton().setCurrentLanguage(lang: lang)
    }
    
    //关闭
    func close(button: UIButton){
        self.dismiss(animated: true) { () -> Void in
            
        }
    }
    
    //保存当前值
    func save(button: UIButton){
   
        if self.currentSelectedLang != nil {
            MDLangLocalizable.singleton().setCurrentLanguage(lang: self.currentSelectedLang!)
        }
        
        self.dismiss(animated: true) { () -> Void in
            let delegate = UIApplication.shared.delegate
            delegate?.window!!.rootViewController = RootViewController()
            //delegate?.window!!.rootViewController?.tabBarController?.selectedIndex = 2
        }
        
    }
    
}
