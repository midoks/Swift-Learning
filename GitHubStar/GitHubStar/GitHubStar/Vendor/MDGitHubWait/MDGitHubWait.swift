//
//  MDGitHubWait.swift
//  GitHubStar
//
//  Created by midoks on 16/3/7.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

class MDGitHubWait: UIView {
    
    var imageBackColor = UIView()
    
    var imageGit:UIImageView = UIImageView()
    var imageGitWH:CGFloat = 60
    
    var imageStar:UIImageView = UIImageView()
    var imageStars = Array<UIImageView>()
    var imageStarWH:CGFloat = 12
    
    var listFrame:Array<CGRect> = Array<CGRect>()
    
    var space:CGFloat = 0.0
    
    var time:CGFloat = 3.0
    
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        
        self.initView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        
        initBackColor()
        
        let imageGitR = floor(sqrt(pow(imageGitWH/2, 2)*2))
        let imageStarR = sqrt(pow(imageStarWH/2, 2)*2)
        let starBL = sqrt(pow((imageGitR + imageStarR + space),2)/2)
        print(imageGitR)
        print(imageStarR)
        print(starBL)
        
        imageGit.image = UIImage(named: "welcome")
        addSubview(imageGit)
        imageGit.frame = CGRect(x: 0, y: 0, width: imageGitWH, height: imageGitWH)
        imageGit.center = center
        
        for _ in 0 ..< 6 {
            listFrame.append(CGRect(x: 0, y: 0 , width: imageStarWH, height: imageStarWH))
        }
        
        var c = 0
        for i in listFrame {
            let img = UIImageView(image: UIImage(named: "github_starred"))
            img.frame = i
            imageStars.append(img)
            addSubview(img)
            
            
            let start = -((Double.pi*2) / Double(listFrame.count)) * Double(c)
            let end = Double.pi + start
            c += 1
            print(start,end)
            
            let path_a = UIBezierPath()
            path_a.addArc(withCenter: center, radius: imageGitR, startAngle: CGFloat(start), endAngle: CGFloat(end), clockwise: false)
            
            let animation = CAKeyframeAnimation(keyPath: "position")
            animation.path = path_a.cgPath
            animation.isRemovedOnCompletion = false
            animation.repeatCount = 1000000
            animation.duration = 1
            
            animation.autoreverses = true
            animation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)]
            img.layer.add(animation, forKey: "animation")
        }
        
        
        
        //rotationAnimation()
        
    }
    
    func rotationAnimation(){
    
    }
    
    func initBackColor(){
        //imageBackColor.frame = UIApplication.sharedApplication().windows.first!.frame
        //imageBackColor.backgroundColor = UIColor.blackColor()
        //imageBackColor.layer.opacity = 0.1
        //addSubview(imageBackColor)
        //UIApplication.sharedApplication().windows.first?.addSubview(imageBackColor)
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print(self.imageGit.frame)
    }


    
    
}
