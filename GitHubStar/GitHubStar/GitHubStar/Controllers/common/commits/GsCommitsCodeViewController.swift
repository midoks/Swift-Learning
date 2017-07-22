//
//  GsCodeViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/5/5.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsCommitsCodeViewController: GsWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setUrlData(data:JSON){
        
        let tmpFileArr = data["filename"].stringValue.components(separatedBy: "/")
    
        self.asynTask {
            self.title = tmpFileArr[tmpFileArr.count - 1]
            print(data["patch"].stringValue)
            self.loadCommitsData(data: data["patch"].stringValue)
        }
    }
}
