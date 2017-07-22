//
//  GsHeadIconView.swift
//  GitHubStar
//
//  Created by midoks on 16/3/9.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

class GsHeadIconView: UIView {

    var headClick:((_ type: Int) -> ())?
    
    var listIcon = Array<GsIconView>()
    var listLine = Array<UIView>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func click(tap: UIGestureRecognizer) {
        if headClick != nil {
            //print(tap.view?.tag)
            headClick!(tap.view!.tag)
        }
    }
    
    func addIcon(icon:GsIconView){
        listIcon.append(icon)
        addSubview(icon)
        icon.tag = listIcon.count - 1
        
        if listIcon.count > 0 {
            let line = UIView()
            line.backgroundColor = UIColor.gray
            line.alpha = 0.3
            listLine.append(line)
            addSubview(line)
        }
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(click(_:)))
//        let subView = viewWithTag(icon.tag)
//        subView?.addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let minW = self.frame.width / CGFloat(listIcon.count)
        let h = self.frame.height
        
        for i in 0 ..< listIcon.count {
            listIcon[i].frame = CGRect(x: CGFloat(i)*minW, y: 0, width: minW, height: h)
        }
        
        if listLine.count > 0 {
            for j in 0 ..< listLine.count {
                listLine[j].frame = CGRect(x: CGFloat(j)*minW - 0.5, y: h * 0.2, width: 0.5, height: h * 0.6)
            }
        }
    }
}
