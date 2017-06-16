//
//  MDTopTapView.swift
//  EampleApp
//
//  Created by midoks on 15/9/3.
//  Copyright © 2015年 midoks. All rights reserved.
//

import Foundation
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



class MDTopTapView :UIView, UITableViewDataSource,UITableViewDelegate {
    
    //顶部菜单栏横向滑动的table
    var topMenuTableView: UITableView?
    //菜单下面横向滑动内容的table
    var contentTableView: UITableView?
    //指示器view
    var indicatorView: UIView?
    //页数
    var pageIndex:Int?
    
    var _angle:CGFloat?
    
    
    //MARK: - 初始化 -
    override init(frame:CGRect){
        super.init(frame: frame)
        
        self.pageIndex = 0
        
        self.initTopTapTableView()
        self.initContentTableView()
        self.initIndicatorView()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //初始化指示器
    func initIndicatorView() ->UIView {
        if(nil == indicatorView){
            
            let width = self.getMenuWidth()
            let height:CGFloat = 2
            
            indicatorView = UIView(frame: CGRect(x:0 , y: 0, width: height, height: width))
            indicatorView?.backgroundColor = UIColor.blue
            
            topMenuTableView?.addSubview(indicatorView!)
            topMenuTableView?.bringSubview(toFront: indicatorView!)
        }
        return indicatorView!
    }
    
    //TopTapTableView
    func initTopTapTableView() -> UITableView{
        
        if(nil == topMenuTableView ){
            //print(self.frame)
            
            let topMenuHeight:CGFloat = self.getMenuHeight()
            let topMenuWidth:CGFloat = self.frame.width + 64 + 49
            
            //before rotate bounds = (0, 0, width, height)
            //rototate -90 bounds = (0, 0, height, width)
            
            let x = topMenuWidth / 2.0 - topMenuHeight / 2.0 - 64
            let y = -topMenuWidth / 2.0  + topMenuHeight / 2.0
            
            
            //print(CGRectGetWidth(self.frame))
            //print(topMenuHeight)
            
            topMenuTableView     = UITableView(frame: CGRect(x: x, y: y,
                width: topMenuHeight, height: topMenuWidth),
                style: UITableViewStyle.plain)
            topMenuTableView!.dataSource  = self
            topMenuTableView!.delegate    = self
            self.addSubview(topMenuTableView!)
            
            
            //不显示滚动条
            topMenuTableView?.showsVerticalScrollIndicator = false
            //不显示分割线
            topMenuTableView?.separatorStyle = UITableViewCellSeparatorStyle.none
            _angle = (CGFloat)(-M_PI/2)
            topMenuTableView?.transform = CGAffineTransform(rotationAngle: _angle!)
        
            
            //NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("timeRotationTest"), userInfo: nil, repeats: true)
        }
        return topMenuTableView!
    }
    
    func initContentTableView() -> UITableView {
        if( nil == contentTableView){
        
            let cHeight = self.frame.width
            let cWidth = self.frame.height - self.getMenuHeight()
            
            let x = self.frame.width/2 - cWidth/2
            let y_abs = (Float)(cHeight/2.0 - cWidth/2.0)
            let y = (CGFloat)(fabsf(y_abs)) + self.getMenuHeight()
            
            contentTableView = UITableView(frame: CGRect(x: x, y: y, width: cWidth, height: cHeight), style: UITableViewStyle.plain)
            self.addSubview(contentTableView!)
            
            contentTableView?.delegate = self
            contentTableView?.dataSource = self
            contentTableView?.showsVerticalScrollIndicator = false
            contentTableView?.isPagingEnabled = true
            contentTableView?.separatorStyle = UITableViewCellSeparatorStyle.none
            
            let _angle = (CGFloat)(-M_PI/2.0)
            contentTableView?.transform = CGAffineTransform(rotationAngle: _angle)
        }
        return contentTableView!
    }
    
    func timeRotationTest(){
        _angle = _angle! + 0.01;//angle角度 double angle;
        if (_angle > 6.28) {//大于 M_PI*2(360度) 角度再次从0开始
            _angle = 0;
        }
        
        let transform=CGAffineTransform(rotationAngle: _angle!)
        topMenuTableView!.transform = transform
    }
    
    
    //MARK: - UITableViewDataSource -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == self.topMenuTableView){
            return self.getMenuWidth()
        }else if(tableView == self.contentTableView){
            return self.frame.width
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == self.topMenuTableView){
            //var cell = tableView.dequeueReusableCellWithIdentifier("TopMenuCell")
            
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "TopMenuCell")
            cell.frame = CGRect(x: 0, y: 0, width: self.getMenuWidth(), height: self.getMenuHeight())
            
            
            cell.contentView.removeFromSuperview()
            //cell!.backgroundColor = self.randomColor()
            
