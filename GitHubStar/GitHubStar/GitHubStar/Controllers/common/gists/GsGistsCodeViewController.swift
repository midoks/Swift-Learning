//
//  GsGistsCodeViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/5/29.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsGistsCodeViewController: GsWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUrlData(data:JSON){
        //print(data)
        
        let tmpFileArr = data["filename"].stringValue.components(separatedBy: "/")
        
        self.asynTask {
            self.title = tmpFileArr[tmpFileArr.count - 1]
            //print(data["content"].stringValue)
            self.loadCommitsData(data: data["content"].stringValue)
        }
    }

}
