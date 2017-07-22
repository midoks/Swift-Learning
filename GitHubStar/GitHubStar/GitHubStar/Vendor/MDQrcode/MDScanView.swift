
//
//  GsScanView.swift
//  GitHubStar
//
//  Created by midoks on 16/5/8.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

class MDScanView: UIView {
    
    lazy var _scanRect:CGRect = {
        //获取扫描范围
        var r = CGRect(x: 0, y: 0, width: self.frame.width*0.6, height: self.frame.width*0.6)
        r.origin.x = (self.frame.width - self.frame.width*0.6)/2
        r.origin.y = (self.frame.height - self.frame.width*0.6)/2
        return r
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){

        
        let u = UIImageView(image: UIImage(named: "scan_pick_bg"))
        u.frame = _scanRect
        addSubview(u)
        
        
        
        let uline = UIImageView(image: UIImage(named: "scan_line"))
        uline.frame = CGRect(x: u.frame.origin.x, y: u.frame.origin.y, width: u.frame.size.width, height: 4)
        addSubview(uline)
        
        let animationPoint = CGPoint(x: uline.center.x, y: u.frame.origin.y + self.frame.width*0.6)
        
        let lineAnimation = CABasicAnimation(keyPath: "position")
        
        lineAnimation.duration = 3
        lineAnimation.fillMode = kCAMediaTimingFunctionEaseOut
        lineAnimation.isRemovedOnCompletion = false
        //lineAnimation.delegate = self
        lineAnimation.repeatCount = Float(CGFloat.greatestFiniteMagnitude)
        lineAnimation.toValue = NSValue(cgPoint: animationPoint)
        
        uline.layer.add(lineAnimation, forKey: "uline")
        
        
        let _shadowLayer = CAShapeLayer()
        _shadowLayer.path = UIBezierPath(rect: self.bounds).cgPath
        _shadowLayer.fillColor = UIColor(white: 0, alpha: 0.75).cgColor
        _shadowLayer.mask = self.generateMaskLayerWithRect(rect: self.bounds, exceptRect: _scanRect)
        self.layer.addSublayer(_shadowLayer)
        
        var scanRectK = _scanRect
        scanRectK.origin.x -= 1
        scanRectK.origin.y -= 1
        scanRectK.size.width += 2
        scanRectK.size.height += 2
        
        let _scanRectLayer = CAShapeLayer()
        _scanRectLayer.path = UIBezierPath(rect: _scanRect).cgPath
        _scanRectLayer.fillColor = UIColor.clear.cgColor
        _scanRectLayer.strokeColor = UIColor(red: 222, green: 222, blue: 222, alpha: 1).cgColor
        self.layer.addSublayer(_scanRectLayer)
    }
    
    //生成空缺部分rect的layer
    func generateMaskLayerWithRect(rect:CGRect, exceptRect:CGRect) -> CAShapeLayer {
        let maskLayer = CAShapeLayer()
        
        if !rect.contains(exceptRect) {
            return maskLayer
        } else if (rect.equalTo(CGRect.zero)) {
            maskLayer.path = UIBezierPath(rect: rect).cgPath
            return maskLayer
        }
        
        let boundsInitX = rect.minX
        let boundsInitY = rect.minY
        let boundsWidth = rect.width
        let boundsHeight = rect.height
        
        let minX = exceptRect.minX
        let maxX = exceptRect.maxX
        let minY = exceptRect.minY
        let maxY = exceptRect.maxY
        let width = exceptRect.width
        
        let path = UIBezierPath(rect: CGRect(x: boundsInitX, y: boundsInitY, width: minX, height: boundsHeight))
        path.append(UIBezierPath(rect: CGRect(x: minX, y: boundsInitY, width: width, height:
            minY)))
        path.append(UIBezierPath(rect: CGRect(x: maxX, y: boundsInitY, width: boundsWidth-maxX, height: boundsHeight)))
        path.append(UIBezierPath(rect: CGRect(x: minX, y: maxY, width: width, height: boundsHeight - maxY)))
        
        maskLayer.path = path.cgPath
        return maskLayer
    }
    
    
    
    
    
}
