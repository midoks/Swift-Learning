//
//
//  Created by midoks on 15/12/30.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit

class MDDropDownBackView:UIView {
    
    var _backView:UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        //背景色
        _backView = UIView(frame: frame)
        _backView!.backgroundColor = UIColor.black
        _backView!.layer.opacity = 0.2
        addSubview(_backView!)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //点击消失
    func tap(){
        
        UIView.animate(withDuration: 0.25, delay: 0,
                                   options: UIViewAnimationOptions.curveLinear,
                                   animations: { () -> Void in
                                    self.layer.opacity = 0.0
        }) { (status) -> Void in
            self.hide()
            self.layer.opacity = 1
        }
    }
    
    func hide(){
        self.removeFromSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self._backView?.frame = frame
    }
    
}

class MDDropDownListView:UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//下拉类
class MDDropDownList : UIView {
    
    var listClick:(( _ tag:Int) -> ())?
    
    var bbView:MDDropDownBackView?
    var listView:UIView?
    
    var listButton: Array<UIButton> = Array<UIButton>()
    var listTriangleButton:UIButton?
    
    var listSize:CGSize = CGSize(width: 150.0, height: 50.0)
    var listImageSize:CGSize = CGSize(width: 40.0, height: 30.0)
    var navHeight:CGFloat = 64.0
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.bbView = MDDropDownBackView(frame: frame)
        
        self.listView = MDDropDownListView(frame: CGRect(x: frame.width - self.listSize.width - 5, y: self.navHeight, width: self.listSize.width, height: 0))
        self.listView!.backgroundColor = UIColor.white
        self.listView!.layer.cornerRadius = 3
        self.bbView?.addSubview(self.listView!)
        
        self.listTriangleButton = UIButton(frame: CGRect(x: frame.width - 33, y: self.navHeight - 13, width: 15, height: 15))
        self.listTriangleButton?.setTitle("▲", for: .normal)
        self.listTriangleButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        self.bbView?.addSubview(self.listTriangleButton!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //重新设置位置
    func setViewFrame(frame: CGRect){
        
        if UIDevice.current.orientation.isLandscape {
            self.listView?.frame = CGRect(x: frame.width - self.listSize.width - 5, y: self.navHeight+1, width: self.listSize.width, height: self.listView!.frame.height)
            self.listTriangleButton?.frame = CGRect(x: frame.width - 35, y: self.navHeight - 11, width: 15, height: 15)
        } else {
            
            self.listView?.frame = CGRect(x: frame.width - self.listSize.width - 5, y: self.navHeight, width: self.listSize.width, height: self.listView!.frame.height)
            self.listTriangleButton?.frame = CGRect(x: frame.width - 33, y: self.navHeight - 12, width: 15, height: 15)
        }
        
        self.bbView?.frame = frame
        self.frame = frame
    }
    
    //MARK: - Private Methods -
    
    //生成纯色背景
    func imageWithColor(color:UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.height, height: size.height)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    //点击
    func listClick(s:UIButton){
        
        //if listClick != nil {
            //listClick?(tag: s.tag)
        //}
        
//        self.hide()
//        self.touchDragOutside(s: s)
    }
    
    //鼠标按下操作
    func touchDown(s:UIButton){
        //s.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    }
    
    //鼠标按下离开操作
    func touchDragOutside(s:UIButton){
        s.backgroundColor = UIColor.white
    }
    
    //添加按钮
    func add(icon:UIImage, title:String){
        
        let c = self.listButton.count
        
        let bheight = self.listSize.height * CGFloat(c)
        let bbViewHeight = self.listSize.height * CGFloat(c+1)
        
        self.listView?.frame = CGRect(x: (self.listView?.frame.origin.x)!, y: (self.listView?.frame.origin.y)!, width: (self.listView?.frame.size.width)!, height: bbViewHeight)
        
        let u = UIButton(frame: CGRect(x: 0, y: bheight, width: self.listSize.width, height: self.listSize.height))
        
        u.tag = c
        u.setImage(icon, for: .normal)
        u.setImage(icon, for: .highlighted)
        u.setTitle(title, for: .normal)
        
        u.setTitleColor(UIColor.black, for: .normal)
        u.layer.cornerRadius = 3
        u.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        u.backgroundColor = UIColor.white
        u.contentHorizontalAlignment = .left
        
        
        u.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
        u.titleEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0)
        
        u.addTarget(self, action: Selector(("listClick:")), for: UIControlEvents.touchUpInside)
//        u.addTarget(self, action: "touchDown:", for: UIControlEvents.touchDown)
//        u.addTarget(self, action: "touchDragOutside:", for: UIControlEvents.touchDragOutside)
        
        if ( c>0 ) {
            let line = UIView(frame: CGRect(x: 0, y: 0, width: u.frame.width, height: 1))
            line.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
            u.addSubview(line)
        }
        
        self.listView!.addSubview(u)
        self.listButton.append(u)
    }
    
    //动画显示特效
    func showAnimation(){
        
        UIApplication.shared.windows.first?.addSubview(self.bbView!)
        
        let sFrame = self.listView?.frame
        
        self.listView?.frame.size = CGSize(width: 0.0, height: 0.0)
        self.listView?.frame.origin.x = sFrame!.origin.x + (sFrame?.width)!
        
        self.listView?.layer.opacity = 0
        self.listTriangleButton?.layer.opacity = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            
            self.listView?.frame.size.height += sFrame!.size.height
            self.listView?.frame.origin.x -= (sFrame?.width)!
            
            self.listView?.layer.opacity = 1
            self.listTriangleButton?.layer.opacity = 0.6
        }) { (status) -> Void in
            
            
            self.listView?.layer.opacity = 1
            self.listTriangleButton?.layer.opacity = 1
            
            self.listView?.frame = sFrame!
        }
    }
    
    //隐藏
    func hide(){
        self.bbView!.removeFromSuperview()
    }
    
}
