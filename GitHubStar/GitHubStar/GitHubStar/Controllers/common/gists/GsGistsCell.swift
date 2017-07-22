//
//  GsGistsCell.swift
//  GitHubStar
//
//  Created by midoks on 16/3/31.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

class GsGistsCell:UITableViewCell{
    
    //项目名
    var gistsName = UILabel()
    var timeShow = UILabel()
    var descText = UILabel()
    
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
        
        gistsName = UILabel(frame: CGRect(x: 50, y: 10, width: w - 50 - 10, height: 18))
        gistsName.font = UIFont.systemFont(ofSize: 16)
        gistsName.text = "项目名"
        gistsName.textColor = UIColor.gitFontColor()
        gistsName.font = UIFont.boldSystemFont(ofSize: 16)
        contentView.addSubview(gistsName)
        
        
        timeShow = UILabel(frame: CGRect(x: 50, y: 30, width: w - 50 - 10, height: 13))
        timeShow.font = UIFont.systemFont(ofSize: 12)
        timeShow.text = "3年前"
        timeShow.textColor = UIColor.gray
        //timeShow.backgroundColor = UIColor.randomColor()
        contentView.addSubview(timeShow)
        
        descText.frame = CGRect(x: 50, y: 44, width: w - 50 - 10, height: 0)
        descText.lineBreakMode = .byCharWrapping
        descText.numberOfLines = 0
        //descText.backgroundColor = UIColor.randomColor()
        descText.font = UIFont.systemFont(ofSize: 14)
    }
    
    func getSize(label:UILabel) -> CGSize {
        let size = label.text!.textSizeWithFont(font: label.font, 
                                                constrainedToSize: CGSize(width: label.frame.width, height: CGFloat(MAXFLOAT)))
        return size
    }
    
    func getDescSize(text:String) -> CGSize {
        descText.text = text
        return self.getSize(label: descText)
    }
    
    func setDesc(text:String){
        descText.text = text
        let size = self.getSize(label: descText)
        descText.frame.size.height = size.height
        
        contentView.addSubview(descText)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView?.clipsToBounds = true
        self.imageView?.layer.cornerRadius = 14
        self.imageView?.frame = CGRect(x: 15, y:7, width: 28, height: 28)
        
    }
}
