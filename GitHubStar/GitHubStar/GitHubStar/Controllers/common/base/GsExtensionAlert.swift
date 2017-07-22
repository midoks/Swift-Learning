//
//  GsExtensionAlert.swift
//  GitHubStar
//
//  Created by midoks on 16/4/8.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

extension UIViewController {

    //显示提示信息
    public func showAlert(title:String, msg:String, success: @escaping ()->()
        , fail:@escaping ()->()){
        
        let alertDelete = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let cancal = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
            fail()
        }

        
        let confirm = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
            success()
        }
        
        alertDelete.addAction(cancal)
        alertDelete.addAction(confirm)
        self.present(alertDelete, animated: true) { () -> Void in
            
        }
    }
    
    //显示提示信息
    public func showAlertNotice(title:String, msg:String, ok:@escaping ()->Void){
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
            ok()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true) { () -> Void in
            
        }
    }
    
    //定时提醒
    public func showTextWithTime(msg:String, time:Int64){
        let alertShow = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        self.present(alertShow, animated: true) { () -> Void in
        }
        
        self.doCallback(time: time) { () -> Void in
            self.dismiss(animated: true) { () -> Void in
            }
        }
    }
    
    public func showTextWithTime(msg:String, time:Int64, callback: @escaping ()->Void ){
        let alertShow = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        self.present(alertShow, animated: true) { () -> Void in
        }
        self.doCallback(time: time) { () -> Void in
            self.dismiss(animated: true) { () -> Void in
                callback()
            }
        }
    }
    
    //定时回调
    func doCallback(time:Int64 ,callback:()->() ){
        callback()
    }

}
