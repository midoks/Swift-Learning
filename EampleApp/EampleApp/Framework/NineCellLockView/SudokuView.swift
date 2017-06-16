//
//  NineCellLockView.swift
//
//  Created by midoks on 15/8/20.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit

class SudokuView: UIView {
    
    var delegate: SudokuViewDelegate?
    
    var fingerPoint:CGPoint = CGPoint()
    var linePointointCollection:Array<CGPoint>  = Array<CGPoint>()
    var ninePointCollection:Array<CGPoint>      = Array<CGPoint>()
    var selectPointIndexCollection:Array<Int>   = Array<Int>()
    
    //密码默认正确
    var pswIsRight:Bool                         = true
    //圆圈的宽度
    var circleRadius:CGFloat                    = 28
    //连接线宽度
    var littleCircleRadius:CGFloat              = 15
    
    //密文
    var ciphertext:NSString?
    
    //初始化9个点的坐标
    override init(frame:CGRect){
        super.init(frame:frame)
        //设置背景
        self.backgroundColor = UIColor(red: 35/255.0, green: 39/255.0, blue: 54/255.0, alpha: 1)
        //计算9个坐标位置
        self.fillNinePointCollection()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 计算9个坐标位置 -
    func fillNinePointCollection(){
        
        //宽度为300,找到起点
        let widthLimit = (self.frame.width - 300) / 2
        //高度为300,找到起点
        let heightLimit = (self.frame.height - 300)/2
        
        
        //1:x,y 第一个坐标点
        let xRowOne = widthLimit + 50
        let yColumnOne = heightLimit + 50
        
        for row in 0...2
        {
            for column in 0...2
            {
                let tempX:CGFloat = xRowOne + CGFloat(row) * 100
                let tempY:CGFloat = yColumnOne + CGFloat(column) * 100
                self.ninePointCollection.append(CGPoint(x: tempX,y:tempY))
            }
        }
    }
    
    //MARK: - 初始化画图 -
    override func draw(_ rect: CGRect) {
        //print("1")
        let context = UIGraphicsGetCurrentContext()
        self.DrawLines()
        //9个圆圈
        self.drawNineCircle(context!)
        //画错误时的颜色
        self.DrawTriangleWhenPswIsError(context!)
    }
    
    func drawCicle(_ centerPoint:CGPoint,index:Int,context:CGContext){
        
        context.setLineWidth(2.0)
        
        //context.addArc(tangent1End: CGPoint(CGFloat(centerPoint.x),CGFloat(centerPoint.y)), tangent2End: CGPoint(CGFloat(M_PI * 2.0), 1), radius: self.circleRadius)
    
        
        let currentIsSelected:Bool = self.selectPointIndexCollection.contains(index)
        
        if(currentIsSelected){
            if(pswIsRight){
                //选中的圆圈的边框颜色不一样
                context.setStrokeColor(UIColor(red: 96/255.0, green: 169/255.0, blue: 252/255.0, alpha: 1).cgColor)
            }else{
                context.setStrokeColor(UIColor.red.cgColor)
            }
            
        }else{
            context.setStrokeColor(UIColor(red: 144/255.0, green: 149/255.0, blue: 173/255.0, alpha: 1).cgColor)
        }
        
        context.strokePath()
        //为了遮住圈内的线
        //CGContextAddArc(context, centerPoint.x, centerPoint.y, self.circleRadius, 0.0, CGFloat(M_PI * 2.0), 1)
        context.setFillColor(UIColor(red: 35/255.0, green: 39/255.0, blue: 54/255.0, alpha: 1).cgColor)
        context.fillPath()
        
        
        //CGContext.addArc(CGContext)
        if(currentIsSelected){
            //CGContext.addArc(context, centerPoint.x, centerPoint.y, self.littleCircleRadius, 0.0, CGFloat(M_PI * 2.0), 1)
            if(pswIsRight){
                context.setFillColor(UIColor(red: 96/255.0, green: 169/255.0, blue: 252/255.0, alpha: 1).cgColor)
            }else{
                context.setFillColor(UIColor.red.cgColor)
            }
            context.fillPath()
        }
    }
    
    func drawNineCircle(_ context:CGContext){
        for p in 0...self.ninePointCollection.count - 1 {
            self.drawCicle(self.ninePointCollection[p],index:p,context:context)
        }
    }
    
    //画链接线
    func DrawLines(){
        if(self.selectPointIndexCollection.count > 0) {
            let bp = UIBezierPath()
            bp.lineWidth  = 5
            bp.lineCapStyle = CGLineCap.round
            
            if(pswIsRight) {
                UIColor(red: 96/255.0, green: 169/255.0, blue: 252/255.0, alpha: 1).setStroke()
            } else {
                UIColor.red.setStroke()
            }
            
            for index in 0...self.selectPointIndexCollection.count-1 {
                let PointIndex = self.selectPointIndexCollection[index]
                
                if(index == 0) {
                    bp.move(to: self.ninePointCollection[PointIndex])
                } else {
                    bp.addLine(to: self.ninePointCollection[PointIndex])
                }
            }
            if self.fingerPoint.x != -100 {
                bp.addLine(to: self.fingerPoint)
            }
            bp.stroke()
        }
    }
    
    
    
    func GetAngle(_ p1:CGPoint,p2:CGPoint)->CGFloat {
        let Re:CGFloat  = ((atan(CGFloat((p2.y - p1.y) / (p2.x - p1.x)))))
        if p2.x < p1.x {
            return  Re - CGFloat(Double.pi)
        }
        return Re
    }
    
    //三角形的顶点距离圆心的距离
    var TriangleTopPointDistanceToCircleCenterPoint:CGFloat = 20
    
    //如果密码密码错误则在选中的圆圈内绘制三角形的路线指示标志
    func DrawTriangleWhenPswIsError(_ context:CGContext)
    {
        if(pswIsRight)
        {
            return
        }
        if self.selectPointIndexCollection.count <= 1
        {
            return
        }
        
        for index in 0...self.selectPointIndexCollection.count-1
        {
            let preIndex:Int = index - 1
            
            if(preIndex >= 0 )
            {
                let prePointIndex:Int = self.selectPointIndexCollection[preIndex]
                let currentPointIndex:Int = self.selectPointIndexCollection[index]
                let currentPoint :CGPoint  = self.ninePointCollection[currentPointIndex]
                let prePoint:CGPoint  = self.ninePointCollection[prePointIndex]
                
                context.saveGState()
                
                context.translateBy(x: prePoint.x,y: prePoint.y )
                context.rotate(by: GetAngle(prePoint,p2:currentPoint))
                
                context.translateBy(x: 0 - prePoint.x,y: 0 - prePoint.y)
                context.beginPath()
                context.setFillColor(UIColor.red.cgColor)
                //都是绘制在x坐标的右边 上面几行代码是旋转的逻辑
                context.move(to: CGPoint(x: prePoint.x + self.TriangleTopPointDistanceToCircleCenterPoint - 6, y: prePoint.y - 6))
                context.addLine(to: CGPoint(x: prePoint.x + self.TriangleTopPointDistanceToCircleCenterPoint, y: prePoint.y))
                context.addLine(to: CGPoint(x: prePoint.x + self.TriangleTopPointDistanceToCircleCenterPoint - 6, y: prePoint.y + 6))
                context.closePath()
                context.fillPath()
                
                context.restoreGState()
            }
        }
    }
    
    func distanceBetweenTwoPoint(_ p1:CGPoint,p2:CGPoint)->CGFloat{
        return pow(pow((p1.x-p2.x), 2)+pow((p1.y-p2.y), 2), 0.5)
    }
    
    
    //加入触摸的点
    func CircleIsTouchThenPushInSelectPointIndexCollection(_ fingerPoint:CGPoint){
        for index in 0...self.ninePointCollection.count-1 {
            if(!self.selectPointIndexCollection.contains(index)) {
                if(self.distanceBetweenTwoPoint(fingerPoint,p2:self.ninePointCollection[index]) <= circleRadius) {
                    self.selectPointIndexCollection.append(index)
                }
            }
        }
    }
    
    //设置密文
    internal func setPwd(_ ciphertext: NSString){
        self.ciphertext = ciphertext
    }
    
    //判断是否是正确的密文
    func isRightPwd() -> Bool {
        
        let ReStrVal = self.getCurrentPwd()
        let ReStrLen = ReStrVal.length
        
        if(self.ciphertext != nil){
            let subRetValStr = self.ciphertext!.substring(with: NSMakeRange(0, ReStrLen))
            if(subRetValStr != ReStrVal as String){
                return false
            }
        }
        
        return true
    }
    
    //获取正确的密码
    func getCurrentPwd() -> NSString {
        if( self.selectPointIndexCollection.count > 0 ) {
            var ReStr:String = ""
            for index in 0...self.selectPointIndexCollection.count - 1
            {
                ReStr += String(self.selectPointIndexCollection[index])
            }
            
            let ReStrVal = NSString(string: ReStr)
            return ReStrVal
        }
        return ""
    }
    
    func touchesCommon(_ status: NSString){
        let pwd = self.getCurrentPwd()
        if(self.isRightPwd()){
            pswIsRight = true
            self.delegate!.SudokuViewOk!(pwd, status: status)
        }else{
            pswIsRight = false
            self.delegate!.SudokuViewFail!(pwd, status: status)
        }
    }
    
    //MARK: - touch事件 -
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.first
        self.selectPointIndexCollection.removeAll(keepingCapacity: false)
        //获取触摸的坐标
        self.fingerPoint = t!.location(in: self)
        self.CircleIsTouchThenPushInSelectPointIndexCollection(fingerPoint)
        self.touchesCommon("began")
        self.setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.first
        self.fingerPoint = t!.location(in: self)
        self.CircleIsTouchThenPushInSelectPointIndexCollection(self.fingerPoint)
        self.touchesCommon("moved")
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchesCommon("end")
        self.selectPointIndexCollection = []
        self.setNeedsDisplay()
    }
}


@objc protocol SudokuViewDelegate {
    
    @objc optional func SudokuViewFail(_ pwd:NSString, status: NSString)
    @objc optional func SudokuViewOk(_ pwd: NSString, status: NSString)
    
}
