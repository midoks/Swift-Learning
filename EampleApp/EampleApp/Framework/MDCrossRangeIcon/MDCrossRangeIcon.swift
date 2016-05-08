//
//  MDCrossRangeIcon.swift
//
//  Created by midoks on 15/8/23.
//  Copyright © 2015年 midoks. All rights reserved.
//


// 横向图标显示delegate


import Foundation
import UIKit


struct  MDCrossRangList{
    var image: UIImage?
    var title: NSString?
}

class MDCrossRangeIcon: UIView {
    
    var icon:MDCrossRangList?
    var iconList:Array<MDCrossRangList> = Array<MDCrossRangList>()
    var delegate: MDCrossRangeIconDelegate?
    
    var column: Int = 4
    var rowHeight: CGFloat = 80
    
    //MARK: - 初始化 -
    override init(frame:CGRect){
        super.init(frame:frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 添加图标和标题 -
    func addImage(image:UIImage, title: NSString){
        let item = MDCrossRangList(image: image, title: title)
        self.iconList.append(item)
    }
    
    //设置横向固定列
    func setFixedColumn(number:Int){
        self.column = number
    }
    
    func setIconHeight(height:CGFloat){
        self.rowHeight = height
    }
    
    func addFillIcon(number: Int){
        let num = number - self.iconList.count
        if(num > 0){
            for _ in 0 ..< num {
                self.addImage(UIImage(), title: "")
            }
        }
    }
    
    //MARK: - 显示结构 -
    func render(){
        
        let column  =   self.column
        let row     =   Int(self.frame.height/self.rowHeight)
        self.addFillIcon(column * row)
        
        let viewIconWidth = self.frame.width / CGFloat(column)
        let viewIconHeight = self.rowHeight
    
        var num = 0
        for i in 0 ..< row {
            for j in 0 ..< column {
                if(self.iconList.count > num){
                    //print(num)
                    let value = self.iconList[num]
                    self.addIconItem(value, viewIconWidth: viewIconWidth, viewIconHeight: viewIconHeight,
                        j: CGFloat(j), i: CGFloat(i), num: num)
                }
//                else{
//                    self.addImage(UIImage(named: "img_menu_water.png")!, title: "11")
//                }
                num += 1
            }
        }
    }
    
    //MARK: - 添加 -
    private func addIconItem(value: MDCrossRangList, viewIconWidth: CGFloat, viewIconHeight: CGFloat,
            j:CGFloat, i:CGFloat, num:Int){
    
        let menuIconItem = UIButton(frame: CGRect(x: viewIconWidth * j, y: 0.5 + i*self.rowHeight,
            width: viewIconWidth - 0.5, height: CGFloat(viewIconHeight) - 0.5))
        menuIconItem.backgroundColor =  UIColor.whiteColor()
        
        let bgImage = self.imageWithColor(UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1),
            size: CGSize(width: 58, height: 58))
        menuIconItem.setBackgroundImage(bgImage, forState: UIControlState.Highlighted)
        menuIconItem.tag = num
        menuIconItem.addTarget(self, action: #selector(MDCrossRangeIcon.itemClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        //图片
        let menuIconImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 29, height: 29))
        let menuIconImg = value.image
        menuIconImgView.center = CGPoint(x: viewIconWidth/2, y: CGFloat(viewIconHeight/2) - 10)
        menuIconImgView.image = menuIconImg
        menuIconItem.addSubview(menuIconImgView)
        
        //文字
        let title = UILabel(frame: CGRectMake(0, 0, viewIconWidth, 30))
        title.textAlignment = NSTextAlignment.Center
        title.frame.origin.y = CGFloat(viewIconHeight/2)+5
        title.textColor = UIColor.grayColor()
        title.font = UIFont(name: "Arial-BoldItalicMT", size: 12)
        title.text = value.title as? String
        menuIconItem.addSubview(title)
                
        self.addSubview(menuIconItem)
    }
    
    
    func itemClick(sender:UIButton){
        let pos = sender.tag
        self.delegate?.MDCrossRangeIconTouch!(pos)
    }
    
    //MARK: - Private Methods -
    //生成纯色背景
    func imageWithColor(color:UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.height, size.height)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}

@objc protocol MDCrossRangeIconDelegate {
    
    optional func MDCrossRangeIconTouch(index:Int)
}
