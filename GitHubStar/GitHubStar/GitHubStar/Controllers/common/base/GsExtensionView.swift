//
//  GsExtensionView.swift
//  GitHubStar
//
//  Created by midoks on 16/4/4.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

extension UIView {

    func getLabelSize(label:UILabel) -> CGSize {
        let size = label.text!.textSizeWithFont(font: label.font,
                                                constrainedToSize: CGSize(width: label.frame.width, height: CGFloat(MAXFLOAT)))
        return size
    }
    
    func getCurrentVc() -> UIViewController {
        let window = UIApplication.shared.keyWindow
        return (window!.rootViewController)!
    }
    
    func getRootVC() -> UIViewController {
        let window = UIApplication.shared.keyWindow
        return (window?.rootViewController)!
    }
    
    func getWinWidth() -> CGFloat {
        let vc = self.getRootVC()
        if vc.view.frame.width != 0 {
            return vc.view.frame.width
        }
        return 320.0
    }

}
