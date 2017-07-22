//
//  GsUserCommentCell.swift
//  GitHubStar
//
//  Created by midoks on 16/4/24.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

//用户提交Cell
class GsUserCommentCell: UITableViewCell {
    
    //头像视图
    var userIcon = UIImageView()
    //项目名
    var userName = UILabel()
    //项目创建时间
    var userCommentTime = UILabel()
    //项目介绍
    var userCommentContent = UILabel()

    let repoH:CGFloat  = 40
    
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
        
        //提交人头像
        userIcon.image = UIImage(named: "avatar_default")
        userIcon.layer.cornerRadius = 15
        userIcon.frame = CGRect(x:5, y: 5, width:30, height:30)
        userIcon.clipsToBounds = true
        userIcon.backgroundColor = UIColor.white
        contentView.addSubview(userIcon)
        
        //提交用户名
        userName = UILabel(frame: CGRect(x: 40, y: 5, width: w-40-140, height: 18))
        userName.font = UIFont.systemFont(ofSize: 16)
        userName.text = "项目名"
        userName.textColor = UIColor(red: 64/255, green: 120/255, blue: 192/255, alpha: 1)
        userName.font = UIFont.boldSystemFont(ofSize: 16)
        contentView.addSubview(userName)
        
        //提交时间
        userCommentTime = UILabel(frame: CGRect(x: 40, y: 23, width: 140, height: 17))
        userCommentTime.font = UIFont.systemFont(ofSize: 12)
        userCommentTime.text = "create at:2008-12-12"
        contentView.addSubview(userCommentTime)
        //userCommentTime.backgroundColor = UIColor.blueColor()
        //
        //提交内容
        userCommentContent.frame = CGRect(x: 40, y: repoH, width: w - 50, height:0)
        userCommentContent.font = UIFont.systemFont(ofSize: 14)
        userCommentContent.text = ""
        userCommentContent.numberOfLines = 0
        userCommentContent.lineBreakMode = .byWordWrapping
        contentView.addSubview(userCommentContent)
        //userCommentContent.backgroundColor = UIColor.blueColor()
        
    }
    
    
    func getCommentSize(text:String) -> CGSize{
        userCommentContent.text = text
        userCommentContent.frame.size.width = self.getWinWidth() - 50
        let size = self.getLabelSize(label: userCommentContent)
        return size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if userCommentContent.text != "" {
            let size = self.getCommentSize(text: userCommentContent.text!)
            userCommentContent.frame.size.height = size.height
        }
    }
    
}
