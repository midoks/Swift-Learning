//
//  mThreadTool.swift
//
//  Created by midoks on 15/8/9.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit

class mThreadTool: NSObject {
    
    //GCD 多线程异步方式
    static func mdispatch(_ callback: @escaping ()->() ){
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async { () -> Void in
            //调用主线程,更新UI
            callback()
        }
    }

    static func mdispatch(_ time: UInt64 ,callback: @escaping ()->() ){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(time * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) { () -> Void in
            callback()
        }
    }
    
    //NSOperationQueue
    static func mOperation(_ callback: @escaping ()->() ){
        let mOp = BlockOperation { () -> Void in
            callback()
        }

        OperationQueue().addOperation(mOp)
    }
    
    //NSThread
    static func mThread(){
        //NSThread.detachNewThreadSelector(<#T##selector: Selector##Selector#>, toTarget: <#T##AnyObject#>, withObject: <#T##AnyObject?#>)
        
    }
    

}
