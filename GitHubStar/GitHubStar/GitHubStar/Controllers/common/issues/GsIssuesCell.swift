//
//  GsIssuesCell.swift
//  GitHubStar
//
//  Created by midoks on 16/3/31.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

class GsIssuesCell:UITableViewCell{
    
    //项目名
    var issuesNumber = UILabel()
    var issuesType = UILabel()
    
    var verticalLine = UILabel()
    
    var issuesTitle = UILabel()
    
    var issuesIconList = Array<GsIssuesIconView>()
    
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
    
    func initView(){
        
        //let w = self.window?.frame.width
        
        issuesNumber.frame = CGRect(x: 10, y: 5, width: 60, height: 20)
        issuesNumber.textAlignment = .center
        issuesNumber.text = "#123"
        //issuesTitle.backgroundColor = UIColor.redColor()
        issuesNumber.textColor = UIColor.gitFontColor()
        issuesNumber.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(issuesNumber)
        
        issuesType.frame = CGRect(x: 10, y: 25, width: 60, height: 20)
        issuesType.textAlignment = .center
        issuesType.text = "Pull"
        issuesType.textColor = UIColor.gray
        issuesType.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(issuesType)
        
    
        verticalLine.frame = CGRect(x: 80, y: 0, width: 0.5, height: 30)
        verticalLine.backgroundColor = UIColor.black
        verticalLine.layer.opacity = 0.3
        contentView.addSubview(verticalLine)
        
        
        issuesTitle.text = "Pull"
        issuesTitle.font = UIFont.systemFont(ofSize: 14)
        //issuesTitle.
        issuesTitle.textColor = UIColor.gitFontColor()
        contentView.addSubview(issuesTitle)
        
        
        for i in 0 ..< 4 {
            
            let v = GsIssuesIconView()
            
            let hrow = CGFloat(i / 2)
            let oddVal = i % 2
            if oddVal == 1 {
                v.frame = CGRect(x: 85 + 110, y: 25 + 20 * CGFloat(hrow), width: 110, height: 20)
            } else {
                v.frame = CGRect(x:85, y: 25 + 20 * CGFloat(hrow), width: 110,height:20)
            }
            
            v.imageView.image = UIImage(named: "repo_branch_min")
            //v.backgroundColor = UIColor.randomColor()
            
            contentView.addSubview(v)
            
            issuesIconList.append(v)
        }
    
        //contentView.addSubview(issuesIconList)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        issuesTitle.frame = CGRect(x: 85, y: 5, width: contentView.frame.width - 90, height: 20)
        
        let h = contentView.frame.height
        verticalLine.frame = CGRect(x: 80, y: h * 0.1, width: 0.5, height: h * 0.8)
    }
}

class GsIssuesIconView: UIView {
    
    var imageView = UIImageView()
    var title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.image = UIImage(named: "repo_branch_min")
        addSubview(imageView)
        
        title.text = "text"
        title.font = UIFont.systemFont(ofSize: 12)
        addSubview(title)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func layoutSubviews() {
        
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.frame.size = CGSize(width: 15, height:15)
        imageView.center.y = self.frame.height/2
        
        title.frame = CGRect(x:20, y:0, width: self.frame.width - 20, height: 20)
    }
    
}
