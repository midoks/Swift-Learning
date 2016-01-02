//
//  MusicAlertPage.swift
//  LoadWebData
//
//  Created by midoks on 15/4/12.
//  Copyright (c) 2015年 midoks. All rights reserved.
//

import Foundation
import UIKit



class MusicAlertPageView:UIView {
    
    var noticeName: UILabel?
    var delegate: MusicAlertPageViewDelegate!
    
    func start(){
        
        let view = UIView(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
        view.backgroundColor = UIColor.grayColor()
        view.alpha = 0.8
        
        let showview = UIView(frame: CGRectMake(0, 0, self.frame.width, 150))
        showview.backgroundColor = UIColor.whiteColor()
        showview.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        showview.alpha = 1.0
        
        self.addSubview(view)
        self.addSubview(showview)
        
        //标题
        let titleName = UILabel(frame: CGRectMake(0.0, 0.0, showview.frame.width, 40))
        titleName.backgroundColor = UIColor.clearColor()
        titleName.textAlignment = NSTextAlignment.Center
        titleName.text = "点击按钮开始录口哨音"
        
        //录制按钮
        let button_record = UIButton(frame: CGRectMake(0, 0, 60, 60))
        button_record.backgroundColor = UIColor.redColor()
        button_record.center =  CGPoint(x:showview.frame.width/2 - 32,y:showview.frame.height/2)
        button_record.layer.cornerRadius = 30
        button_record.setTitle("录制", forState: UIControlState.Normal)
        button_record.tag = 0
        button_record.addTarget(self, action: Selector("record_sound_start:"), forControlEvents: UIControlEvents.TouchDown)
        button_record.addTarget(self, action: Selector("record_sound_end:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        //关闭按钮
        let button_close =  UIButton(frame: CGRectMake(0, 0, 60, 60))
        button_close.backgroundColor = UIColor.brownColor()
        button_close.center =  CGPoint(x:showview.frame.width/2 + 32,y:showview.frame.height/2)
        button_close.layer.cornerRadius = 30
        button_close.setTitle("关闭", forState: UIControlState.Normal)
        button_close.setTitleColor(UIColor.blueColor(), forState: UIControlState.Selected)
        button_close.addTarget(self, action: Selector("record_sound_close:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        //提示按钮
        noticeName = UILabel(frame: CGRectMake(0.0, showview.frame.height - 40, showview.frame.width, 40))
        noticeName?.textAlignment = NSTextAlignment.Center
        noticeName?.backgroundColor = UIColor.clearColor()
        //noticeName.text = "提示"
        
        showview.addSubview(noticeName!)
        showview.addSubview(button_record)
        showview.addSubview(button_close)
        showview.addSubview(titleName)
    }
    
    //开始录音
    func record_sound_start(button: UIButton)
    {
        noticeName?.text = "正在录制中..."
        button.setTitle("停止", forState: UIControlState.Normal)
        self.delegate?.MusicAlertPageViewStart!(self, pos:1)
    }
    
    //结束录音
    func record_sound_end(button: UIButton)
    {
        noticeName?.text = "已经录制完成"
        button.setTitle("重录制", forState: UIControlState.Normal)
        self.delegate?.MusicAlertPageViewEnd!(self, pos:1)
    }
    
    //删除图层
    func record_sound_close(button: UIButton){
        self.removeFromSuperview()
    }

}


@objc protocol MusicAlertPageViewDelegate: NSObjectProtocol {
    optional func MusicAlertPageViewStart(selfObj:MusicAlertPageView, pos: NSInteger)
    optional func MusicAlertPageViewEnd(selfObj:MusicAlertPageView, pos: NSInteger)
}