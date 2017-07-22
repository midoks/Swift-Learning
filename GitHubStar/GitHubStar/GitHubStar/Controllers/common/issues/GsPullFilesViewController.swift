//
//  GsPullFilesViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/5/7.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsPullFilesViewController: UIViewController {
    
    var _tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initTableView(){
        
        _tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.grouped)
        _tableView?.dataSource = self
        _tableView?.delegate = self
        
        self.view.addSubview(_tableView!)
    }
    
    func setUrlData(data:JSON){
        
        let url = data["diff_url"].stringValue
        //print(data)
        print(url)
        
        
    
    }

}


//Mark: - UITableViewDataSource && UITableViewDelegate -
extension GsPullFilesViewController : UITableViewDelegate, UITableViewDataSource {
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        return cell
    }
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return 1
    }
    
    private func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "home"
        return cell
    }

}
