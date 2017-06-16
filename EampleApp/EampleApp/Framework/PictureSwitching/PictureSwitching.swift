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
    var timer:              Timer?               //计时器
    
    
    //图片列表
    var imageArray: [UIImage?]!
    
    //当前的现实第几张图片
    var indexOfCurrentImage: Int!
    var imageRollingDirection: Int!
    
    //代理
    var delegate: PictureSwitchingDelegate?
    
    
    //MARK: - Start -
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(frame: CGRect, imageArray: [UIImage?]? ) {
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
    fileprivate func setUp(){
        //print(imageArray.count)
        
        //循环
        if(self.imageArray.count > 0){
            
            self.contentScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            contentScrollView.contentSize = CGSize(width: self.frame.size.width * CGFloat(self.imageArray.count), height: 0)
            contentScrollView.delegate = self
            contentScrollView.bounces = false
            contentScrollView.isPagingEnabled = true
            contentScrollView.backgroundColor = UIColor.green
            contentScrollView.showsHorizontalScrollIndicator = false
            contentScrollView.isScrollEnabled = !(imageArray.count == 1)
            self.addSubview(contentScrollView)
            
            for i in 0 ..< self.imageArray.count {
                let imgView = UIImageView()
                imgView.frame = CGRect(x: self.frame.size.width * CGFloat(i), y: 0, width: self.frame.size.width, height: 200)
                imgView.isUserInteractionEnabled = true
                imgView.contentMode = UIViewContentMode.scaleAspectFill
                imgView.clipsToBounds = true
                contentScrollView.addSubview(imgView)
                imgView.image = self.imageArray[i]
                
                //添加点击事件
                let imageTap = UITapGestureRecognizer(target: self, action: #selector(PictureSwitching.imageTapAction(_:)))
                imgView.addGestureRecognizer(imageTap)
            }
        }
        
        
        //设置分页指示器
        
        //显示在右边
//        self.pageIndicator = UIPageControl(frame: CGRectMake(self.frame.size.width - 20 * CGFloat(imageArray.count),
//            self.frame.size.height - 30,
//            20 * CGFloat(imageArray.count),
//            20))
        
        self.pageIndicator = UIPageControl(frame: CGRect(x: 0, y: self.frame.size.height - 20, width: self.frame.size.width, height: 20))
        
        pageIndicator.hidesForSinglePage = true
        pageIndicator.numberOfPages = imageArray.count
        pageIndicator.backgroundColor = UIColor.clear
        self.addSubview(pageIndicator)
        
        //设置计时器
        self.timeStart()
    }
    
    //定时开始
    func timeStart(){
        if(self.timer == nil){
            self.timer = Timer.scheduledTimer(timeInterval: 2, target: self,
                    selector: #selector(PictureSwitching.timerAction), userInfo: nil, repeats: true)
        }
    }
    
    //取消定时
    func timeStop(){
        if(self.timer != nil){
            self.timer!.invalidate()
            self.timer = nil
        }
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
    
    func jumpImageIndex(_ currentIndex:CGFloat){
        pageIndicator.currentPage = self.indexOfCurrentImage
        contentScrollView.setContentOffset(CGPoint(x: self.frame.size.width * currentIndex, y: 0), animated: true)
    }
    
    //图片点击
    func imageTapAction(_ tap:UIButton){
        self.delegate!.PictureSwitchingTap!(indexOfCurrentImage)
    }
    
    
    //MARK: - UIScrollViewDelegate Methods -
    //拖拽开始
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //print("Dragging Start")
        self.timeStop()
    }
    
    //拖拽结束
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //print("Dragging End")
        //print(scrollView.contentOffset.x)
        //print(self.frame.width)
        //print(indexOfCurrentImage)
        //self.timeStart()
    }
    
    //滚动加速结束
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //print("EndDecelerating")
        
        let index = scrollView.contentOffset.x / self.frame.width
        self.indexOfCurrentImage = Int(index)
        self.pageIndicator.currentPage = self.indexOfCurrentImage
        self.timeStart()
    }
    
    //动画执行结束
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.delegate?.PictureSwitchingEndScrolling!(self.indexOfCurrentImage)
    }
    
}


//MARK: - 代理 -
@objc protocol PictureSwitchingDelegate{

    //点击图片代理
    @objc optional func PictureSwitchingTap(_ tapIndex: Int)
    
    //滚动动画结束代理
    @objc optional func PictureSwitchingEndScrolling(_ currentIndex: Int)
    
    
}
