//
//  BaseViewController.swift
//
//  Created by midoks on 15/7/20.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func noticeTop(_ text: String) {
        mSystemPrompt.noticeOnSatusBar(text, autoClear: true)
    }
    
    func noticeTop(_ text: String, autoClear: Bool) {
        mSystemPrompt.noticeOnSatusBar(text, autoClear: autoClear)
    }
    
    //简单的消息提示
    func Toast(_ text:String){
        mSystemPrompt.showText(text, autoClear: true, time: 0.8)
    }
    
    //简单的消息提示
    func Toast(_ text:String, time: Float64){
        mSystemPrompt.showText(text, autoClear: true, time:time)
    }
    
    func successNotice(_ text: String) {
        mSystemPrompt.showNoticeWithText(NoticeType.success, text: text, autoClear: true)
    }
    
    func successNotice(_ text: String, autoClear: Bool) {
        mSystemPrompt.showNoticeWithText(NoticeType.success, text: text, autoClear: autoClear)
    }
    
    func errorNotice(_ text: String) {
        mSystemPrompt.showNoticeWithText(NoticeType.error, text: text, autoClear: true)
    }
    
    func errorNotice(_ text: String, autoClear: Bool) {
        mSystemPrompt.showNoticeWithText(NoticeType.error, text: text, autoClear: autoClear)
    }
    
    func infoNotice(_ text: String) {
        mSystemPrompt.showNoticeWithText(NoticeType.info, text: text, autoClear: true)
    }
    
    func infoNotice(_ text: String, autoClear: Bool) {
        mSystemPrompt.showNoticeWithText(NoticeType.info, text: text, autoClear: autoClear)
    }
    
    func notice(_ text: String, type: NoticeType, autoClear: Bool) {
        mSystemPrompt.showNoticeWithText(type, text: text, autoClear: autoClear)
    }
    
    func pleaseWait() {
        mSystemPrompt.wait()
    }
    
    func clearAllNotice() {
        mSystemPrompt.clear()
    }
    
    //文本提示
    func noticeText(_ title:NSString, text:NSString, time:Double){
        let alert = UIAlertController(title: title as String, message: text as String, preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true) { () -> Void in
            
        }
        (Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(UIViewController.timerFireMethod(_:)), userInfo: nil, repeats: false)).fire()
    }
    
    func timerFireMethod(_ timer:Timer){
        self.dismiss(animated: true) { () -> Void in
            
        }
    }

}

class BaseViewController: UIViewController {
    

}


