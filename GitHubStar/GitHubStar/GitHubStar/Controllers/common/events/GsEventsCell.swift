//
//  GsEventsCell.swift
//  GitHubStar
//
//  Created by midoks on 16/5/23.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON


class GsEventsCell: UITableViewCell,TTTAttributedLabelDelegate {
    
    var eventIcon = UIImageView()
    var eventTime = UILabel()
    
    var authorIcon = UIImageView()
    var actionContent = TTTAttributedLabel(frame: CGRect.zero)
    
    var fixHeight:CGFloat = 65.0
    
    var nextList = Array<UILabel>()
    
    var nextContent:UILabel {
        get {
            return UILabel()
        }
        
        set {
            newValue.font = UIFont.systemFont(ofSize: 12)
            newValue.numberOfLines = 0
            newValue.lineBreakMode = .byTruncatingTail
            newValue.frame = CGRect(x: 50, y: fixHeight, width: self.getWinWidth() - 60, height: 0)
            let size = self.getSize(label: newValue)
            newValue.frame.size.height = size.height
            
            //newValue.backgroundColor = UIColor.randomColor()
            self.contentView.addSubview(newValue)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initView()
    }
    
    
    
    //初始化视图
    func initView(){
        let w = self.getWinWidth()
        
        eventIcon.image = UIImage(named: "repo_file")
        eventIcon.frame = CGRect(x: 25, y: 7.5, width: 15, height: 15)
        eventIcon.backgroundColor = UIColor.white
        self.contentView.addSubview(eventIcon)
        
        eventTime.frame = CGRect(x: 50, y: 5, width: w - 50, height: 20)
        eventTime.text = "30分钟前"
        eventTime.textAlignment = .left
        eventTime.font = UIFont.systemFont(ofSize: 10)
        self.contentView.addSubview(eventTime)
        
        
        authorIcon.image = UIImage(named: "avatar_default")
        authorIcon.layer.cornerRadius = 17.5
        authorIcon.frame = CGRect(x: 10, y: 25, width: 35, height: 35)
        authorIcon.clipsToBounds = true
        authorIcon.backgroundColor = UIColor.white
        self.contentView.addSubview(authorIcon)
        
        actionContent.frame = CGRect(x: 50, y: 25, width: w-60, height: 40)
        actionContent.font = UIFont.systemFont(ofSize: 14)
        actionContent.numberOfLines = 0
        actionContent.lineBreakMode = .byTruncatingTail
        actionContent.delegate = self
        actionContent.linkAttributes = [kCTUnderlineStyleAttributeName as AnyHashable : false,
                                        kCTUnderlineColorAttributeName as AnyHashable:true]
        self.contentView.addSubview(actionContent)
    }
    
    func getSize(label:UILabel) -> CGSize {
        let size = label.text!.textSizeWithFont(font: label.font,
                                                constrainedToSize: CGSize(width: label.frame.width, height: CGFloat(MAXFLOAT)))
        return size
    }
    
    func getListHeight() -> CGSize {
        var size = CGSize.zero
        for i in nextList {
            //print(i.text)
            
            i.font = UIFont.systemFont(ofSize: 12)
            i.numberOfLines = 0
            i.lineBreakMode = .byCharWrapping
            
            i.frame =  CGRect(x: 50, y: 0, width: self.getWinWidth() - 60, height:
                0)
            let s = self.getSize(label: i)
            //print(s.height)
            size.height += s.height
        }
        //print("count:",size)
        return size
    }
    
    func showList(){
        
        for i in 0 ..< nextList.count {
            let v = nextList[i]
            v.frame = CGRect(x: 50, y: fixHeight + CGFloat(i*15), width: self.getWinWidth() - 60, height: 15)
            
            v.font = UIFont.systemFont(ofSize: 12)
            v.numberOfLines = 0
            v.lineBreakMode = .byTruncatingTail
            
            //v.backgroundColor = UIColor.randomColor()
            contentView.addSubview(v)
        }
        
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        print(url)
    }
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
