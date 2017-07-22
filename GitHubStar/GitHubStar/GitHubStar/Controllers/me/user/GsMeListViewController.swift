//
//  GsMeListViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/5/7.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON


class GsMeListViewController: UIViewController {
    
    var _tableView: UITableView?
    var _tableData: [[String:AnyObject]]?
    
    let cellIdentifier = "GsMeListViewController"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.asynTask {
            
            self.initData()
            self._tableView?.frame = self.view.frame
            //print(self.view.frame)
            self._tableView?.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = sysLang(key: "Users List")
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.addUser))
        self.navigationItem.rightBarButtonItem  = rightButton
        
        self.initData()
        self.initTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initData(){
        
        let user = UserModelList.instance().selectAllUser()
        //print(user)
        self._tableData = user as? [[String:AnyObject]]
    }
    
    private func initTableView(){
        
        _tableView = UITableView(frame: self.view.frame, style: .plain)
        _tableView?.register(GsUsersIconTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        _tableView?.dataSource = self
        _tableView?.delegate = self
        
        self.view.addSubview(_tableView!)
    }
    
    func addUser(){
        
        let loginPage = UINavigationController(rootViewController: GsLoginViewController())
        self.show(loginPage, sender: nil)
    }
}


//Mark: - UITableViewDataSource && UITableViewDelegate -
extension GsMeListViewController:UITableViewDataSource, UITableViewDelegate{
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if _tableData != nil {
            return _tableData!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if _tableData != nil {
            
            let indexData = _tableData![indexPath.row]
            let indexJson = JSON.parse(indexData["info"] as! String)
            //print(indexData)
            //print(indexJson)
        
            let cell = GsUsersIconTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
            cell.textLabel?.text = indexJson["login"].stringValue
            cell.imageView?.MDCacheImage(url: indexJson["avatar_url"].stringValue, defaultImage: "github_default_28")

            let main = indexData["main"] as! Int
            if main == 1 {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .disclosureIndicator
            }
            return cell
        }
        
        let cell = GsUsersIconTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        cell.textLabel?.text = "home"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let indexData = _tableData![indexPath.row]
    
        let id = indexData["id"] as! Int
        _ = UserModelList.instance().updateMainUserById(id: id)
        
        let userData =  UserModelList.instance().selectCurrentUser()
        let token = userData["token"] as! String
        GitHubApi.instance.setToken(token: token)
        
        //indexData
        _tableView?.reloadData()
    }
    
}

extension GsMeListViewController{
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //print("ok")
        
        let indexData = _tableData![indexPath.row]
        let id = indexData["id"] as! Int
        
        _ = UserModelList.instance().deleteUserById(id: id)
        //indexData
        _tableView?.reloadData()
    }

}

extension GsMeListViewController{
    
    func getNavBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height)!
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator){
        super.viewWillTransition(to: size, with: coordinator)
     
        self._tableView?.frame.size = size
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            
        }) { (UIViewControllerTransitionCoordinatorContext) in
            
        }
    }
}
