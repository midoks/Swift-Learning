//
//  GsRepoSourceCodeViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/4/10.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

class GsRepoSourceCodeViewController: GsWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.beginLoadProgressViewTimer()
    }
    
    func setUrlData(url:String){
        GitHubApi.instance.webGet(absoluteUrl: url) { (data, response, error) -> Void in
            
            if data != nil {
                let _dataJson = self.gitJsonParse(data: data!)
                //print(_dataJson)
                let content = GitHubApi.instance.dataDecode64(strVal: _dataJson["content"].stringValue)
                self.loadSourceData(data: content)
            }
        }
    }
}
