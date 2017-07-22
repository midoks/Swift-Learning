//
//  GsHomeView.swift
//  GitHubStar
//
//  Created by midoks on 16/4/4.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

class GsHomeHeadView: UIView {
    
    var icon = UIImageView()
    var iconClick:(() -> ())?
    var iconStar = UIImageView()
    
    
    var name = UILabel()
    var desc = UILabel()
    
    var listIcon = Array<GsIconView>()
    var listLine = Array<UIView>()
    var listClick:((_ type: Int) -> ())?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        
        //头像
        icon.layer.cornerRadius = 40
        icon.tag = 100
        icon.isUserInteractionEnabled = true
        icon.clipsToBounds = true
        self.addSubview(icon)
    
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(GsHomeHeadView.iconClick(_:)))
//        let subView = viewWithTag(100)
//        subView?.addGestureRecognizer(tap)
        
        //用户昵称
        name.text = ""
        name.frame.origin.x = 10
        name.frame.size.width = self.frame.width - 20
        name.textColor = UIColor.white
        name.numberOfLines = 0
        name.lineBreakMode = .byWordWrapping
        name.textAlignment = .center
        name.font = UIFont.boldSystemFont(ofSize: 16)
        name.font = UIFont.systemFont(ofSize: 16)
        addSubview(name)
        
        //描述信息
        desc.text = ""
        desc.frame.origin.x = 10
        desc.frame.size.width = self.frame.width - 20
        desc.numberOfLines = 0
        desc.lineBreakMode = .byWordWrapping
        desc.textAlignment = .center
        desc.textColor = UIColor.useColor(red: 180, green: 180, blue: 180)
        desc.font = UIFont.systemFont(ofSize: 12)
        addSubview(desc)
        
        //name.backgroundColor = UIColor.yellowColor()
        //desc.backgroundColor = UIColor.blueColor()
    }
    
    func addIcon(icon:GsIconView){
        listIcon.append(icon)
        addSubview(icon)
        
        icon.tag = (listIcon.count - 1) * 1000
        if listIcon.count > 0 {
            let line = UIView()
            line.backgroundColor = UIColor.gray
            line.alpha = 0.3
            listLine.append(line)
            addSubview(line)
        }
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(GsHomeHeadView.listClick(_:)))
//        let subView = viewWithTag(icon.tag)
//        subView?.addGestureRecognizer(tap)
    }
    
    func addIconStar(){
        iconStar = UIImageView()
        iconStar.image = UIImage(named: "star_yellow")
        iconStar.frame = CGRect(x: icon.frame.origin.x + icon.frame.size.width - 20,
                                y: icon.frame.origin.y + icon.frame.size.height - 20,
                                width: 20,
                                height: 20)
        iconStar.backgroundColor = UIColor.white
        iconStar.layer.cornerRadius = 12
        iconStar.isUserInteractionEnabled = true
        iconStar.clipsToBounds = true
        self.addSubview(iconStar)
    }
    
    func removeIconStar(){
        self.iconStar.removeFromSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon.frame = CGRect(x: (self.frame.width - 80) * 0.5, y: 5, width: 80, height: 80)
        icon.center.x = center.x
        
        
        var size = CGSize.zero
        
        if name.text != "" {
            name.frame.size.width = self.frame.width - 20
            size = self.getLabelSize(label: name)
            name.frame = CGRect(x: 10, y: 90, width: name.frame.size.width, height: size.height)
        }
        
        if desc.text != "" {
            desc.frame.size.width = self.frame.width - 20
            size = self.getLabelSize(label: desc)
            desc.frame = CGRect(x: 10, y: 92 + name.frame.height, width: desc.frame.width, height: size.height)
        }
        
        
        if listIcon.count > 0 {
            
            let iconH:CGFloat = 70
            let iconW = self.frame.width / CGFloat(listIcon.count)
            //let posH = desc.frame.origin.y + desc.frame.height + 10
            let posH = self.frame.height - iconH
            
            for i in 0 ..< listIcon.count {
                listIcon[i].frame = CGRect(x: CGFloat(i)*iconW, y:posH , width: iconW, height: iconH)
            }
            
            for j in 0 ..< listLine.count {
                listLine[j].frame = CGRect(x: CGFloat(j)*iconW - 0.5, y: (posH) + 80 * 0.2, width: 0.5, height: iconH * 0.6)
            }
        }
        
        
    }
    
    func iconClick(tap: UIGestureRecognizer){
        iconClick?()
    }
    
    func listClick(tap: UIGestureRecognizer) {
        listClick?(tap.view!.tag / 1000)
    }
}


class GsIconView:UIView{
    
    var key = UILabel()
    var desc = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        key.text = "0"
        key.textAlignment = .center
        key.font = UIFont.systemFont(ofSize: 23)
        key.textColor = UIColor(red: 64/255, green: 120/255, blue: 192/255, alpha: 1)
        addSubview(key)
        
        desc.text = "desc"
        desc.textAlignment = .center
        desc.font = UIFont.systemFont(ofSize: 12)
        desc.textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
        addSubview(desc)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        key.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - 10)
        desc.frame = CGRect(x: 0, y: self.frame.height - 30, width: self.frame.width, height: 20)
    }
}
