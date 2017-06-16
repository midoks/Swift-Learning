//
//  DetailedViewController.swift
//
//  Created by midoks on 15/8/24.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        self.title = "详情页面"
        //NSLog("详细界面")
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "repo_share"), style: UIBarButtonItemStyle.plain, target:self, action: #selector(self.initShareDNav))
        self.navigationItem.rightBarButtonItem  = rightButton
    }
    
    func initShareDNav(){
        //navigationController?.delegate = self
        //self.navigationItem.rightBarButtonItem?.enabled = false
        
        print("ss")
        print(self.navigationController?.viewControllers.count)
        
        
    }

}
