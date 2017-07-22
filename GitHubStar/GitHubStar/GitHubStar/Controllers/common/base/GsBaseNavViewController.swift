//
//  GsBaseNavViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/5/15.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

class GsBaseNavViewController: UINavigationController {

    var isAnimation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer!.delegate = nil
    }
    
    lazy var backBtn: UIButton = {
        let backBtn = UIButton(type: UIButtonType.custom)
        backBtn.setImage(UIImage(named: "page_back"), for: .normal)
        backBtn.titleLabel?.isHidden = true
        backBtn.addTarget(self, action: #selector(self.backBtnClick), for: .touchUpInside)
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        let btnW: CGFloat = UIScreen.main.bounds.size.width > 375.0 ? 50 : 44
        backBtn.frame = CGRect(x: 0, y: 0, width: btnW, height: 40)
        
        return backBtn
    }()
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        //print(childViewControllers.count)
        if childViewControllers.count > 0 {
            viewController.navigationItem.hidesBackButton = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    func backBtnClick() {
        popViewController(animated: isAnimation)
    }

}
