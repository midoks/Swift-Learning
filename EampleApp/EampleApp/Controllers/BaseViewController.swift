//
//  BaseViewController.swift
//
//  Created by midoks on 15/7/20.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func noticeTop(text: String) {
        mSystemPrompt.noticeOnSatusBar(text, autoClear: true)
    }
    
    func noticeTop(text: String, autoClear: Bool) {
        mSystemPrompt.noticeOnSatusBar(text, autoClear: autoClear)
    }
    
    //简单的消息提示
    func Toast(text:String){
        mSystemPrompt.showText(text, autoClear: true, time: 0.8)
    }
    
    //简单的消息提示
    func Toast(text:String, time: Float64){
        mSystemPrompt.showText(text, autoClear: true, time:time)
    }
    
    func successNotice(text: String) {
        mSystemPrompt.showNoticeWithText(NoticeType.success, text: text, autoClear: true)
    }
    
    func successNotice(text: String, autoClear: Bool) {
        mSystemPrompt.showNoticeWithText(NoticeType.success, text: text, autoClear: autoClear)
    }
    
    func errorNotice(text: String) {
        mSystemPrompt.showNoticeWithText(NoticeType.error, text: text, autoClear: true)
    }
    
    func errorNotice(text: String, autoClear: Bool) {
        mSystemPrompt.showNoticeWithText(NoticeType.error, text: text, autoClear: autoClear)
    }
    
    func infoNotice(text: String) {
        mSystemPrompt.showNoticeWithText(NoticeType.info, text: text, autoClear: true)
    }
    
    func infoNotice(text: String, autoClear: Bool) {
        mSystemPrompt.showNoticeWithText(NoticeType.info, text: text, autoClear: autoClear)
    }
    
    func notice(text: String, type: NoticeType, autoClear: Bool) {
        mSystemPrompt.showNoticeWithText(type, text: text, autoClear: autoClear)
    }
    
    func pleaseWait() {
        mSystemPrompt.wait()
    }
    
    func clearAllNotice() {
        mSystemPrompt.clear()
    }

}

class BaseViewController: UIViewController {

}
