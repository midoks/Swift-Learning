//
//  MDQrcodeReaderViewController.swift
//
//  Created by midoks on 15/11/14.
//  Copyright © 2015年 midoks. All rights reserved.
//


import UIKit
import AVFoundation


class MDQrcodeReaderViewViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    lazy var rdQrcode : MDQrcodeReader = {
        return MDQrcodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
    }()
    
    deinit {
    }
    
    override func viewDidDisappear(animated: Bool) {
        rdQrcode.stopScanning()
    }
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        let leftButton = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MDQrcodeReaderViewViewController.close(_:)))
        self.navigationItem.leftBarButtonItem   = leftButton
        
        if MDQrcodeReader.isCanRun() {
            self.modalPresentationStyle = .FormSheet
        
            /// print(view.frame.size)
            /// print(self.view.bounds)
            rdQrcode.previewLayer.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
            rdQrcode.startScanning()
            
            self.view.layer.insertSublayer(rdQrcode.previewLayer, atIndex: 0)
            
            
            rdQrcode.completionBlock = { (result: String?) in

                let alert = UIAlertController(title: "识别成功", message: result, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (UIAlertAction) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }))
            
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    

    //关闭
    func close(button: UIButton){
        self.dismissViewControllerAnimated(true) { () -> Void in
            print("close")
        }
    }
    
    
    
    
    
}