//
//  NineCellLockView.swift
//
//  Created by midoks on 15/8/20.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit

class SudokuView: UIView {
    
    var fingerPoint:CGPoint = CGPoint()
    var linePointointCollection:Array<CGPoint>  = Array<CGPoint>()
    var ninePointCollection:Array<CGPoint>      = Array<CGPoint>()
    
    var selectPointIndexCollection:Array<Int>   = Array<Int>()
    
    var pswIsRight:Bool                         = true
    var circleRadius:CGFloat                    = 28
    var littleCircleRadius:CGFloat              = 10
    var circleCenterDistance:CGFloat            = 96
    var firstCirclePointX:CGFloat               = 96
    var firstCirclePointY:CGFloat               = 200
    
    func FillNinePointCollection()
    {
        //print("FillNinePointCollection")
        for row in 0...2
        {
            for column in 0...2
            {
                //print(row, column)
                let tempX:CGFloat = CGFloat(column)*self.circleCenterDistance + self.firstCirclePointX
                let tempY:CGFloat = CGFloat(row)*self.circleCenterDistance + self.firstCirclePointY
                self.ninePointCollection.append(CGPoint(x: tempX,y:tempY))
            }
        }
    }
    
    
    func drawCicle(centerPoint:CGPoint,index:Int,context:CGContext)
    {
        
        CGContextSetLineWidth(context, 2.0);
        CGContextAddArc(context, centerPoint.x, centerPoint.y, self.circleRadius, 0.0, CGFloat(M_PI * 2.0), 1)
        let currentIsSelected:Bool = self.selectPointIndexCollection.contains(index)
        
        if(currentIsSelected)
        {
            if(pswIsRight)
            {
                //选中的圆圈的边框颜色不一样
                CGContextSetStrokeColorWithColor(context, UIColor(red: 96/255.0, green: 169/255.0, blue: 252/255.0, alpha: 1).CGColor)
            }else
            {
                CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
            }
            
        }else
        {
            CGContextSetStrokeColorWithColor(context,  UIColor(red: 144/255.0, green: 149/255.0, blue: 173/255.0, alpha: 1).CGColor)
        }
        CGContextStrokePath(context)
        //为了遮住圈内的线
        CGContextAddArc(context, centerPoint.x, centerPoint.y, self.circleRadius, 0.0, CGFloat(M_PI * 2.0), 1)
        CGContextSetFillColorWithColor(context,  UIColor(red: 35/255.0, green: 39/255.0, blue: 54/255.0, alpha: 1).CGColor)
        CGContextFillPath(context)
        
        
        if(currentIsSelected)
        {
            CGContextAddArc(context, centerPoint.x, centerPoint.y, self.littleCircleRadius, 0.0, CGFloat(M_PI * 2.0), 1)
            if(pswIsRight)
            {
                CGContextSetFillColorWithColor(context, UIColor(red: 96/255.0, green: 169/255.0, blue: 252/255.0, alpha: 1).CGColor)
            }else
            {
                CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
            }
            
            CGContextFillPath(context)
        }
        
        
        
        
    }
    
    func drawNineCircle(context:CGContext)
    {
        print("line")
        for p in 0...self.ninePointCollection.count-1
        {
            self.drawCicle(self.ninePointCollection[p],index:p,context:context);
        }
        
    }
    