            let textView = UIView(frame: CGRect(x: 0, y: 0, width: self.getMenuWidth(), height: self.getMenuHeight()))
            let text = UILabel(frame: textView.frame)
            text.text = "测试" + String(indexPath.row)
            text.textAlignment = NSTextAlignment.center
            textView.addSubview(text)
            cell.addSubview(textView)
            
            let _angleView = (CGFloat)(M_PI/2)
            
            let x = self.getMenuWidth() / 2.0 - textView.frame.width / 2.0
            let y = self.getMenuHeight() / 2.0  - textView.frame.height / 2.0
            
            textView.transform = CGAffineTransform(rotationAngle: _angleView)
            textView.frame = CGRect(x: x, y: y, width: textView.frame.width, height: textView.frame.height)
            textView.backgroundColor = UIColor.yellow
            
            
            return cell
        }else if(tableView == contentTableView){
            //var cell = tableView.dequeueReusableCellWithIdentifier("ContentPageCell")
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "ContentPageCell")
            cell.frame = CGRect(x: 0, y: 0, width: self.frame.height-self.getMenuHeight(), height: self.frame.width)
            cell.contentView.removeFromSuperview()
            cell.backgroundColor = UIColor.clear
            
            let textView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.height-self.getMenuHeight(), height: self.frame.width))
            //textView.backgroundColor = self.randomColor()
            let text = UILabel(frame: textView.frame)
            text.text = "测试" + String(indexPath.row)
            text.textAlignment = NSTextAlignment.center
            textView.addSubview(text)
            let _angleView = (CGFloat)(M_PI/2.0)
            textView.transform = CGAffineTransform(rotationAngle: _angleView)
            cell.addSubview(textView)
            
            return cell
        }else{
            
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "TopMenuCell")
            cell.textLabel!.text = "测试"
            return cell
        }
    }
    
    //点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(tableView == self.topMenuTableView){
            self.pageIndex = indexPath.row
            self.contentTablesScrollToIndexPath(indexPath)
        }
    }
    
    //MARK: - scrollView -
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if(scrollView == self.contentTableView ){
            let tmpPage = ((self.contentTableView?.contentOffset.y)! + 0.5 * self.frame.width)/self.frame.width
            if(tmpPage != (CGFloat)(self.pageIndex!)){
                self.pageIndex = (Int)(tmpPage)
            }
            self.updateIndicatorPosition()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(scrollView == self.contentTableView ){
            self.handleEndScroll()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(scrollView == self.contentTableView)
        {
            if(!decelerate)
            {
                self.handleEndScroll();
            }
        }

    }
    
    //MARK: - Public Methods -
    
    
    func reloadData(){
        self.topMenuTableView?.reloadData()
        self.contentTableView?.reloadData()
    }
    
    func updateIndicatorPosition() {
        let y = (self.contentTableView?.contentOffset.y)! / (self.contentTableView?.contentSize.height)!
        
        self.indicatorView!.frame = CGRect(x: self.indicatorView!.frame.origin.x,
            y: (y * self.topMenuTableView!.contentSize.height),
            width: self.indicatorView!.frame.size.width,
            height: self.indicatorView!.frame.size.height)
    }
    
    func contentTablesScrollToIndexPath(_ indexPath: IndexPath){
        self.contentTableView?.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
        self.handleEndScroll()
    }
    
    //MARK: - Private Methods -
    
    func handleEndScroll(){
        let indexPath = IndexPath(row: self.pageIndex!, section: 0)
        self.topMenuTableView?.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
    }
    
    func randomColor()->UIColor{
        let hue = (CGFloat)(arc4random() % 256) / 256.0
        let saturation = (CGFloat)(arc4random() % 256) / 256.0
        let brightness = (CGFloat)(arc4random() % 256) / 256.0
        
        let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
        return color
    }
    
    //顶部菜单的高度
    func getMenuHeight()->CGFloat{
        return 40
    }
    
    //顶部菜单的宽度
    func getMenuWidth()->CGFloat{
        return 80
    }
    
    
}

@objc protocol MDTopTapViewDelegate{
    
    
    
    
    
}

