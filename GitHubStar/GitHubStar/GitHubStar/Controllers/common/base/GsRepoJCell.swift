//
//  GsRepoJCell.swift
//  GitHubStar
//
//  Created by midoks on 16/1/28.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

//项目简单显示Cell
class GsRepoJCell: UITableViewCell {
    
    //头像视图
    var repoIcon = UIImageView()
    //项目名
    var repoName = UILabel()
    //项目创建时间
    var repoCreateTime = UILabel()
    //项目更新时间
    var repoUpdateTime = UILabel()
    //项目介绍
    var repoInstro = UILabel()
    var repoInstroSize = CGSize()
    
    //项目底部列表
    var repoList = Array<UIButton>()
    
    //项目Index
    var repoIndex:NSIndexPath?
    
    let repoH:CGFloat  = 45
    let repoBH:CGFloat = 28
    
    //代理
    var delegate:GsRepoJCellDelegate?
    
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
        
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: repoH+repoBH)
        self.initView()
    }
    
    //初始化视图
    func initView(){
        let w = self.getWinWidth()
        
        //头像
        repoIcon.image = UIImage(named: "avatar_default")
        repoIcon.layer.cornerRadius = 17.5
        repoIcon.frame = CGRect(x: 10, y: 10, width: 35, height: 35)
        repoIcon.clipsToBounds = true
        repoIcon.backgroundColor = UIColor.white
        self.contentView.addSubview(repoIcon)
        
        //项目名
        repoName = UILabel(frame: CGRect(x: 50, y: 10, width: w-50-140, height: 18))
        repoName.font = UIFont.systemFont(ofSize: 16)
        repoName.text = "项目名"
        repoName.textColor = UIColor(red: 64/255, green: 120/255, blue: 192/255, alpha: 1)
        repoName.font = UIFont.boldSystemFont(ofSize: 16)
        self.contentView.addSubview(repoName)
        
        //项目创建时间
        repoCreateTime.frame = CGRect(x: 50, y: 28, width: 140, height: 17)
        repoCreateTime.font = UIFont.systemFont(ofSize: 12)
        repoCreateTime.text = "create at:2008-12-12"
        self.contentView.addSubview(repoCreateTime)
        //repoCreateTime.backgroundColor = UIColor.blueColor()
        
        //项目更新时间
        repoUpdateTime = UILabel(frame: CGRect(x: w - 145, y: 10, width: 140, height: 20))
        repoUpdateTime.font = UIFont.systemFont(ofSize: 12)
        repoUpdateTime.text = "update at:2016-12-11"
        repoUpdateTime.textAlignment = .right
        self.contentView.addSubview(repoUpdateTime)

        //项目介绍
        repoInstro.frame = CGRect(x: 50, y: repoH, width: w - 60, height: 0)
        repoInstro.font = UIFont.systemFont(ofSize: 14)
        repoInstro.text = ""
        repoInstro.numberOfLines = 0
        repoInstro.lineBreakMode = .byWordWrapping
        self.contentView.addSubview(repoInstro)
        //repoInstro.backgroundColor = UIColor.blueColor()
        
    }
    
    
    func getDescSize(text:String) -> CGSize{
        repoInstro.text = text
        repoInstro.frame.size.width = self.getWinWidth() - 60
        let size = self.getLabelSize(label: repoInstro)
        repoInstroSize = size
        return size
    }
    
    func setDesc(text:String) -> CGSize {
        repoInstro.text = text
        let size = self.getDescSize(text: text)
        repoInstro.frame.size.height = size.height
        return size
    }
    
    func addList(i:UIButton){
        i.setTitleColor(UIColor.black, for: .normal)
        i.contentHorizontalAlignment = .left
        i.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        i.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        addSubview(i)
        repoList.append(i)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = getWinWidth()
        var bY = repoH
        
        if repoInstro.text != "" {
            _ = self.getDescSize(text: repoInstro.text!)
            bY += repoInstroSize.height
        }

        let blQ = repoName.frame.origin.x
        let bLW = w - blQ
        let bW = bLW/CGFloat(4)
        
        let repoListCount = repoList.count > 4 ? 4 : repoList.count
        for i in 0 ..< repoListCount {
            
            if i == repoListCount - 1 && i==2 {
                repoList[i].frame = CGRect(x: bW*CGFloat(i)+blQ, y: bY, width: bW*2, height: repoBH)
            } else {
                repoList[i].frame = CGRect(x: bW*CGFloat(i)+blQ, y: bY, width: bW, height: repoBH)
            }
        }
    }
    
    //点击项目图标
    func GsRepoJCellRepoIcon(button:UIButton){
        //print(button)
        self.delegate!.GsRepoJCellRepoIcon!(indexPath: self.repoIndex!)
    }
    
}

//GsRepoJCell代理
@objc protocol  GsRepoJCellDelegate : NSObjectProtocol{
    //头像点击
    @objc optional func GsRepoJCellRepoIcon(indexPath: NSIndexPath)
}
