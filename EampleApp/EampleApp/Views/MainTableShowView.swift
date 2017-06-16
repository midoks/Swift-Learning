//
//  MainTableShowView.swift
//  EampleApp
//
//  Created by midoks on 15/8/29.
//  Copyright © 2015年 midoks. All rights reserved.
//

import Foundation
import UIKit


class MainTableShowView: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    //添加内容
    func addContent(_ image: UIImage, title: NSString, detail:NSString, time:NSString){
    
        //图片显示
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.image = image
        imageView.center.y = self.center.y
        //添加图片
        self.addSubview(imageView)
        
        
        //标题
        let titleLabel = UILabel(frame: CGRect(x: imageView.frame.width, y: 0,
            width: (self.frame.width - imageView.frame.width - 20) / 2, height: 30))
        titleLabel.text = title as String
        self.addSubview(titleLabel)
    
        //详情
        let detailLabel = UILabel(frame: CGRect(x: imageView.frame.width, y: 30, width: self.frame.width - imageView.frame.width - 20, height: 28))
        detailLabel.text = detail as String
        detailLabel.font = UIFont(name: "Arial", size: 12)
        detailLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        detailLabel.numberOfLines = 0
        self.addSubview(detailLabel)
        
        //显示时间
        let timeLabel = UILabel(frame: CGRect(x: imageView.frame.width + (self.frame.width - imageView.frame.width - 20) / 2,
            y: 0,
            width: (self.frame.width - imageView.frame.width - 20) / 2 - 20,
            height: 30))
        
        timeLabel.text = time as String
        timeLabel.textAlignment = NSTextAlignment.right
        self.addSubview(timeLabel)
        
    }

}