    override init(frame:CGRect)
    {
        //print("init")
        super.init(frame:frame)
        //26 29 40
        self.backgroundColor = UIColor(red: 35/255.0, green: 39/255.0, blue: 54/255.0, alpha: 1)
        FillNinePointCollection()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func DrawLines()
    {
        
        if(self.selectPointIndexCollection.count > 0)
        {
            let bp = UIBezierPath()
            bp.lineWidth  = 1
            bp.lineCapStyle = kCGLineCapRound
            if(pswIsRight)
            {
                UIColor(red: 96/255.0, green: 169/255.0, blue: 252/255.0, alpha: 1).setStroke()
            }else
            {
                UIColor.redColor().setStroke()
            }
            
            for index in 0...self.selectPointIndexCollection.count-1
            {
                let PointIndex = self.selectPointIndexCollection[index]
                
                if(index == 0)
                {
                    bp.moveToPoint(self.ninePointCollection[PointIndex])
                }
                else
                {
                    bp.addLineToPoint(self.ninePointCollection[PointIndex])
                }
            }
            if self.fingerPoint.x != -100
            {
                bp.addLineToPoint(self.fingerPoint)
            }
            bp.stroke()
        }
        
    }
    
    override func drawRect(rect: CGRect) {
        
        //print("line")
        
        let context = UIGraphicsGetCurrentContext();
        self.DrawLines()
        self.drawNineCircle(context)
        self.DrawTriangleWhenPswIsError(context)
    }
    
    
    func GetAngle(p1:CGPoint,p2:CGPoint)->CGFloat
    {
        let Re:CGFloat  = ((atan(CGFloat((p2.y - p1.y) / (p2.x - p1.x)))))
        if p2.x < p1.x
        {
            return  Re - CGFloat(M_PI)
        }
        return Re
    }
    
    //三角形的顶点距离圆心的距离
    var TriangleTopPointDistanceToCircleCenterPoint:CGFloat = 20
    
    //如果密码密码错误则在选中的圆圈内绘制三角形的路线指示标志
    func DrawTriangleWhenPswIsError(context:CGContext)
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
                
                CGContextSaveGState(context)
                
                CGContextTranslateCTM( context, prePoint.x,prePoint.y )
                CGContextRotateCTM(context, GetAngle(prePoint,p2:currentPoint))
                
                CGContextTranslateCTM( context,0 - prePoint.x,0 - prePoint.y)
                CGContextBeginPath(context)
                CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
                //都是绘制在x坐标的右边 上面几行代码是旋转的逻辑
                CGContextMoveToPoint(context,prePoint.x + self.TriangleTopPointDistanceToCircleCenterPoint - 6, prePoint.y - 6)
                CGContextAddLineToPoint(context, prePoint.x + self.TriangleTopPointDistanceToCircleCenterPoint, prePoint.y)
                CGContextAddLineToPoint(context,prePoint.x + self.TriangleTopPointDistanceToCircleCenterPoint - 6, prePoint.y + 6)
                CGContextClosePath(context)
                CGContextFillPath(context)
                
                CGContextRestoreGState(context)
                
            }
        }
    }
    
    func distanceBetweenTwoPoint(p1:CGPoint,p2:CGPoint)->CGFloat
    {
        return pow(pow((p1.x-p2.x), 2)+pow((p1.y-p2.y), 2), 0.5)
    }
    
    func CircleIsTouchThenPushInSelectPointIndexCollection(fingerPoint:CGPoint)
    {
        
        for index in 0...self.ninePointCollection.count-1
        {
            if(self.selectPointIndexCollection.contains(index))
            {
                if(self.distanceBetweenTwoPoint(fingerPoint,p2:self.ninePointCollection[index]) <= circleRadius)
                {
                    self.selectPointIndexCollection.append(index);
                }
            }
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let t = touches.first
        pswIsRight = true
        self.selectPointIndexCollection.removeAll(keepCapacity: false)
        self.fingerPoint = t!.locationInView(self)
        //print(fingerPoint)
        self.CircleIsTouchThenPushInSelectPointIndexCollection(fingerPoint);
        self.setNeedsDisplay()
    }
    


    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let t = touches.first
        self.fingerPoint = t!.locationInView(self)
        //print(fingerPoint)
        self.CircleIsTouchThenPushInSelectPointIndexCollection(self.fingerPoint);
        self.setNeedsDisplay()
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.fingerPoint.x = -100
        self.setNeedsDisplay()
        pswIsRight = true //模拟密码错误
        if(self.selectPointIndexCollection.count>0)
        {
            var ReStr:String = ""
            for index in 0...self.selectPointIndexCollection.count-1
            {
                ReStr += String(self.selectPointIndexCollection[index]) + ","
            }
            
            let alertV = UIAlertView(title: "您的结果", message: ReStr, delegate: nil, cancelButtonTitle: "我知道了")
            alertV.show()
        }
    }
}
