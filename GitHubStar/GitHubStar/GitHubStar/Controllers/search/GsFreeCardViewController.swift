//
//  GsFreeCardViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/2/8.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

//自由号管理
class GsFreeCardViewController: GsViewController, UITableViewDataSource, UITableViewDelegate {
  

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        return cell
    }


    var _tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "自由号"
        
        _tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.plain)
        _tableView?.dataSource = self
        _tableView?.delegate = self
        
        self.view.addSubview(_tableView!)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    //Mark: - UITableViewDataSource -
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        }
        return 0
    }
    
    private func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        
        if indexPath.section == 0 {
            
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                cell.textLabel?.text = "新鲜事"
                cell.accessoryType = .disclosureIndicator
            }
            
        } else if indexPath.section == 2 {
            
            if indexPath.row == 0 {
                cell.textLabel?.text = "自由号"
                cell.accessoryType = .disclosureIndicator
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        print("设置")
    }
}
