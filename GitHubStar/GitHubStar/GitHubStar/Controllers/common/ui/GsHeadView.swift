//
//  GsRepoHeadView.swift
//  GitHubStar
//
//  Created by midoks on 16/3/3.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

class GsHeadView: UIView {
    
    var icon = UIImageView()
    var iconClick:(() -> ())?
    
    var name = UILabel()
    var desc = UILabel()
    var descSize = CGSize.zero
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        //背景
        self.backgroundColor = UIColor.primaryColor()
        
        //头像
        icon.layer.cornerRadius = 40
        icon.tag = 100
        icon.isUserInteractionEnabled = true
        icon.clipsToBounds = true
        self.addSubview(icon)
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(GsHeadView.iconClick(_:)))
//        let subView = viewWithTag(100)
//        subView?.addGestureRecognizer(tap)
        
        //用户昵称
        name.text = ""
        name.tag = 1
        name.textColor = UIColor.white
        name.textAlignment = NSTextAlignment.center
        name.font = UIFont.boldSystemFont(ofSize: 16)
        name.font = UIFont.systemFont(ofSize: 16)
        addSubview(name)
        
        //描述信息
        desc.text = ""
        desc.tag = 200
        desc.numberOfLines = 0
        desc.lineBreakMode = .byWordWrapping
        desc.textAlignment = .center
        desc.textColor = UIColor.useColor(red: 180, green: 180, blue: 180)
        desc.font = UIFont.systemFont(ofSize: 12)
        addSubview(desc)
        
    }
    
    func setInstro(text:String)-> CGSize {
        desc.text = text
        let size = desc.text!.textSizeWithFont(font: desc.font, constrainedToSize: CGSize(width: self.frame.width - 20, height: CGFloat(MAXFLOAT)))
        descSize = size
        desc.frame.size = size
        
        var f = self.frame
        f.size.height += size.height
        self.frame = f
        
        
        return size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon.frame = CGRect(x:(self.frame.width - 80) * 0.5, y:self.frame.height - 30 - 80 - descSize.height, width: 80, height: 80)
        name.frame = CGRect(x: 0, y: self.frame.height - 30 - descSize.height, width: self.frame.width, height: 30)
        desc.frame = CGRect(x: 0, y: self.frame.height - descSize.height - 5 , width: descSize.width, height: descSize.height)
        desc.center.x = self.center.x
        
    }
    
    func iconClick(tap: UIGestureRecognizer){
        iconClick?()
    }
    
}
