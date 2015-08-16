//
//  PictureSwitching.swift
//
//  Created by midoks on 15/8/15.
//  Copyright © 2015年 midoks. All rights reserved.
//


import Foundation
import UIKit

class PictureSwitching: UIView, UIScrollViewDelegate {
    
    //滚动的View
    var contentScrollView:  UIScrollView!
    
    var pageIndicator:      UIPageControl!         //页数指示器
    var timer:              NSTimer?               //计时器
    
    
    //图片列表
    var imageArray: [UIImage!]!
    
    //当前的现实第几张图片
    var indexOfCurrentImage: Int!
    var imageRollingDirection: Int!
    
    //代理
    var delegate: PictureSwitchingDelegate?
    
    
    //MARK: - Start -
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(frame: CGRect, imageArray: [UIImage!]? ) {
        self.init(frame: frame)
        
        //图片存放数组
        self.imageArray = imageArray
        //当前显示的图片
        self.indexOfCurrentImage = 0
        //滚动方向 0:从右往左
        self.imageRollingDirection = 0
        
        //建立UI
        self.setUp()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private -
    private func setUp(){
        print(imageArray.count)
        
        //循环
        if(self.imageArray.count > 0){
            
            self.contentScrollView = UIScrollView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
            contentScrollView.contentSize = CGSizeMake(self.frame.size.width * CGFloat(self.imageArray.count), 0)
            contentScrollView.delegate = self
            contentScrollView.bounces = false
            contentScrollView.pagingEnabled = true
            contentScrollView.backgroundColor = UIColor.greenColor()
            contentScrollView.showsHorizontalScrollIndicator = false
            contentScrollView.scrollEnabled = !(imageArray.count == 1)
            self.addSubview(contentScrollView)
            
            for(var i=0; i < self.imageArray.count; i++){
                let imgView = UIImageView()
                imgView.frame = CGRectMake(self.frame.size.width * CGFloat(i), 0, self.frame.size.width, 200)
                imgView.userInteractionEnabled = true
                imgView.contentMode = UIViewContentMode.ScaleAspectFill
                imgView.clipsToBounds = true
                contentScrollView.addSubview(imgView)
                imgView.image = self.imageArray[i]
                
                //添加点击事件
                let imageTap = UITapGestureRecognizer(target: self, action: Selector("imageTapAction:"))
                imgView.addGestureRecognizer(imageTap)
            }
        }
        
        
        //设置分页指示器
        
        //显示在右边
//        self.pageIndicator = UIPageControl(frame: CGRectMake(self.frame.size.width - 20 * CGFloat(imageArray.count),
//            self.frame.size.height - 30,
//            20 * CGFloat(imageArray.count),
//            20))
        
        self.pageIndicator = UIPageControl(frame: CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20))
        
        pageIndicator.hidesForSinglePage = true
        pageIndicator.numberOfPages = imageArray.count
        pageIndicator.backgroundColor = UIColor.clearColor()
        self.addSubview(pageIndicator)
        
        //设置计时器
        self.timeStart()
    }
    
    func timeStart(){
        self.timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "timerAction", userInfo: nil, repeats: true)
    }
    
    func timeStop(){
        self.timer!.invalidate()
    }
    
    //定时事件触发方法
    func timerAction() {
        
        if(self.imageRollingDirection == 0){ //正方向
            self.indexOfCurrentImage = self.indexOfCurrentImage + 1
            if(self.indexOfCurrentImage >= self.imageArray.count){
                self.indexOfCurrentImage    = self.imageArray.count - 2
                self.imageRollingDirection  = 1
            }
        }else{
            self.indexOfCurrentImage = self.indexOfCurrentImage - 1
            if(self.indexOfCurrentImage <= 0){//反反向
                self.indexOfCurrentImage    = 0
                self.imageRollingDirection  = 0
            }
        }
        
        //print(self.indexOfCurrentImage)
        self.jumpImageIndex(CGFloat(self.indexOfCurrentImage))
    }
    
    func jumpImageIndex(currentIndex:CGFloat){
        pageIndicator.currentPage = self.indexOfCurrentImage
        contentScrollView.setContentOffset(CGPointMake(self.frame.size.width * currentIndex, 0), animated: true)
    }
    
    //图片点击
    func imageTapAction(tap:UIButton){
        self.delegate!.PictureSwitchingTap!(indexOfCurrentImage)
    }
    
    
    //MARK: - UIScrollViewDelegate Methods -
    //拖拽开始
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        //print("Dragging Start")
        self.timeStop()
    }
    
    //拖拽结束
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //print("Dragging End")
        //print(scrollView.contentOffset.x)
        //print(self.frame.width)
        //print(indexOfCurrentImage)
        //self.timeStart()
    }
    
    //滚动加速结束
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //print("EndDecelerating")
        
        let index = scrollView.contentOffset.x / self.frame.width
        self.indexOfCurrentImage = Int(index)
        self.pageIndicator.currentPage = self.indexOfCurrentImage
        self.timeStart()
    }
    
    //动画执行结束
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.delegate?.PictureSwitchingEndScrolling!(self.indexOfCurrentImage)
    }
    
}


//MARK: - 代理 -
@objc protocol PictureSwitchingDelegate{

    //点击图片代理
    optional func PictureSwitchingTap(tapIndex: Int)
    
    //滚动动画结束代理
    optional func PictureSwitchingEndScrolling(currentIndex: Int)
    
    
}
