//
//  GsExtensionColor.swift
//  GitHubStar
//
//  Created by midoks on 16/4/3.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

extension UIColor{
    
    //随机颜色
    static func randomColor() -> UIColor {
        let hue = CGFloat(arc4random() % 256) / 256.0
        let saturation = ( CGFloat(arc4random() % 128) / 256.0 ) + 0.5
        let brightness = ( CGFloat(arc4random() % 128) / 256.0 ) + 0.5
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
    static func primaryColor() -> UIColor {
        return UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
    }
    
    static func useColor(red:CGFloat, green:CGFloat, blue:CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func gitFontColor() -> UIColor {
        return UIColor.useColor(red: 64, green: 120, blue: 192)
    }
    
    //MARK: - 通过颜色生成图片 -
    static func imageWithColor(color:UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width:1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fillEllipse(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
