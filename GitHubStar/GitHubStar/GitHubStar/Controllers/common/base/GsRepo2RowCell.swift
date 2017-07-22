//
//  Gs.swift
//  GitHubStar
//
//  Created by midoks on 16/4/3.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

class GsRepo2RowCell: UITableViewCell {
    
    //row1
    var row1 = UIButton()
    //row2
    var row2 = UIButton()
    
    let line1 = UIView()
    let lineBottom = UIView()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initView()
    }
    
    func initView(){
        
        self.row1.setTitle("tt", for: .normal)
        self.row1.setTitleColor(UIColor.black, for: .normal)
        self.row1.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        self.row1.setImage(UIImage(named: "bar_me"), for: .normal)
        self.row1.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0)
        self.row1.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0)
        self.row1.contentHorizontalAlignment = .left
        self.contentView.addSubview(self.row1)
        
        self.row2.setTitle("3k", for: .normal)
        self.row2.setTitleColor(UIColor.black, for: .normal)
        self.row2.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        self.row2.setImage(UIImage(named: "bar_me"), for: .normal)
        self.row2.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0)
        self.row2.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0)
        self.row2.contentHorizontalAlignment = .left
        self.contentView.addSubview(self.row2)
        
        
        self.line1.backgroundColor = UIColor.gray
        self.line1.layer.opacity = 0.3
        self.addSubview(self.line1)
        
        self.lineBottom.backgroundColor = UIColor.gray
        self.lineBottom.layer.opacity = 0.3
        self.addSubview(self.lineBottom)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = self.frame.width / 2
        let h = self.frame.height
        
        
        
        self.line1.frame = CGRect(x: w - 0.5, y: 0, width: 0.5, height: h)
        self.lineBottom.frame = CGRect(x: 0, y: h - 0.5, width: w, height: 0.5)
        
        self.row1.frame = CGRect(x: 0,y: 0,width: w, height:h)
        self.row2.frame = CGRect(x: w,y: 0,width: w, height:h)
    }
    
}
