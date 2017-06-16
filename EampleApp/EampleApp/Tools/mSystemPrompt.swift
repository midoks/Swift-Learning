//
//  mSystemPrompt.swift
//
//  Created by midoks on 15/7/26.
//  Copyright © 2015年 midoks. All rights reserved.
//
//  原作者地址: http://lvwenhan.com/ios/448.html

import UIKit



enum NoticeType{
    case success
    case error
    case info
}

class mSystemPrompt: NSObject {
    
    static var windows = Array<UIWindow!>()
    static let rv = UIApplication.shared.keyWindow?.subviews.first as UIView!
    
    static func clear(){
        for i in windows {
            i?.isHidden = true
        }
    }
    
    //在状态栏提示
    static func noticeOnSatusBar(_ text: String, autoClear: Bool) {
        let frame = UIApplication.shared.statusBarFrame
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        let view = UIView()
        view.backgroundColor = UIColor(red: 0x6a/0x100, green: 0xb4/0x100, blue: 0x9f/0x100, alpha: 1)
        
        let label = UILabel(frame: frame)
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.text = text
        view.addSubview(label)
        
        window.frame = frame
        view.frame = frame
        
        window.windowLevel = UIWindowLevelStatusBar
        window.isHidden = false
        window.addSubview(view)
        windows.append(window)
        
        if autoClear {
            let selector = #selector(mSystemPrompt.hideNotice(_:))
            self.perform(selector, with: view, afterDelay: 1)
        }
    }
    
    //等待
    static func wait() {
        let frame = CGRect(x: 0, y: 0, width: 78, height: 78)
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        let mainView = UIView()
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
        
        let ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        ai.frame = CGRect(x: 21, y: 21, width: 36, height: 36)
        ai.startAnimating()
        mainView.addSubview(ai)
        
        window.frame = frame
        mainView.frame = frame
        
        window.windowLevel = UIWindowLevelAlert
        window.center = (rv?.center)!
        window.isHidden = false
        window.addSubview(mainView)
        windows.append(window)
    }
    
    //文字显示提示
    static func showText(_ text: String, autoClear: Bool, time: Float64) {
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        let mainView = UIView()
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
        
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        label.sizeToFit()
        mainView.addSubview(label)
        
        let superFrame = CGRect(x: 0, y: 0, width: label.frame.width + 50 , height: label.frame.height + 30)
        window.frame = superFrame
        mainView.frame = superFrame
        
        label.center = mainView.center
        
        window.windowLevel = UIWindowLevelAlert
        window.center = (rv?.center)!
        window.isHidden = false
        window.addSubview(mainView)
        windows.append(window)
        
        if autoClear {
            let selector = #selector(mSystemPrompt.hideNotice(_:))
            self.perform(selector, with: mainView, afterDelay: time)
        }
    }
    
    static func showNoticeWithText(_ type: NoticeType,text: String, autoClear: Bool) {
        let frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        let mainView = UIView()
        mainView.layer.cornerRadius = 10
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.7)
        
        var image = UIImage()
        switch type {
        case .success:
            image = mSystemPromptSDK.imageOfCheckmark
        case .error:
            image = mSystemPromptSDK.imageOfCross
        case .info:
            image = mSystemPromptSDK.imageOfInfo
        }
        let checkmarkView = UIImageView(image: image)
        checkmarkView.frame = CGRect(x: 27, y: 15, width: 36, height: 36)
        mainView.addSubview(checkmarkView)
        
        let label = UILabel(frame: CGRect(x: 0, y: 60, width: 90, height: 16))
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white
        label.text = text
        label.textAlignment = NSTextAlignment.center
        mainView.addSubview(label)
        
        window.frame = frame
        mainView.frame = frame
        
        window.windowLevel = UIWindowLevelAlert
        window.center = (rv?.center)!
        window.isHidden = false
        window.addSubview(mainView)
        windows.append(window)
        
        if autoClear {
            let selector = #selector(mSystemPrompt.hideNotice(_:))
            self.perform(selector, with: mainView, afterDelay: 3)
        }
    }
    
    static func hideNotice(_ sender: AnyObject) {
        if sender is UIView {
            sender.removeFromSuperview()
        }
    }

}



class mSystemPromptSDK {
    
    struct Cache {
        static var imageOfCheckmark: UIImage?
        static var imageOfCross: UIImage?
        static var imageOfInfo: UIImage?
    }
    
    class func draw(_ type: NoticeType) {
        let checkmarkShapePath = UIBezierPath()
        
        // draw circle
        checkmarkShapePath.move(to: CGPoint(x: 36, y: 18))
        checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 18), radius: 17.5, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
        checkmarkShapePath.close()
        
        switch type {
        case .success: // draw checkmark
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.addLine(to: CGPoint(x: 16, y: 24))
            checkmarkShapePath.addLine(to: CGPoint(x: 27, y: 13))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.close()
        case .error: // draw X
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 26))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 26))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 10))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.close()
        case .info:
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.addLine(to: CGPoint(x: 18, y: 22))
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.close()
            
            UIColor.white.setStroke()
            checkmarkShapePath.stroke()
            
            let checkmarkShapePath = UIBezierPath()
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 27))
            checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 27), radius: 1, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
            checkmarkShapePath.close()
            
            UIColor.white.setFill()
            checkmarkShapePath.fill()
        }
        
        UIColor.white.setStroke()
        checkmarkShapePath.stroke()
    }
    
    class var imageOfCheckmark: UIImage {
        if (Cache.imageOfCheckmark != nil) {
            return Cache.imageOfCheckmark!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        mSystemPromptSDK.draw(NoticeType.success)
        
        Cache.imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCheckmark!
    }
    
    class var imageOfCross: UIImage {
        if (Cache.imageOfCross != nil) {
            return Cache.imageOfCross!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        mSystemPromptSDK.draw(NoticeType.error)
        
        Cache.imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCross!
    }
    
    class var imageOfInfo: UIImage {
        if (Cache.imageOfInfo != nil) {
            return Cache.imageOfInfo!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        mSystemPromptSDK.draw(NoticeType.info)
        
        Cache.imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfInfo!
    }
}
