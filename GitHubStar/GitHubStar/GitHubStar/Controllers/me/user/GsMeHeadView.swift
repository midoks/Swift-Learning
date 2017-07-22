//
//  GsMeHeadView.swift
//  GitHubStar
//
//  Created by midoks on 16/2/21.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

class GsMeHeadView: UIImageView {
    
    var icon = UIImageView()
    var iconClick:(() -> ())?
    
    var name = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        //背景
        self.backgroundColor =  UIColor.primaryColor()
        
        //头像
        icon.layer.cornerRadius = 40
        icon.tag = 100
        icon.isUserInteractionEnabled = true
        self.addSubview(icon)
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.iconClick(_:)))
//        let subView = viewWithTag(100)
//        subView?.addGestureRecognizer(tap)
        
        //用户昵称
        name.text = ""
        name.tag = 1
        name.textColor = UIColor.white
        name.textAlignment = NSTextAlignment.center
        self.addSubview(name)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon.frame = CGRect(x: (self.frame.width - 80) * 0.5, y: self.frame.height - 30 - 80, width: 80, height: 80)
        name.frame = CGRect(x: 0, y: self.frame.height - 30, width: self.frame.width, height: 30)
    }
    
    func iconClick(tap: UIGestureRecognizer){
        if iconClick != nil {
            iconClick!()
        }
    }
    
}
