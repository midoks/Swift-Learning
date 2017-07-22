//
//  MDTask.swift
//  GitHubStar
//
//  Created by midoks on 16/5/21.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

class MDTask: NSObject {
    
    static let shareInstance = MDTask()

    
    //let queue = DispatchQueue("com.GitHubStar.MDTask", nil)
    
    //private static var main = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    //static var task = dispatch_queue_create("com.GitHubStar.MDTask", nil)
    
    func asynTaskBack(callback:@escaping ()->Void){
//        self.queue.asynchronously() {
//            callback()
//        }
    }
    
    func asynTaskFront(callback:@escaping ()->Void){
//        dispatch_get_main_queue().asynchronously() {
//            callback()
//        }
    }
    
    class func asyncMainUI( callback:()->Void ){
    
    }

}
