//
//  ViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/4/16.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

class GsRepoPullCell:UITableViewCell {
    
    //项目名
    var pullName = UILabel()
    var timeShow = UILabel()
    
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
        
        let w = self.getWinWidth()
        
        pullName = UILabel(frame: CGRect(x: 50, y: 10, width: w - 50 - 10, height: 18))
        pullName.font = UIFont.systemFont(ofSize: 16)
        pullName.text = "项目名"
        pullName.lineBreakMode = .byCharWrapping
        pullName.numberOfLines = 0
        pullName.textColor = UIColor.gitFontColor()
        pullName.font = UIFont.boldSystemFont(ofSize: 16)
        contentView.addSubview(pullName)
        
        
        timeShow = UILabel(frame: CGRect(x: 50, y: 30, width:w - 50 - 10, height: 13))
        timeShow.font = UIFont.systemFont(ofSize: 12)
        timeShow.text = "3年前"
        timeShow.textColor = UIColor.gray
        //timeShow.backgroundColor = UIColor.randomColor()
        contentView.addSubview(timeShow)
    }
    
    
    func getSize(label:UILabel) -> CGSize {
        let size = label.text!.textSizeWithFont(font: label.font,
                                                constrainedToSize: CGSize(width: label.frame.width, height:CGFloat(MAXFLOAT)))
        return size
    }
    
    func setPullNameText(text:String){
        self.pullName.text = text
        let size = self.getSize(label: self.pullName)
        self.pullName.frame.size.height = size.height
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView?.clipsToBounds = true
        self.imageView?.layer.cornerRadius = 14
        self.imageView?.frame = CGRect(x: 15, y: 7, width: 28, height: 28)
        
        
        let w = self.getWinWidth()
        let h = self.pullName.frame.origin.y + self.pullName.frame.size.height
        //print(h)
        timeShow.frame = CGRect(x: 50,  y: h + 2, width: w - 50 - 10, height: 13)
    }
}
