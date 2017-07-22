//
//  GitHubStarSettingPage.swift
//  GitHubStar
//
//  Created by midoks on 16/1/10.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

class GsSettingViewController: UIViewController {
    
    private var _tableView: UITableView?
    
    init () {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("GsSettingViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = sysLang(key: "Settings")
        self.bindTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _tableView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func bindTableView(){
        
        _tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.grouped)
        _tableView?.dataSource = self
        _tableView?.delegate = self
        
        self.view.addSubview(_tableView!)
        
    }
    
    //删除用户
    func deleteMainUser(){
        self.showAlert(title: "提示", msg: "你确定要删除吗?", success: { () -> Void in
            _ = UserModelList.instance().deleteMainUser()
            self.pop()
            }, fail: { () -> Void in
                self.showTextWithTime(msg: "谢谢你的使用!!!", time: 3)
        })
    }
    
    //删除缓存文件
    func deleteCacheFile(){
        self.showAlert(title: "提示", msg: "清空缓存", success: { () -> Void in
            
            MDCacheImageCenter.removeAllCache()
            ProjectModel.instance().clearAll()
            self.showTextWithTime(msg: "清空中!!!", time: 1, callback: { () -> Void in
                self._tableView?.reloadData()
            })
            
            }, fail: { () -> Void in
        })
    }
    
}


//Mark: - UITableViewDataSource && UITableViewDelegate -
extension GsSettingViewController: UITableViewDataSource, UITableViewDelegate{
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        
        if indexPath.section == 0 {
            
            cell.textLabel!.text = sysLang(key: "Touch ID")
            let touchID = UISwitch(frame: CGRect(x: self.view.frame.size.width-60, y: fabs(cell.frame.size.height-50), width: 50, height: 50))
            touchID.isOn = true
            cell.addSubview(touchID)
            
        } else if indexPath.section == 2 {
            
            if indexPath.row == 0 {
                
                cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: nil)
                cell.textLabel?.text = sysLang(key: "Clear Storage")
                
                cell.detailTextLabel?.text = gitSize(s: MDCacheImageCenter.getCacheSize(), i: 0)
                
                cell.accessoryType = .disclosureIndicator
            }else if indexPath.row == 1 {
                
                cell.textLabel?.text = sysLang(key: "About")
                cell.accessoryType = .disclosureIndicator
            }
            
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                cell.textLabel?.text = sysLang(key: "Language")
                cell.accessoryType = .disclosureIndicator
            }
            
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                
                cell.textLabel?.text = sysLang(key: "Login Out")
                cell.textLabel?.textAlignment = .center
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if indexPath.section == 2 {
            
            if indexPath.row == 0 {
                self.deleteCacheFile()
            } else if indexPath.row == 1 {
                self.push(v: GsSettingAboutViewController())
            }
            
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                let lang = GsSettingLanguageViewController()
                let navLang = UINavigationController(rootViewController: lang)
                self.present(navLang, animated: true, completion: { () -> Void in
                })
            }
            
        } else if indexPath.section == 3 {
            
            if indexPath.row == 0 {
                self.deleteMainUser()
            }
        }
    }
}


