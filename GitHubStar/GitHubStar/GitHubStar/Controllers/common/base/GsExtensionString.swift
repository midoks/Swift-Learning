//
//  GsExtensionString.swift
//  GitHubStar
//
//  Created by midoks on 16/4/3.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

extension String {
    
    func textSize(font: UIFont, constrainedToSize size:CGSize) -> CGSize {
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let attributes = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let stringRect = self.boundingRect(with: size, options: option,
                                                   attributes: attributes as? [String : AnyObject], context: nil)
        
        return stringRect.size
    }
    
    func textSize(font:UIFont, width:CGFloat) ->CGFloat {
        
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let attributes = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let rect = self.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: option,attributes: attributes as? [String : AnyObject], context: nil)
        return rect.size.height
    }
    
    func textSizeWithFont(font: UIFont, constrainedToSize size:CGSize) -> CGSize {
        var textSize:CGSize!
        if size.equalTo(CGSize.zero) {
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
            textSize = self.size(attributes: attributes as? [String : AnyObject])
        } else {
            //NSStringDrawingOptions.UsesLineFragmentOrigin || NSStringDrawingOptions.UsesFontLeading
            let option = NSStringDrawingOptions.usesLineFragmentOrigin
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
            let stringRect = self.boundingRect(with: size, options: option, attributes: attributes as? [String : AnyObject], context: nil)
            textSize = stringRect.size
        }
        return textSize
    }
}
