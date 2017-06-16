//
//  SearchViewController.swift
//  EampleApp
//
//  Created by midoks on 15/7/28.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit
class SearchViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate {

    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        
        
        let search = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.95, height: 40))
        search.showsCancelButton = true
        
        search.backgroundColor = UIColor.clear
        search.placeholder  = "搜索"
        search.delegate     = self

        search.becomeFirstResponder()
        self.view.addSubview(search)
        
        let leftNavButtom   = UIBarButtonItem(customView: search)
        self.navigationItem.leftBarButtonItem = leftNavButtom
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        let top = searchBar.subviews[0]
        
        for l:UIView in top.subviews {
            if(l.isKind(of: UIButton.self)){
                let b = l as! UIButton
                b.setTitle("取消", for: UIControlState())
                b.setTitle("取消", for: UIControlState.reserved)
            }
        
        }
        return true
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("搜索")
        
        searchBar.resignFirstResponder()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        print("取消")
        searchBar.resignFirstResponder()
        
        self.navigationController?.popToRootViewController(animated: true)
        close()
    }
    
    //TextField按返回键的反应
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //关闭
    func close(){
        self.dismiss(animated: false) { () -> Void in
            //print("close")
        }
    }
    
}
