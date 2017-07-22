//
//  GsUsersIconTableViewCell.swift
//  GitHubStar
//
//  Created by midoks on 16/4/16.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

class GsUsersIconTableViewCell: UITableViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView?.clipsToBounds = true
        self.imageView?.layer.cornerRadius = 14
        self.imageView?.frame = CGRect(x: 15, y: 7, width: 28, height: 28)
        
        self.textLabel?.frame.origin = CGPoint(x: 58.0, y: 0.0)
    }
}
