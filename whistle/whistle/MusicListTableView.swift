//
//  ListTableView.swift
//  LoadWebData
//
//  Created by midoks on 15/3/11.
//  Copyright (c) 2015年 midoks. All rights reserved.
//

import Foundation
import UIKit



class MusicListTableView:UIView {
    
    let num:NSInteger = 4
    var delegate: MusicListTableViewDelegate!
    
    
    /* 布局开发 添加view */
    func start(){

        var width = self.frame.size.width / CGFloat(num)
        self.frame.size.height = 120.0
        
        for(var hn = 0; hn<1; hn++)
        {
            var hnpos = CGFloat(hn) * CGFloat(60.0)
            for(var i:NSInteger=0; i<self.num; i++)
            {
                var Music:UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton;
                var pos = CGFloat(i) * CGFloat(width);
                Music.frame = CGRectMake(pos, hnpos, width, 60)
                Music.backgroundColor = UIColor.greenColor()
                Music.tag = i;

                var istring = String(i+hn);
                Music.setTitle(istring, forState: UIControlState.Normal)
                self.addSubview(Music)
                
                Music.addTarget(self, action: Selector("click:"), forControlEvents: UIControlEvents.TouchDown)
            }
        }
    }
    
    func click(button: UIButton){
        self.delegate?.MusicClick!(self, pos: button.tag)
    }
}

@objc protocol MusicListTableViewDelegate: NSObjectProtocol {
    optional func MusicClick(selfObj:MusicListTableView, pos:NSInteger)

}