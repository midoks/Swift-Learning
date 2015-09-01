//
//  mThreadTool.swift
//
//  Created by midoks on 15/8/9.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit

class mThreadTool: NSObject {
    
    //GCD 多线程异步方式
    static func mdispatch(callback: ()->() ){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            //调用主线程,更新UI
            callback()
        }
    }

    static func mdispatch(time: UInt64 ,callback: ()->() ){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(time * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            callback()
        }
    }
    
    //NSOperationQueue
    static func mOperation(callback: ()->() ){
        let mOp = NSBlockOperation { () -> Void in
            callback()
        }

        NSOperationQueue().addOperation(mOp)
    }
    
    //NSThread
    static func mThread(){
        //NSThread.detachNewThreadSelector(<#T##selector: Selector##Selector#>, toTarget: <#T##AnyObject#>, withObject: <#T##AnyObject?#>)
        
    }
    

}
