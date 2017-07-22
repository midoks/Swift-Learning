//
//  GsBaseViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/2/11.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

class GsViewController: UIViewController {


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //设置导航栏透明
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        //self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //还原导航栏
        //self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        //self.navigationController?.navigationBar.shadowImage = nil
    }
}
